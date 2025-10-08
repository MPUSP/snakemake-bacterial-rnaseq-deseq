rule deseq2_init:
    input:
        counts_dir=expand(
            "results/qc/biotypes/{sample}.counts",
            sample=samples.index,
        ),
        gff="results/extracted_features/biotypes.gff",
        samplesheet=config["samplesheet"],
    output:
        counts_merged="results/deseq2/counts_merged.csv",
        counts_protein_coding="results/deseq2/counts_protein_coding.csv",
    log:
        path="results/deseq2/deseq2_init.log",
    conda:
        "../envs/deseq2.yml"
    script:
        "../scripts/deseq2_init.R"


rule deseq2_run:
    input:
        samplesheet=config["samplesheet"],
        counts_protein_coding=rules.deseq2_init.output.counts_protein_coding,
    output:
        deseq_results="results/deseq2/deseq2_results.csv",
        deseq_data="results/deseq2/deseq2_data.Rdata",
    log:
        path="results/deseq2/deseq2_run.log",
    conda:
        "../envs/deseq2.yml"
    threads: int(workflow.cores * 0.25)
    script:
        "../scripts/deseq2_run.R"


rule counts_report:
    input:
        counts_merged=rules.deseq2_init.output.counts_merged,
        counts_protein_coding=rules.deseq2_init.output.counts_protein_coding,
        samplesheet=config["samplesheet"],
    output:
        html="results/deseq2/counts_report.html",
    log:
        path="results/deseq2/counts_report.log",
    conda:
        "../envs/deseq2.yml"
    threads: int(workflow.cores * 0.25)
    script:
        "../notebooks/counts_report.Rmd"


rule deseq2_report:
    input:
        deseq_data="results/deseq2/deseq2_data.Rdata",
        deseq_results="results/deseq2/deseq2_results.csv",
        samplesheet=config["samplesheet"],
    output:
        html="results/deseq2/deseq2_report.html",
    log:
        path="results/deseq2/deseq2_report.log",
    conda:
        "../envs/deseq2.yml"
    threads: int(workflow.cores * 0.25)
    script:
        "../notebooks/deseq2_report.Rmd"
