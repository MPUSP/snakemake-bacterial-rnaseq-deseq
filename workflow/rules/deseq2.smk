rule deseq2_init:
    input:
        counts_dir=expand(
            "results/quantify_biotypes/{sample}.counts",
            sample=samples.index,
        ),
        gff="results/extracted_features/biotypes.gff",
        samplesheet=config["samplesheet"],
    output:
        filtered_counts="results/deseq2/filtered_counts.csv",
        merged_counts="results/deseq2/merged_counts.csv",
    log:
        path="results/deseq2/deseq2_init.log",
    conda:
        "../envs/deseq2.yml"
    script:
        "../scripts/deseq2_init.R"


rule deseq2_run:
    input:
        samplesheet=config["samplesheet"],
        filtered_counts="results/deseq2/filtered_counts.csv",
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
        filtered_counts=rules.deseq2_init.output.filtered_counts,
        merged_counts=rules.deseq2_init.output.merged_counts,
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
