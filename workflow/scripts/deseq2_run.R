# Load required libraries
suppressWarnings({
  suppressPackageStartupMessages({
    library(readr)
    library(tibble)
    library(dplyr)
    library(tidyr)
    library(DESeq2)
    library(BiocParallel)
  })
})

# parameters
counts_file <- snakemake@input[["filtered_counts"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
deseq_results_file <- snakemake@output[["deseq_results"]]
deseq_data_file <- snakemake@output[["deseq_data"]]
n_cores <- snakemake@threads
threshold_pval <- snakemake@config$deseq2$threshold_pval
if (is.null(threshold_pval) || is.na(threshold_pval)) threshold_pval <- 0.05
threshold_log2fc <- snakemake@config$deseq2$threshold_log2fc
if (is.null(threshold_log2fc) || is.na(threshold_log2fc)) threshold_log2fc <- 1.0
messages <- c()

# import data
df_counts <- read_csv(counts_file, show_col_types = FALSE)
df_sample <- read_table(samplesheet_file, show_col_types = FALSE)

metadata <- data.frame(
  condition = factor(df_sample$condition, unique(df_sample$condition)),
  row.names = colnames(df_counts)[-1]
)

# check that the order of file names corresponds to colnames of counts
if (!all(colnames(df_counts[-1]) == df_sample$sample)) {
  messages <- append(messages, paste0(
    "Sample names of sample sheet and counts ",
    "matrix do not correspond, reordering."
  ))
  df_counts <- df_counts[c("Geneid", df_sample$sample)]
}

# decide about study design
n_conditions <- length(levels(metadata$condition))
if (n_conditions == 1) {
  design <- formula(~1)
  messages <- append(messages, paste0(
    "found only one condition: ",
    "using design '~ 1' (deviation from null)"
  ))
} else {
  design <- formula(~condition)
  messages <- append(messages, paste0(
    "found ", n_conditions,
    " conditions: using design '~ condition' (all vs all)"
  ))
}

# define the comparisons to be made
if (all(is.na(df_sample$comparison))) {
  df_comparison <- df_sample %>%
    mutate(reference = condition[1]) %>%
    select(condition, reference) %>%
    filter(condition != reference) %>%
    distinct()
  messages <- append(messages, paste0(
    "making ", nrow(df_comparison),
    " comparisons by constrasting the first condition against all others"
  ))
} else {
  df_comparison <- df_sample %>%
    filter(!is.na(comparison)) %>%
    dplyr::select(condition, comparison) %>%
    distinct() %>%
    tidyr::separate_longer_delim(comparison, delim = ",") %>%
    dplyr::rename(reference = comparison) %>%
    distinct() %>%
    filter(!condition == reference)
  messages <- append(messages, paste0(
    "making ", nrow(df_comparison), " comparisons as stated in the sample sheet"
  ))
}

# DESeq data set
deseq_data <- DESeqDataSetFromMatrix(
  countData = df_counts[-1],
  colData = metadata,
  design = design
) %>%
  DESeq()

# call DESeq2's "results()" function with pairs of
# contrasts `contrast("variable", "level1", "level2")`
# it is assumed that the first condition is the reference
if (n_conditions == 1) {
  deseq_result <- DESeq2::results(deseq_data) %>%
    as_tibble() %>%
    mutate(
      reference = "null",
      condition = levels(metadata$condition),
      gene = df_counts[[1]]
    )
} else {
  deseq_result <- df_comparison %>%
    mutate(comparison = seq_along(reference)) %>%
    group_by(comparison) %>%
    group_split() %>%
    lapply(function(comp) {
      DESeq2::results(deseq_data,
        contrast = c("condition", comp$condition, comp$reference),
        parallel = TRUE, BPPARAM = MulticoreParam(n_cores)
      ) %>%
        as_tibble() %>%
        mutate(
          reference = comp$reference,
          condition = comp$condition,
          gene = df_counts[[1]]
        )
    }) %>%
    bind_rows()
}

# slightly reformat df
deseq_result <- deseq_result %>%
  relocate(reference, condition) %>%
  mutate(
    padj = replace(padj, is.na(padj), 1),
    significance = ifelse(
      padj <= threshold_pval & log2FoldChange >= threshold_log2fc,
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
