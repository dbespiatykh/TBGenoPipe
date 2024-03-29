rule samtools_stats:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
    output:
        "results/stats/samtools_stats/{run}.samtools.txt",
    log:
        "logs/samtools/stats/{run}.log",
    wrapper:
        "v3.0.3/bio/samtools/stats"


rule mosdepth:
    input:
        bam=rules.bwa_mem2_mapping.output.bam,
        bai=rules.bwa_mem2_mapping.output.index,
    output:
        "results/stats/mosdepth/{run}.mosdepth.global.dist.txt",
        summary="results/stats/mosdepth/{run}.mosdepth.summary.txt",
    log:
        "logs/mosdepth/{run}.log",
    params:
        extra="--no-per-base --fast-mode --use-median",
    threads: config["MOSDEPTH"]["threads"]
    wrapper:
        "v3.0.3/bio/mosdepth"


rule fastqc:
    input:
        rules.bwa_mem2_mapping.output.bam,
    output:
        html="results/stats/fastqc/{run}.html",
        zip="results/stats/fastqc/{run}_fastqc.zip",
    params:
        extra="--quiet",
    log:
        "logs/fastqc/{run}.log",
    threads: config["FASTQC"]["threads"]
    resources:
        mem_mb=config["FASTQC"]["memory"],
    wrapper:
        "v3.0.3/bio/fastqc"
