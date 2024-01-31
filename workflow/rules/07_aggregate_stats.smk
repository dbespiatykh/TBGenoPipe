rule multiqc:
    input:
        expand("results/stats/samtools_stats/{run}.samtools.txt", run=df["Run"]),
        expand("results/stats/mosdepth/{run}.mosdepth.summary.txt", run=df["Run"]),
        expand("results/stats/fastqc/{run}_fastqc.zip", run=df["Run"]),
        expand("results/stats/bcftools_stats/{run}.bcftools.txt", run=df["Run"]),
    output:
        "results/stats/multiqc/multiqc.html",
        directory("results/stats/multiqc/multiqc_data"),
    params:
        extra="--data-dir",
        use_input_files_only=False,
    log:
        "logs/multiqc/mapping.log",
    wrapper:
        "v3.0.3/bio/multiqc"
