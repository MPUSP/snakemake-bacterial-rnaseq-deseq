# RNA-Seq Differential Expression Analysis Pipeline

This repository contains a **Snakemake** workflow for performing **RNA-Seq differential gene expression analysis** using [**DESeq2**](https://doi.org/10.1186/s13059-014-0550-8). The workflow obtains processed data from the [**RNA-Seq preprocessing**](https://github.com/MPUSP/snakemake-bacterial-rnaseq-preprocessing) workflow and then performs DESeq2 analysis, generating various plots and results for downstream analysis.

## Installation

To set up the pipeline, follow these steps:

1. Clone this repository using the following command:

   ```bash
   git clone https://github.com/adarshaach/snakemake-bacterial-rnaseq-deseq
   ```

2. Navigate to the cloned repository directory:

   ```bash
   cd snakemake-bacterial-rnaseq-deseq
   ```

3. Create an environment and activate it:

   ```bash
   mamba create -c conda-forge -c bioconda -n snakemake-bacterial-rnaseq-deseq snakemake pandas python=3.12
   conda activate snakemake-bacterial-rnaseq-deseq
   ```

4. Export your GitHub token to import the preprocessing pipeline module (for non-public workflows):

   ```bash
   export GITHUB_TOKEN=<your_personal_access_token>
   ```

## Input Files

The pipeline requires the following input files when running it **together with the preprocessing module**ö :

- **`samplesheet.tsv`** – metadata for the RNA-Seq samples (e.g., condition, replicate)
- **reference genome** and **`fastq.gz`** read files as explained in more detail on the [preprocessing workflow README](https://github.com/MPUSP/snakemake-bacterial-rnaseq-preprocessing#running-the-workflow)

The pipeline contains simulated paired-end `fastq.gz` read files for running automatic tests. These files were generated using `dwgsim` and extended with UMIs and adapters on the 3' end of read 2. The reads map to the recently updated *S. pyogenes* SF370 reference genome ([`GCF_043231225.1`](https://doi.org/10.1128/mra.01197-24)). The script to simulate reads can be found in `.test/data/simulate_reads.sh`.

Using the workflow as a **standalone module**, it requires instead:

- **`<sample_name>.counts`** – coverage data for each sample obtained as output from the [RNA-Seq preprocessing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-preprocessing) workflow
- **`biotypes.gff`** – gene feature annotations for filtering protein-coding genes, obtained as output from the [RNA-Seq preprocessing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-preprocessing) workflow

## Execution

To run the workflow from the command line, follow these steps:

1. Change the working directory:

   ```bash
   cd snakemake-bacterial-rnaseq-deseq
   ```

2. Run the workflow with test files:

   ```bash
   snakemake --cores 10 --sdm conda --directory .test
   ```

3. To run the workflow with your own data, define the sample sheet and adjust options in the configuration file:

   ```bash
   config/config.yml
   ```

4. Before running the entire workflow, perform a dry run to check for errors:

   ```bash
   snakemake -c 1 --sdm conda --dry-run
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

## References

> Love, M.I., Huber, W. & Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol 15, 550 (2014). https://doi.org/10.1186/s13059-014-0550-8

> Wulff TF, Ahmed-Begrich R, Hahnke K, Jahn M, Charpentier E.2025.Novel assembly of the SF370 strain of the important human pathogen Streptococcus pyogenes serotype M1. Microbiol Resour Announc 14:e01197-24.https://doi.org/10.1128/mra.01197-24