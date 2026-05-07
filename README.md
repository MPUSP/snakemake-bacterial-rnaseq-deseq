# snakemake-bacterial-rnaseq-deseq

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/actions/workflows/snakemake-tests.yml/badge.svg)](https://github.com/MPUSP/snakemake-bacterial-rnaseq-deseq/workflows/snakemake-tests.yml)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with apptainer](https://img.shields.io/badge/run_with-apptainer-darkblue)](https://apptainer.org/docs/user/latest/)
[![workflow catalog](https://img.shields.io/badge/Snakemake%20workflow%20catalog-darkgreen)](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/MPUSP/snakemake-bacterial-rnaseq-deseq.html)

---

A Snakemake workflow for **RNA-Seq differential gene expression analysis** using [**DESeq2**](https://doi.org/10.1186/s13059-014-0550-8).

This workflow performs a follow-up analysis on the results from the [**snakemake-bacterial-rnaseq-processing**](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) workflow, which it imports as a [snakemake module](https://snakemake.readthedocs.io/en/latest/snakefiles/modularization.html#).
The first workflow processes and maps raw RNA-Seq reads and generates a table of read counts per gene.
The second workflow uses this table to perform the DE analysis with DESeq2.

- [snakemake-bacterial-rnaseq-deseq](#snakemake-bacterial-rnaseq-deseq)
  - [Usage](#usage)
  - [Workflow overview](#workflow-overview)
  - [Deployment options](#deployment-options)
  - [Authors](#authors)
  - [References](#references)

## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/docs/workflows/MPUSP/snakemake-bacterial-rnaseq-deseq).

Detailed information about input data and workflow configuration can also be found in the [`config/README.md`](config/README.md).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this repository or its DOI.

## Workflow overview

This workflow is a best-practice workflow for **differential gene expression analysis** from short read sequencing data, optimized for bacteria. This workflow is essentially a [**DESeq2**](https://doi.org/10.1186/s13059-014-0550-8)-add-on for the pre-processing handled by [snakemake-bacterial-rnaseq-processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing). The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Optionally run all steps from [snakemake-bacterial-rnaseq-processing](https://github.com/MPUSP/snakemake-bacterial-rnaseq-processing) as the first module
2. Import counts-per-feature data, the output from step 1
3. Run multifactorial DE analysis with arbitrary design (`DESeq2`)
4. Generate two reports: one for count data, and one for DE analysis (`R markdown`)

## Deployment options

To run the workflow from command line, change the working directory.

```bash
cd path/to/snakemake-workflow-name
```

Adjust options in the default config file `config/config.yml`.
Before running the complete workflow, you can perform a dry run using:

```bash
snakemake --dry-run
```

To run the workflow with test files using **conda**:

```bash
snakemake --cores 2 --sdm conda --directory .test
```

To run the workflow with **apptainer** / **singularity** (not yet supported):

```bash
snakemake --cores 2 --sdm conda apptainer --directory .test
```

## Authors

- Dr. Michael Jahn
  - Affiliation: [Max-Planck-Unit for the Science of Pathogens](https://www.mpusp.mpg.de/) (MPUSP), Berlin, Germany
  - ORCID profile: https://orcid.org/0000-0002-3913-153X
  - github page: https://github.com/m-jahn
- Adarsha Acharya
  - Affiliation: [Max-Planck-Unit for the Science of Pathogens](https://www.mpusp.mpg.de/) (MPUSP), Berlin, Germany
  - github page: https://github.com/adarshaach

Visit the MPUSP github page at https://github.com/MPUSP for more info on this workflow and other projects.

## References

> Love, M.I., Huber, W. & Anders, S. _Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2_. Genome Biol 15, 550 (2014). https://doi.org/10.1186/s13059-014-0550-8

> Wulff TF, Ahmed-Begrich R, Hahnke K, Jahn M, Charpentier E.2025. _Novel assembly of the SF370 strain of the important human pathogen Streptococcus pyogenes serotype M1_. Microbiol Resour Announc 14:e01197-24.https://doi.org/10.1128/mra.01197-24
