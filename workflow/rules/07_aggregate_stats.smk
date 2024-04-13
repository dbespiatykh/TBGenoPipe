rule multiqc:
    input:
        [
            expand(
                "results/stats/samtools_stats/{run}.samtools.txt",
                run=accessions.index,
            ),
            expand(
                "results/stats/mosdepth/{run}.mosdepth.summary.txt",
                run=accessions.index,
            ),
            expand("results/stats/fastqc/{run}_fastqc.zip", run=accessions.index),
            expand(
                "results/stats/bcftools_stats/{run}.bcftools.txt",
                run=accessions.index,
            ),
        ]
        if not config["FASTQ"]["activate"]
        else [
            expand("results/stats/samtools_stats/{run}.samtools.txt", run=reads.index),
            expand(
                "results/stats/mosdepth/{run}.mosdepth.summary.txt", run=reads.index
            ),
            expand("results/stats/fastqc/{run}_fastqc.zip", run=reads.index),
            expand("results/stats/bcftools_stats/{run}.bcftools.txt", run=reads.index),
        ],
    output:
        "results/stats/multiqc/multiqc.html",
        directory("results/stats/multiqc/multiqc_data"),
    params:
        extra="--data-dir",
        use_input_files_only=False,
    log:
        "logs/multiqc/mapping.log",
    wrapper:
        "v3.8.0/bio/multiqc"
