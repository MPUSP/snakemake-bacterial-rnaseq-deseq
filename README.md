# RNA-Seq Differential Expression Analysis Pipeline

This repository contains a **Snakemake** workflow for performing **RNA-Seq differential gene expression analysis** using [**DESeq2**](https://doi.org/10.1186/s13059-014-0550-8). The workflow obtains processed data from the [**RNA-Seq processing**](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow and then performs DESeq2 analysis, generating various plots and results for downstream analysis.

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

4. Export your GitHub token to import the processing pipeline module (for non-public workflows):

   ```bash
   export GITHUB_TOKEN=<your_personal_access_token>
   ```

## Input Files

The pipeline requires the following input files when running it **together with the processing module**:

- **`samplesheet.tsv`** – metadata for the RNA-Seq samples (e.g., condition, replicate)
- **`fasta`** and **`gff`** genome annotation files (can be retrieved from NCBI)
- **`fastq.gz`** read files as explained in more detail on the [processing workflow README](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing#running-the-workflow)

The pipeline contains simulated paired-end `fastq.gz` read files for running automatic tests. These files were generated using `dwgsim` and extended with UMIs and adapters on the 3' end of read 2. The reads map to the recently updated _S. pyogenes_ SF370 reference genome ([`GCF_043231225.1`](https://doi.org/10.1128/mra.01197-24)). The script to simulate reads can be found in `.test/data/simulate_reads.sh`.

Using the workflow as a **standalone module**, it requires instead:

- **`<sample_name>.counts`** – coverage data for each sample obtained as output from the [RNA-Seq processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow
- **`biotypes.gff`** – gene feature annotations for filtering protein-coding genes, obtained as output from the [RNA-Seq processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow

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

- `counts_merged.csv` – Merged counts from all samples.
- `counts_protein_coding.csv` – Filtered counts for protein-coding genes.
- `deseq2_results.csv` – DESeq2 results for all comparisons.
- `deseq2_report.html` – Comprehensive HTML report with visualizations and summaries.
- `counts_report.html` – Comprehensive HTML report for counts data.
- Various plots (PCA, heatmaps, MA plots, volcano plots) in PNG and SVG format.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## References

> Love, M.I., Huber, W. & Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol 15, 550 (2014). https://doi.org/10.1186/s13059-014-0550-8

> Wulff TF, Ahmed-Begrich R, Hahnke K, Jahn M, Charpentier E.2025.Novel assembly of the SF370 strain of the important human pathogen Streptococcus pyogenes serotype M1. Microbiol Resour Announc 14:e01197-24.https://doi.org/10.1128/mra.01197-24
