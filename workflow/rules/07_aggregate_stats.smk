rule multiqc:
    input:
        [
            expand(
                "{outdir}/stats/samtools_stats/{run}.samtools.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=accessions.index,
            ),
            expand(
                "{outdir}/stats/mosdepth/{run}.mosdepth.summary.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=accessions.index,
            ),
            expand(
                "{outdir}/stats/fastqc/{run}_fastqc.zip",
                outdir=config["OUTPUT"]["output_directory"],
                run=accessions.index,
            ),
            expand(
                "{outdir}/stats/bcftools_stats/{run}.bcftools.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=accessions.index,
            ),
        ]
        if not config["FASTQ"]["activate"]
        else [
            expand(
                "{outdir}/stats/samtools_stats/{run}.samtools.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=reads.index,
            ),
            expand(
                "{outdir}/stats/mosdepth/{run}.mosdepth.summary.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=reads.index,
            ),
            expand(
                "{outdir}/stats/fastqc/{run}_fastqc.zip",
                outdir=config["OUTPUT"]["output_directory"],
                run=reads.index,
            ),
            expand(
                "{outdir}/stats/bcftools_stats/{run}.bcftools.txt",
                outdir=config["OUTPUT"]["output_directory"],
                run=reads.index,
            ),
        ],
    output:
        (config["OUTPUT"]["output_directory"] + "/stats/multiqc/multiqc.html"),
        directory(config["OUTPUT"]["output_directory"] + "/stats/multiqc/multiqc_data"),
    params:
        extra="--data-dir",
        use_input_files_only=False,
    log:
        (config["OUTPUT"]["output_directory"] + "/multiqc/mapping.log"),
    wrapper:
        "v3.8.0/bio/multiqc"
