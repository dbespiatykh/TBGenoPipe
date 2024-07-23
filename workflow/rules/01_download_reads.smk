if not config["FASTQ"]["activate"]:

    rule download_sra:
        output:
            sra=temp(touch(config["OUTPUT"]["output_directory"] + "/SRA/{run}.sra")),
        log:
            (
                config["OUTPUT"]["output_directory"]
                + "/logs/downloading/{run}.downloading.log"
            ),
        conda:
            "../envs/get_tools.yaml"
        params:
            threads=config["KINGFISHER"]["threads"],
            directory=(
                config["OUTPUT"]["output_directory"]
                + "/"
                + config["KINGFISHER"]["directory"]
            ),
        shell:
            """
            kingfisher get \
                    -r {wildcards.run} \
                    --output-directory {params.directory} \
                    -m aws-http aws-cp prefetch \
                    -f sra \
                    --download-threads {params.threads} \
                    --hide-download-progress --check-md5sums &>{log}
            """

    rule dump_fastq:
        input:
            rules.download_sra.output.sra,
        output:
            r1=temp(
                touch(
                    config["OUTPUT"]["output_directory"]
                    + "/FASTQse/{run}/{run}_1.fastq.gz"
                )
            ),
            r2=temp(
                touch(
                    config["OUTPUT"]["output_directory"]
                    + "/FASTQse/{run}/{run}_2.fastq.gz"
                )
            ),
            single=touch(
                config["OUTPUT"]["output_directory"] + "/FASTQse/{run}/{run}.fastq.gz"
            ),
            dir=directory(config["OUTPUT"]["output_directory"] + "/FASTQse/{run}"),
        params:
            library_type=lambda wildcards: (
                "--split-files" if get_library_type(wildcards.run) == "PAIRED" else ""
            ),
            threads=config["PARALLEL-FASTQ-DUMP"]["threads"],
        log:
            (
                config["OUTPUT"]["output_directory"]
                + "/logs/downloading/{run}.dumping.log"
            ),
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
                "{outdir}/FASTQpe/{{run}}/{{run}}_{read}.fastq.gz",
                outdir=config["OUTPUT"]["output_directory"],
                read=[1, 2],
            ),
        log:
            (config["OUTPUT"]["output_directory"] + "/logs/repair/{run}.log"),
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
            (
                config["OUTPUT"]["output_directory"]
                + "/logs/downloading/{run}.remove_junk.log"
            ),
        shell:
            """
            (find {input} -type f -size 0 -delete -print && echo Junk is removed!) &>{log}
            """
