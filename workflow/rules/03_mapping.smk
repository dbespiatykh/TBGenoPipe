rule bwa_mem2_mapping:
    input:
        rules.remove_junk.log,
        reads=lambda wildcards: [
            rules.dump_fastq.output.r1,
            rules.dump_fastq.output.r2,
        ]
        if get_library_type(wildcards.run) == "PAIRED"
        else [
            rules.dump_fastq.output.single,
        ],
        idx=rules.bwa_mem2_index.output,
    output:
        bam=protected("results/BAM/{run}.bam"),
        index=protected("results/BAM/{run}.bam.bai"),
    log:
        "logs/bwa/mem_sambamba/{run}.log",
    params:
        extra=r"-R '@RG\tID:{run}\tSM:{run}\tPL:ILLUMINA\tLB:{run}'",
        samblaster_extra=lambda wildcards: "--ignoreUnmated"
        if get_library_type(wildcards.run) == "SINGLE"
        else "",
        sort_extra="-q",
    threads: config["BWA"]["threads"]
    wrapper:
        "v3.0.3/bio/bwa-mem2/mem-samblaster"
