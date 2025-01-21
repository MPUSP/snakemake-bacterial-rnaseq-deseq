rule deseq2_init:
    input:
        counts_dir=expand(
            "results/quantify_biotypes/{sample}.counts",
            sample=samples.index,
        ),
        gff="results/extracted_features/biotypes.gff",
    output:
        filtered_counts="results/deseq2/filtered_counts.csv",
        merged_counts="results/deseq2/merged_counts.csv",
    log:
        path="results/deseq2/deseq2_init.log",
    conda:
        "../envs/deseq2.yml"
    script:
        "../scripts/deseq2_init.R"


rule deseq2_plots:
    input:
        samplesheet=config["samplesheet"],
        filtered_counts="results/deseq2/filtered_counts.csv",
    output:
        plots_dir=directory("results/deseq2/plots/"),
        deseq_results="results/deseq2/deseq2_results.csv",
    log:
        path="results/deseq2/deseq2_plots.log",
    conda:
        "../envs/deseq2.yml"
    threads: workflow.cores
    script:
        "../scripts/deseq2_plots.R"
