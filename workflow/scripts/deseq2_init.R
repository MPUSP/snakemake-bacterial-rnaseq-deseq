suppressPackageStartupMessages({
  library(dplyr)
  library(stringr)
  library(readr)
  library(tibble)
  library(rtracklayer)
})


counts_files <- snakemake@input[["counts_dir"]]
gff_file <- snakemake@input[["gff"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
output_file <- snakemake@output[["filtered_counts"]]
merged_output_file <- snakemake@output[["merged_counts"]]

messages <- c()
df_sample <- read_table(samplesheet_file, show_col_types = FALSE)
sample_order <- df_sample$sample


read_counts <- function(file) {
  df <- read_tsv(file, comment = "#", show_col_types = FALSE)
  df <- df[, c("Geneid", colnames(df)[ncol(df)])]
  colname <- str_replace(basename(file), "\\.counts$", "")
  colnames(df)[2] <- colname
  return(df)
}

df_merged_counts <- Reduce(
  function(x, y) merge(x, y, by = "Geneid", all = TRUE),
  lapply(counts_files, read_counts)
) %>%
  as_tibble()

if (!all(colnames(df_merged_counts)[-1] == sample_order)) {
  messages <- append(
    messages,
    "Sample names of counts matrix do not match sample sheet order, reordering."
  )
  df_merged_counts <- df_merged_counts[, c("Geneid", sample_order)]
}

write_csv(df_merged_counts, file = merged_output_file)

gff_data <- rtracklayer::import.gff(gff_file)
df_gff <- as_tibble(gff_data)
df_protein_coding <- filter(df_gff, gene_biotype == "protein_coding")

df_filtered_counts <- df_merged_counts %>%
  filter(Geneid %in% df_protein_coding$locus_tag)

write_csv(df_filtered_counts, file = output_file)

messages <- append(messages, paste0(
  "Number of common genes between merged counts and protein-coding genes: ",
  nrow(df_filtered_counts)
))
messages <- append(
  messages,
  "Merged counts and filtered counts have been saved to CSV"
)

write_lines(
  file = snakemake@log[["path"]],
  x = paste0("DESEQ_INIT: ", messages)
)
