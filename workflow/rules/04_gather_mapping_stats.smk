rule samtools_stats:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
    output:
        opj(stats_dir, "samtools_stats", "{run}.samtools.txt"),
    log:
        opj(logs_dir, "samtools", "stats", "{run}.log"),
    wrapper:
        "v3.13.8/bio/samtools/stats"


rule mosdepth:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
        bai=rules.bwa_mem2_mapping.output.index,
    output:
        opj(stats_dir, "mosdepth", "{run}.mosdepth.global.dist.txt"),
        summary=opj(stats_dir, "mosdepth", "{run}.mosdepth.summary.txt"),
    log:
        opj(logs_dir, "mosdepth", "{run}.log"),
    params:
        extra="--no-per-base --fast-mode --use-median",
    threads: config["MOSDEPTH"]["threads"]
    wrapper:
        "v3.13.8/bio/mosdepth"


rule fastqc:
    input:
        rules.bwa_mem2_mapping.output.bam,
    output:
        html=opj(stats_dir, "fastqc", "{run}.html"),
        zip=opj(stats_dir, "fastqc", "{run}_fastqc.zip"),
    params:
        extra="--quiet",
    log:
        opj(logs_dir, "fastqc", "{run}.log"),
    threads: config["FASTQC"]["threads"]
    resources:
        mem_mb=config["FASTQC"]["memory"],
    wrapper:
        "v3.13.8/bio/fastqc"
