# RNA-Seq Differential Expression Analysis Pipeline

This repository contains a **Snakemake** workflow for performing **RNA-Seq differential gene expression analysis** using **DESeq2**.  
The workflow obtains processed data from a preprocessing pipeline and then performs **DESeq2 analysis**, generating various plots and results for downstream analysis.

## Installation

To set up the pipeline, follow these steps:

1. Clone this repository using the following command:  
    ```bash
    git clone https://github.com/your-username/snakemake-bacterial-rnaseq-deseq.git
    ```
   
2. Navigate to the cloned repository directory:  
    ```bash
    cd snakemake-bacterial-rnaseq-deseq
    ```

3. Create an environment like this:  
    ```bash
    # create new environment with dependencies & activate it
    mamba create -c conda-forge -c bioconda -n snakemake-bacterial-rnaseq-deseq snakemake pandas python=3.12
    conda activate snakemake-bacterial-rnaseq-deseq
    ```

4. Export your GitHub token to import the preprocessing pipeline module:  
    ```bash
    export GITHUB_TOKEN=your_personal_access_token
    ```

## Input Files

The pipeline requires the following input files:  

- **`samplesheet.tsv`** – Contains metadata for the RNA-Seq samples (e.g., condition, replicate).  
- **`sample.counts`** – Coverage data for each sample obtained from the preprocessing pipeline.  
- **`biotypes.gff`** – Gene feature annotations for filtering protein-coding genes.  

## Execution

To run the workflow from the command line, follow these steps:

1. Change the working directory:  
    ```bash
    cd snakemake-bacterial-rnaseq-deseq
    ```

2. Run the workflow with test files:  
    ```bash
    snakemake --cores 10 --use-conda --directory .test
    ```

3. To run the workflow with your own data, define the sample sheet and adjust options in the configuration file:  
    ```bash
    config/config.yml
    ```

4. Before running the entire workflow, perform a dry run to check for errors:  
    ```bash
    snakemake -c 1 --use-conda --dry-run
    ```

## Outputs

After successful execution, results will be available in the `results/deseq2/` directory, including:  

- `filtered_counts.csv` – Filtered counts for protein-coding genes.  
- `merged_counts.csv` – Merged counts from all samples.  
- `pca_plot.png` – PCA plot of the samples.  
- `volcano_plot.png` – Volcano plot for differential expression analysis.  
- `ma_plot.png` – MA plot for visualizing differential expression.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

