rule download_sra:
    output:
        sra=temp(touch("results/SRA/{run}.sra")),
    log:
        "logs/downloading/{run}.downloading.log",
    conda:
        "../envs/get_tools.yaml"
    params:
        threads=config["KINGFISHER"]["threads"],
        directory=config["KINGFISHER"]["directory"],
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
        r1=touch("results/FASTQ/{run}/{run}_1.fastq.gz"),
        r2=touch("results/FASTQ/{run}/{run}_2.fastq.gz"),
        single=touch("results/FASTQ/{run}/{run}.fastq.gz"),
        dir=directory("results/FASTQ/{run}"),
    params:
        library_type=lambda wildcards: "--split-files"
        if get_library_type(wildcards.run) == "PAIRED"
        else "",
        threads=config["PARALLEL-FASTQ-DUMP"]["threads"],
    log:
        "logs/downloading/{run}.dumping.log",
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


rule remove_junk:
    input:
        rules.dump_fastq.output.dir,
    log:
        "logs/downloading/{run}.remove_junk.log",
    shell:
        """
        (find {input} ! -name '.*' -type f -size 0 -delete -print && echo Junk is removed!) &>{log}
        """
