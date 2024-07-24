if not config["FASTQ"]["activate"]:

    rule download_sra:
        output:
            sra=temp(touch(opj(results_dir, "SRA", "{run}", "{run}.sra"))),
            dir=directory((opj(results_dir, "SRA", "{run}"))),
        log:
            opj(logs_dir, "downloading", "{run}.downloading.log"),
        conda:
            "../envs/get_tools.yaml"
        params:
            threads=config["KINGFISHER"]["threads"],
        shell:
            """
            kingfisher get \
                    -r {wildcards.run} \
                    --output-directory {output.dir} \
                    -m aws-http aws-cp prefetch \
                    -f sra \
                    --download-threads {params.threads} \
                    --hide-download-progress --check-md5sums &>{log}
            """

    rule dump_fastq:
        input:
            rules.download_sra.output.sra,
        output:
            r1=temp(touch(opj(results_dir, "FASTQse", "{run}", "{run}_1.fastq.gz"))),
            r2=temp(touch(opj(results_dir, "FASTQse", "{run}", "{run}_2.fastq.gz"))),
            single=touch(opj(results_dir, "FASTQse", "{run}", "{run}.fastq.gz")),
            dir=directory(opj(results_dir, "FASTQse", "{run}")),
        params:
            library_type=lambda wildcards: (
                "--split-files" if get_library_type(wildcards.run) == "PAIRED" else ""
            ),
            threads=config["PARALLEL-FASTQ-DUMP"]["threads"],
        log:
            opj(logs_dir, "downloading", "{run}.dumping.log"),
        conda:
            "../envs/get_tools.yaml"
        shell:
            """
            parallel-fastq-dump \
                    --sra-id {input} \
                    --threads {params.threads} \
                    --outdir {output.dir} \
                    {params.library_type} \
                    --skip-technical \
                    --gzip &>{log}
            """

    rule repair_pe:
        input:
            reads=lambda wildcards: (
                [
                    rules.dump_fastq.output.r1,
                    rules.dump_fastq.output.r2,
                ]
                if get_library_type(wildcards.run) == "PAIRED"
                else []
            ),
        output:
            out=expand(
                opj(results_dir, "FASTQpe", "{{run}}", "{{run}}_{read}.fastq.gz"),
                read=[1, 2],
            ),
        log:
            opj(logs_dir, "repair", "{run}.log"),
        params:
            command="repair.sh",
        resources:
            mem_mb=config["BBMAP"]["memory"],
        wrapper:
            "v3.8.0/bio/bbtools"

    rule remove_junk:
        input:
            rules.dump_fastq.output.dir,
        log:
            opj(logs_dir, "downloading", "{run}.remove_junk.log"),
        conda:
            "../envs/get_tools.yaml"
        shell:
            """
            (find {input} -type f -size 0 -delete -print && echo Junk is removed!) &>{log}
            """
