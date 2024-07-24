if config["FASTQ"]["activate"]:

    rule bwa_mem2_mapping:
        input:
            reads=get_fastq,
            idx=rules.bwa_mem2_index.output,
        output:
            bam=protected(opj(results_dir, "BAM", "{run}.bam")),
            index=protected(opj(results_dir, "BAM", "{run}.bam.bai")),
        log:
            opj(logs_dir, "bwa", "mem_sambamba", "{run}.log"),
        params:
            extra=r"-R '@RG\tID:{run}\tSM:{run}\tPL:ILLUMINA\tLB:{run}'",
            samblaster_extra=lambda wildcards: (
                "--ignoreUnmated"
                if get_library_type(wildcards.run) == "SINGLE"
                else ""
            ),
            sort_extra="-q",
        threads: config["BWA"]["threads"]
        wrapper:
            "v3.13.8/bio/bwa-mem2/mem-samblaster"

else:

    rule bwa_mem2_mapping:
        input:
            rules.remove_junk.log,
            reads=lambda wildcards: (
                [
                    rules.repair_pe.output.out[0],
                    rules.repair_pe.output.out[1],
                ]
                if get_library_type(wildcards.run) == "PAIRED"
                else [
                    rules.dump_fastq.output.single,
                ]
            ),
            idx=rules.bwa_mem2_index.output,
        output:
            bam=protected(opj(results_dir, "BAM", "{run}.bam")),
            index=protected(opj(results_dir, "BAM", "{run}.bam.bai")),
        log:
            opj(logs_dir, "bwa", "mem_sambamba", "{run}.log"),
        params:
            extra=r"-R '@RG\tID:{run}\tSM:{run}\tPL:ILLUMINA\tLB:{run}'",
            samblaster_extra=lambda wildcards: (
                "--ignoreUnmated"
                if get_library_type(wildcards.run) == "SINGLE"
                else ""
            ),
            sort_extra="-q",
        threads: config["BWA"]["threads"]
        wrapper:
            "v3.13.8/bio/bwa-mem2/mem-samblaster"
