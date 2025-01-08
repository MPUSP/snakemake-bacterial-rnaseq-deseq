# Load required libraries
suppressPackageStartupMessages({library(DESeq2)
library(ggplot2)
library(ggrepel)
library(readr)})


counts_file <- snakemake@input[["filtered_counts"]]
samplesheet_file <- snakemake@input[["samplesheet"]]
deseq_results_file <- snakemake@output[["deseq_results"]]
output_dir <- snakemake@output[["plots_dir"]]
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
messages <- c()

counts_data <- read.csv(counts_file, row.names = 1)
df_sample <- read.table(samplesheet_file, header = TRUE)

metadata <- data.frame(
  condition = factor(df_sample$condition, unique(df_sample$condition)),
  row.names = colnames(counts_data)
)

dds <- DESeqDataSetFromMatrix(countData = counts_data,
                              colData = metadata,
                              design = ~ condition)


dds <- DESeq(dds)

res <- results(dds)

write.csv(as.data.frame(res), file = deseq_results_file)


# PCA Plot
rlog_data <- rlog(dds)  
pca_data <- plotPCA(vst(dds), intgroup = "condition", returnData = TRUE)

pca_data$label <- paste("Sample", seq_along(pca_data$PC1))


pca_plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = condition, label = label)) +
    geom_point(size = 3) +
    geom_text_repel() +  
    theme_bw(base_size = 15) +  
    ggtitle("PCA Plot") +
    theme(legend.position = "bottom")

ggsave(filename = file.path(output_dir, "pca_plot.png"), plot = pca_plot)

# Volcano Plot 
volcano_plot <- ggplot(as.data.frame(res), aes(x = log2FoldChange, y = -log10(padj))) +
                geom_point(aes(color = padj <= 0.05 & log2FoldChange >= 2), alpha = 0.6) +
                theme_bw() +
                ggtitle("Volcano Plot") +
                xlim(-10, 10) +  
                ylim(0, 20) +  
                theme(legend.title = element_blank(),
                      legend.position = "top") 

ggsave(filename = file.path(output_dir, "volcano_plot.png"), plot = volcano_plot, width = 8, height = 6)

# MA Plot 
ma_data <- as.data.frame(res)
ma_plot <- ggplot(ma_data, aes(x = baseMean, y = log2FoldChange)) +
           geom_point(aes(color = padj < 0.05), alpha = 0.6) +
           theme_bw() +
           ggtitle("MA Plot") +
           xlab("Mean Expression") +
           ylab("Log2 Fold Change") +
           scale_x_continuous(trans = 'log10') + 
           theme(legend.title = element_blank(),
                 legend.position = "top")  


ggsave(filename = file.path(output_dir, "ma_plot.png"), plot = ma_plot, width = 8, height = 6)


messages <- append(messages,("Plots have been generated and saved."))

write_lines(
  file = snakemake@log[["path"]],
  x = paste0("COMPUTE_FEATURES: ", messages)
)
