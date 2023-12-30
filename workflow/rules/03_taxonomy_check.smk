rule kma_index:
    input:
        rules.download_reference.output.fasta,
    output:
        idx=multiext(
            "resources/kma_db/NC_000962.3",
            ".comp.b",
            ".length.b",
            ".name",
            ".seq.b",
        ),
    log:
        "logs/kma/index/index.log",
    conda:
        "../envs/kma.yaml"
    shell:
        """
        kma index -i {input} -o resources/kma_db/NC_000962.3 &>{log}
        """


rule kma_map:
    input:
        rules.remove_junk.log,
        rules.kma_index.output.idx,
        reads=lambda wildcards: [
            rules.dump_fastq.output.r1,
            rules.dump_fastq.output.r2,
        ]
        if get_library_type(wildcards.run) == "PAIRED"
        else [
            rules.dump_fastq.output.single,
        ],
    output:
        res="results/kma/{run}.tsv",
    log:
        "logs/kma/map/{run}.log",
    conda:
        "../envs/kma.yaml"
    params:
        pe_se=lambda wildcards: "-i"
        if get_library_type(wildcards.run) == "SINGLE"
        else "-ipe",
        threads=config["BWA"]["threads"],
    shell:
        """
        kma {params.pe_se} {input.reads} -o results/kma/{wildcards.run} -t_db resources/kma_db/NC_000962.3 -1t1 -nc -na -nf -t {params.threads} &>{log} && 
        mv results/kma/{wildcards.run}.res {output.res}
        """
