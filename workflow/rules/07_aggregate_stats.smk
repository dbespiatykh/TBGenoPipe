rule multiqc:
    input:
        [
            expand(
                opj(stats_dir, "samtools_stats", "{run}.samtools.txt"),
                run=accessions.index,
            ),
            expand(
                opj(stats_dir, "mosdepth", "{run}.mosdepth.summary.txt"),
                run=accessions.index,
            ),
            expand(
                opj(stats_dir, "fastqc", "{run}_fastqc.zip"),
                run=accessions.index,
            ),
            expand(
                opj(stats_dir, "bcftools_stats", "{run}.bcftools.txt"),
                run=accessions.index,
            ),
        ]
        if not config["FASTQ"]["activate"]
        else [
            expand(
                opj(stats_dir, "samtools_stats", "{run}.samtools.txt"),
                run=reads.index,
            ),
            expand(
                opj(stats_dir, "mosdepth", "{run}.mosdepth.summary.txt"),
                run=reads.index,
            ),
            expand(
                opj(stats_dir, "fastqc", "{run}_fastqc.zip"),
                run=reads.index,
            ),
            expand(
                opj(stats_dir, "bcftools_stats", "{run}.bcftools.txt"),
                run=reads.index,
            ),
        ],
    output:
        opj(stats_dir, "multiqc", "multiqc.html"),
        directory(opj(stats_dir, "multiqc", "multiqc_data")),
    params:
        extra="--data-dir",
        use_input_files_only=False,
    log:
        opj(logs_dir, "multiqc", "mapping.log"),
    wrapper:
        "v3.13.8/bio/multiqc"
