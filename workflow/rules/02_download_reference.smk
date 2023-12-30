rule download_reference:
    output:
        archive=temp(config["REFERENCE"]["archive"]),
        fasta=config["REFERENCE"]["fasta"],
    log:
        "logs/downloading/get_reference.log",
    conda:
        "../envs/get_tools.yaml"
    params:
        accession=config["REFERENCE"]["refseq-accession"],
    shell:
        """
        datasets download genome accession {params.accession} \
            --no-progressbar \
            --include genome \
            --filename {output.archive} &>{log} &&
            unzip -p {output.archive} ncbi_dataset/data/{params.accession}/{params.accession}\\*_genomic.fna >{output.fasta}
        """


rule bwa_mem2_index:
    input:
        rules.download_reference.output.fasta,
    output:
        multiext(
            "resources/ref/NC_000962.3.fa",
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    log:
        "logs/bwa/reference_index.log",
    wrapper:
        "v3.0.3/bio/bwa-mem2/index"


rule samtools_genome_index:
    input:
        rules.download_reference.output.fasta,
    output:
        "resources/ref/NC_000962.3.fa.fai",
    log:
        "logs/samtools/ref_index.log",
    wrapper:
        "v3.0.3/bio/samtools/faidx"
