rule samtools_stats:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
    output:
        (
            config["OUTPUT"]["output_directory"]
            + "/stats/samtools_stats/{run}.samtools.txt"
        ),
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/samtools/stats/{run}.log"),
    wrapper:
        "v3.13.8/bio/samtools/stats"


rule mosdepth:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
        bai=rules.bwa_mem2_mapping.output.index,
    output:
        (
            config["OUTPUT"]["output_directory"]
            + "/stats/mosdepth/{run}.mosdepth.global.dist.txt"
        ),
        summary=(
            config["OUTPUT"]["output_directory"]
            + "/stats/mosdepth/{run}.mosdepth.summary.txt"
        ),
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/mosdepth/{run}.log"),
    params:
        extra="--no-per-base --fast-mode --use-median",
    threads: config["MOSDEPTH"]["threads"]
    wrapper:
        "v3.13.8/bio/mosdepth"


rule fastqc:
    input:
        rules.bwa_mem2_mapping.output.bam,
    output:
        html=(config["OUTPUT"]["output_directory"] + "/stats/fastqc/{run}.html"),
        zip=(config["OUTPUT"]["output_directory"] + "/stats/fastqc/{run}_fastqc.zip"),
    params:
        extra="--quiet",
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/fastqc/{run}.log"),
    threads: config["FASTQC"]["threads"]
    resources:
        mem_mb=config["FASTQC"]["memory"],
    wrapper:
        "v3.13.8/bio/fastqc"
