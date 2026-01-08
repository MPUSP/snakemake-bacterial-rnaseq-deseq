## Workflow overview

This workflow is a best-practice workflow for **differential gene expression analysis** from short read sequencing data, optimized for bacteria. This workflow is essentially a [**DESeq2**](https://doi.org/10.1186/s13059-014-0550-8)-add-on for the pre-processing handled by [snakemake-bacterial-rnaseq-processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing). The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Optionally run all steps from [snakemake-bacterial-rnaseq-processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) as the first module
2. Import counts-per-feature data, the output from step 1
3. Run multifactorial DE analysis with arbitrary design (`DESeq2`)
4. Generate two reports: one for count data, and one for DE analysis (`R markdown`)

## Input

The pipeline requires the following input files when running it **[together with the processing module](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing)**:

- **`samplesheet.tsv`** – metadata for the RNA-Seq samples (e.g., condition, replicate)
- **`fasta`** and **`gff`** genome annotation files (can be retrieved from NCBI)
- **`fastq.gz`** read files as explained in more detail on the [processing workflow README](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing#running-the-workflow)

The pipeline contains simulated paired-end `fastq.gz` read files for running automatic tests. These files were generated using `dwgsim` and extended with UMIs and adapters on the 3' end of read 2. The reads map to the recently updated _S. pyogenes_ SF370 reference genome ([`GCF_043231225.1`](https://doi.org/10.1128/mra.01197-24)). The script to simulate reads can be found in `.test/data/simulate_reads.sh`.

Using the workflow as a **standalone module**, it requires instead:

- **`<sample_name>.counts`** – coverage data for each sample obtained as output from the [RNA-Seq processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow
- **`biotypes.gff`** – gene feature annotations for filtering e.g. protein-coding genes, obtained as output from the [RNA-Seq processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow

## Output

After successful execution, results will be available in the `results/deseq2/` directory, including:

- `counts_merged.csv` – Merged counts from all samples.
- `counts_filtered.csv` – Filtered counts, e.g. to include only genes with biotype `protein-coding`.
- `deseq2_results.csv` – DESeq2 results for all comparisons.
- `deseq2_report.html` – Comprehensive HTML report with visualizations and summaries.
- `counts_report.html` – Comprehensive HTML report for counts data.
- Various plots (PCA, heatmaps, MA plots, volcano plots) in PNG and SVG format.
