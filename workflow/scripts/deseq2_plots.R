# Load required libraries
suppressPackageStartupMessages({
  library(readr)
  library(tibble)
  library(dplyr)
  library(ggplot2)
  library(ggrepel)
  library(DESeq2)
  library(BiocParallel)
})

# parameters
counts_file <- snakemake@input[["filtered_counts"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
deseq_results_file <- snakemake@output[["deseq_results"]]
output_dir <- snakemake@output[["plots_dir"]]
n_cores <- snakemake@threads
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
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
  messages <- append(
    messages,
    "Sample names of sample sheet and counts matrix do not correspond, reordering."
  )
  df_counts <- df_counts[c("Geneid", df_sample$sample)]
}

# decide about study design
n_conditions <- length(levels(metadata$condition))
if (n_conditions == 1) {
  design <- formula(~1)
  messages <- append(messages, "found only one condition: using design '~ 1' (deviation from null)")
} else {
  design <- formula(~condition)
  messages <- append(messages, paste0(
    "found ", n_conditions,
    " conditions: using design '~ condition' (all vs all)"
  ))
}

# DESeq data set
deseq_data <- DESeqDataSetFromMatrix(
  countData = df_counts[-1],
  colData = metadata,
  design = design
)

# call DESeq2's "results()" function with pairs of
# contrasts `contrast("variable", "level1", "level2")`
# it is assumed that the first condition is the reference
deseq_data <- DESeq(deseq_data)
if (n_conditions == 1) {
  deseq_result <- DESeq2::results(deseq_data) %>%
    as_tibble() %>%
    mutate(
      reference = "null",
      condition = levels(metadata$condition)
    )
} else {
  deseq_result <- df_sample %>%
    mutate(reference = condition[1]) %>%
    select(condition, reference) %>%
    filter(condition != reference) %>%
    distinct() %>%
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
          condition = comp$condition
        )
    }) %>%
    bind_rows()
}

# slightly reformat df and export
deseq_result <- deseq_result %>%
  relocate(reference, condition) %>%
  mutate(padj = replace(padj, is.na(padj), 1))
write_csv(deseq_result, file = deseq_results_file)


# PLOTS
#
# PCA Plot
# --------------------
rlog_data <- rlog(deseq_data)
pca_data <- plotPCA(vst(deseq_data, nsub = 100), intgroup = "condition", returnData = TRUE)

pca_plot <- ggplot(
  data = pca_data,
  aes(x = PC1, y = PC2, color = condition, label = name)
) +
  geom_point(size = 3) +
  geom_text_repel() +
  theme_bw() +
  labs(title = "PCA Plot") +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    aspect.ratio = 1
  )

ggsave(
  filename = file.path(output_dir, "pca_plot.png"),
  plot = pca_plot,
  width = 8, height = 6
)

# Volcano Plot
# --------------------
volcano_plot <- ggplot(
  data = deseq_result,
  aes(x = log2FoldChange, y = -log10(padj))
) +
  geom_point(aes(color = padj <= 0.05 & log2FoldChange >= 2), alpha = 0.6) +
  theme_bw() +
  labs(title = "Volcano Plot") +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    aspect.ratio = 1
  ) +
  facet_wrap(~ paste0(condition, " ~ ", reference))

ggsave(
  filename = file.path(output_dir, "volcano_plot.png"),
  plot = volcano_plot,
  width = 8, height = 6
)

# MA Plot
# --------------------
ma_plot <- ggplot(
  data = deseq_result,
  aes(x = baseMean, y = log2FoldChange)
) +
  geom_point(aes(color = padj < 0.05), alpha = 0.6) +
  theme_bw() +
  labs(title = "MA Plot") +
  xlab("Mean Expression") +
  ylab("Log2 Fold Change") +
  scale_x_continuous(trans = "log10") +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    aspect.ratio = 1
  ) +
  facet_wrap(~ paste0(condition, " ~ ", reference))

ggsave(
  filename = file.path(output_dir, "ma_plot.png"),
  plot = ma_plot,
  width = 8, height = 6
)

write_lines(
  file = snakemake@log[["path"]],
  x = paste0("DESEQ_RESULTS: ", messages)
)
