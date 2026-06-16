suppressPackageStartupMessages({
  library(dplyr)
  library(stringr)
  library(readr)
  library(tibble)
  library(rtracklayer)
})

# import snakemake variables
counts_files <- snakemake@input[["counts_dir"]]
gff_file <- snakemake@input[["gff"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
output_merged <- snakemake@output[["counts_merged"]]
output_filtered <- snakemake@output[["counts_filtered"]]
biotypes <- snakemake@config[["deseq2"]][["biotypes"]]
annot_cols <- snakemake@config[["deseq2"]][["identifiers"]]
if (is.null(annot_cols) || length(annot_cols) < 1) {
  stop("Config entry 'deseq2/identifiers' must be a non-empty array.")
}
id_col <- annot_cols[1]
messages <- c()

# import sample sheet
df_sample <- read_tsv(samplesheet_file, show_col_types = FALSE)
sample_order <- df_sample$sample

# import counts files into list
df_merged_counts <- lapply(counts_files, function(file) {
  df <- read_tsv(file, comment = "#", show_col_types = FALSE)
  df <- df[, c("Geneid", colnames(df)[ncol(df)])]
  colnames(df)[2] <- str_replace(basename(file), "\\.counts$", "")
  return(df)
})

# join all tables together by primary ID (usually locus_tag)
df_merged_counts <- Reduce(function(x, y) full_join(x, y, by = "Geneid"), df_merged_counts) %>%
  as_tibble() %>%
  dplyr::rename_with(~id_col, `Geneid`)

# check that colname order is correct
if (!all(colnames(df_merged_counts)[-1] == sample_order)) {
  messages <- append(
    messages,
    "Sample names of counts matrix do not match sample sheet order, reordering."
  )
  df_merged_counts <- df_merged_counts[, c(id_col, sample_order)]
}

# merge data with annotation from gff file; do some tests
df_gff <- as_tibble(rtracklayer::import.gff(gff_file)) %>%
  dplyr::select(any_of(c(annot_cols, "gene_biotype")))
if (!all(annot_cols %in% colnames(df_gff))) {
  stop(paste0(
    "Not all identifiers specified in config 'deseq2/identifiers' are ",
    "present in the GFF file. Please check that gene annotation contains the ",
    "following attributes: ", paste(annot_cols, collapse = ", ")
  ))
}
if ("gene_biotype" %in% colnames(df_gff) && !is.null(biotypes)) {
  df_gff <- filter(df_gff, !is.na(gene_biotype))
  duplicated_ids <- filter(df_gff, gene_biotype %in% biotypes) %>%
    filter(duplicated(!!sym(id_col))) %>%
    pull(!!sym(id_col))
} else {
  duplicated_ids <- df_gff %>%
    filter(duplicated(!!sym(id_col))) %>%
    pull(!!sym(id_col))
}
if (length(duplicated_ids) > 0) {
  stop(paste0(
    "Primary identifier '", id_col, "' specified in config 'deseq2/identifiers' ",
    "is not unique in the GFF file. Primary identifiers must be unique.\n",
    "Duplicated entries:\n", paste(unique(duplicated_ids), collapse = ", ")
  ))
}

df_merged_counts <- left_join(df_merged_counts, df_gff, by = id_col) %>%
  dplyr::select(all_of(annot_cols), any_of("gene_biotype"), everything())
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
    "or 'gene_biotype' column is missing."
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
