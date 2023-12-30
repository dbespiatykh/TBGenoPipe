rule bcftools_stats:
    input:
        rules.bcftools_view.output,
        index=rules.bcftools_index.output,
    output:
        touch("results/stats/bcftools_stats/{run}.bcftools.txt"),
    log:
        "results/stats/bcftools_stats/{run}.bcftools.txt",
    threads: config["BCFTOOLS"]["stats"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/stats"


rule multiqc_calling:
    input:
        expand("results/stats/bcftools_stats/{run}.bcftools.txt", run=df["Run"]),
    output:
        "results/stats/multiqc/calling/multiqc.html",
        directory("results/stats/multiqc/calling/multiqc_data"),
    params:
        extra="--data-dir",
        use_input_files_only=True,
    log:
        "logs/multiqc/calling.log",
    wrapper:
        "v3.0.3/bio/multiqc"
