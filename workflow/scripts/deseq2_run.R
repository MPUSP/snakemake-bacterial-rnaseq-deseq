# Load required libraries
suppressWarnings({
  suppressPackageStartupMessages({
    library(readr)
    library(tibble)
    library(dplyr)
    library(tidyr)
    library(stringr)
    library(DESeq2)
    library(BiocParallel)
  })
})

# parameters
counts_file <- snakemake@input[["counts_filtered"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
genome_gff <- snakemake@input[["gff"]]
deseq_results_file <- snakemake@output[["deseq_results"]]
deseq_data_file <- snakemake@output[["deseq_data"]]
design <- snakemake@config$deseq2$design
shrink <- snakemake@config$deseq2$lfc_shrinkage
shrink_type <- snakemake@config$deseq2$lfc_shrinkage_type
n_cores <- snakemake@threads
threshold_pval <- snakemake@config$deseq2$threshold_pval
if (is.null(threshold_pval) || is.na(threshold_pval)) threshold_pval <- 0.05
threshold_log2fc <- snakemake@config$deseq2$threshold_log2fc
if (is.null(threshold_log2fc) || is.na(threshold_log2fc)) threshold_log2fc <- 1.0
messages <- c()

# import data
df_counts <- read_csv(counts_file, show_col_types = FALSE)
annot_cols <- intersect(c("locus_tag", "old_locus_tag", "trivial_name", "gene_biotype"), colnames(df_counts))
df_annotation <- dplyr::select(df_counts, all_of(annot_cols))
df_sample <- read_tsv(samplesheet_file, show_col_types = FALSE) %>%
  mutate(replicate = as.character(replicate))

metadata <- data.frame(
  condition = factor(df_sample$condition, unique(df_sample$condition)),
  replicate = factor(df_sample$replicate, unique(df_sample$replicate)),
  row.names = setdiff(colnames(df_counts), annot_cols)
)

# check that the order of file names corresponds to colnames of counts
if (!all(colnames(dplyr::select(df_counts, -any_of(annot_cols))) == df_sample$sample)) {
  messages <- append(messages, paste0(
    "Sample names of sample sheet and counts ",
    "matrix do not correspond, reordering."
  ))
}
df_counts <- df_counts[c("locus_tag", df_sample$sample)]

# check study design
n_conditions <- length(levels(metadata$condition))
n_replicates <- length(levels(metadata$replicate))
for (fact in c("condition", "replicate")) {
  if (grepl(fact, design) & get(paste0("n_", fact, "s")) <= 1) {
    stop("found less than 2 ", fact, "s: can not use a design which contains '~ ", fact, "'.")
  }
}

# define the comparisons for conditions
if (grepl("condition", design)) {
  if (all(is.na(df_sample$reference))) {
    df_comparison <- df_sample %>%
      mutate(reference = condition[1]) %>%
      select(condition, reference) %>%
      filter(condition != reference) %>%
      distinct() %>%
      mutate(factor = "condition")
    messages <- append(messages, paste0(
      "making ", nrow(df_comparison),
      " comparisons by contrasting the first condition against all others"
    ))
  } else {
    df_comparison <- df_sample %>%
      filter(!is.na(reference)) %>%
      dplyr::select(condition, reference) %>%
      distinct() %>%
      tidyr::separate_longer_delim(reference, delim = ",") %>%
      distinct() %>%
      filter(!condition == reference) %>%
      mutate(factor = "condition")
    messages <- append(messages, paste0(
      "making ", nrow(df_comparison), " comparisons as stated in the sample sheet"
    ))
  }
} else {
  df_comparison <- tibble()
}

# define the comparisons for replicates
if (grepl("replicate", design)) {
  df_comparison <- bind_rows(
    df_comparison,
    df_sample %>%
      pull(replicate) %>%
      tidyr::crossing(., .) %>%
      setNames(c("condition", "reference")) %>%
      distinct() %>%
      filter(!condition == reference) %>%
      mutate(factor = "replicate")
  )
  messages <- append(messages, paste0(
    "making ", nrow(filter(df_comparison, factor == "replicate")),
    " comparisons by contrasting all replicates against each other"
  ))
}

# check that conditions and references do not contain the string '_vs_'
if (
  grepl("condition", design) &&
  nrow(filter(df_comparison, if_any(c(condition, reference), ~ str_detect(., "_vs_"))))
) {
  stop("found string '_vs_' in condition or reference names, which is not allowed")
}

# DESeq data set
quiet_deseq <- purrr::quietly(DESeq2::DESeq)
deseq_data <- DESeqDataSetFromMatrix(
  countData = df_counts[-1],
  colData = metadata,
  design = formula(design)
) %>%
  quiet_deseq()

messages <- append(messages, deseq_data$messages)
deseq_data <- deseq_data$result

if (shrink) {
  messages <- append(messages, paste0(
    "applying log2-FC shrinkage using method: ", shrink_type
  ))
  quiet_shrink <- purrr::quietly(DESeq2::lfcShrink)
}

# get DESeq2 results
if (shrink && shrink_type %in% c("apeglm", "ashr")) {
  # results are obtained using coefs (defined comparisons) in case of shrinking
  # with methods "apeglm" or "ashr"
  deseq_result <- lapply(
    setdiff(resultsNames(deseq_data), "Intercept"),
    function(coef) {
      quiet_shrink(
        deseq_data,
        coef = coef,
        type = shrink_type,
        parallel = TRUE, BPPARAM = MulticoreParam(n_cores)
      )$result %>%
        as_tibble() %>%
        mutate(coef = coef, locus_tag = df_counts[[1]])
    }
  ) %>%
    bind_rows() %>%
    mutate(stat = NA) %>%
    tidyr::separate(coef, into = c("factor", "reference"), sep = "\\_vs\\_") %>%
    tidyr::separate(factor, into = c("factor", "condition"), sep = "\\_", extra = "merge")
} else if (shrink && shrink_type == "normal") {
  # results are obtained using contrasts in case of no shrinking
  # or shrinking with method "normal"
  deseq_result <- df_comparison %>%
    group_by(factor, condition, reference) %>%
    group_split() %>%
    lapply(function(comp) {
      quiet_shrink(deseq_data,
        contrast = c(comp$factor, comp$condition, comp$reference),
        type = shrink_type,
        parallel = TRUE, BPPARAM = MulticoreParam(n_cores)
      )$result %>%
        as_tibble() %>%
        mutate(
          factor = comp$factor,
          condition = comp$condition,
          reference = comp$reference,
          locus_tag = df_counts[[1]]
        )
    }) %>%
    bind_rows()
} else {
  messages <- append(messages, paste0(
    "not applying shrinkage, using default DESeq2::results() with contrasts"
  ))
  deseq_result <- df_comparison %>%
    group_by(factor, condition, reference) %>%
    group_split() %>%
    lapply(function(comp) {
      DESeq2::results(deseq_data,
        contrast = c(comp$factor, comp$condition, comp$reference),
        parallel = TRUE, BPPARAM = MulticoreParam(n_cores)
      ) %>%
        as_tibble() %>%
        mutate(
          factor = comp$factor,
          condition = comp$condition,
          reference = comp$reference,
          locus_tag = df_counts[[1]]
        )
    }) %>%
    bind_rows()
}


# slightly reformat df
deseq_result <- deseq_result %>%
  left_join(df_annotation, by = join_by("locus_tag")) %>%
  dplyr::select(all_of(c("factor", "reference", "condition", annot_cols)), everything()) %>%
  mutate(
    padj = replace(padj, is.na(padj), 1),
    significance = ifelse(
      padj <= threshold_pval & abs(log2FoldChange) >= threshold_log2fc,
      "significant",
      "not significant"
    )
  )

# export relevant results
save(deseq_data, file = deseq_data_file)
write_csv(deseq_result, file = deseq_results_file)

write_lines(
  file = snakemake@log[["path"]],
  x = paste0("DESEQ_RESULTS: ", messages)
)
