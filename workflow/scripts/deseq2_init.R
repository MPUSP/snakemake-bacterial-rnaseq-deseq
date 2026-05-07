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
output_merged <- snakemake@output[["counts_merged"]]
output_filtered <- snakemake@output[["counts_filtered"]]
biotypes <- snakemake@config[["deseq2"]][["biotypes"]]

messages <- c()
df_sample <- read_tsv(samplesheet_file, show_col_types = FALSE)
sample_order <- df_sample$sample

df_merged_counts <- lapply(counts_files, function(file) {
  df <- read_tsv(file, comment = "#", show_col_types = FALSE)
  df <- df[, c("Geneid", colnames(df)[ncol(df)])]
  colnames(df)[2] <- str_replace(basename(file), "\\.counts$", "")
  return(df)
})

# join all tables together by locus_tag
df_merged_counts <- Reduce(function(x, y) full_join(x, y, by = "Geneid"), df_merged_counts) %>%
  as_tibble() %>%
  dplyr::rename(locus_tag = `Geneid`)

# check that colname order is correct
if (!all(colnames(df_merged_counts)[-1] == sample_order)) {
  messages <- append(
    messages,
    "Sample names of counts matrix do not match sample sheet order, reordering."
  )
  df_merged_counts <- df_merged_counts[, c("locus_tag", sample_order)]
}

# merge data with annotation from gff file
df_gff <- as_tibble(rtracklayer::import.gff(gff_file)) %>%
  dplyr::select(any_of(c("locus_tag", "old_locus_tag", "trivial_name", "gene_biotype")))
if ("gene_biotype" %in% colnames(df_gff)) {
  df_gff <- filter(df_gff, !is.na(gene_biotype))
}
df_merged_counts <- left_join(df_merged_counts, df_gff, by = join_by("locus_tag")) %>%
  dplyr::select(any_of(c("locus_tag", "old_locus_tag", "trivial_name", "gene_biotype")), everything())
if ("gene_biotype" %in% colnames(df_gff) && !is.null(biotypes)) {
  df_filtered <- filter(df_merged_counts, gene_biotype %in% biotypes)
  messages <- append(messages, c(
    "Filtering by gene biotypes: ", paste(biotypes, collapse = ", "),
    "Number of all entries: ", nrow(df_merged_counts),
    "Number of kept entries after filtering: ", nrow(df_filtered)
  ))
} else {
  df_filtered <- df_merged_counts
  messages <- append(messages, paste0(
    "Biotype filtering skipped, as option 'deseq2/biotypes' is not set ",
    "or gene_biotype column is missing."
  ))
}

write_csv(df_merged_counts, file = output_merged)
write_csv(df_filtered, file = output_filtered)

messages <- append(
  messages,
  "Complete results table and protein-coding were exported as CSV files."
)

write_lines(
  file = snakemake@log[["path"]],
  x = paste0("DESEQ_INIT: ", messages)
)
