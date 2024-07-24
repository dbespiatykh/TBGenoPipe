rule download_reference:
    output:
        archive=temp(opj(resources_dir, "ref", config["REFERENCE"]["archive"])),
        fasta=opj(resources_dir, "ref", config["REFERENCE"]["fasta"]),
    log:
        opj(logs_dir, "downloading", "get_reference.log"),
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
            opj(resources_dir, "ref", "NC_000962.3.fa"),
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    log:
        opj(logs_dir, "bwa", "reference_index.log"),
    wrapper:
        "v3.13.8/bio/bwa-mem2/index"


rule samtools_genome_index:
    input:
        rules.download_reference.output.fasta,
    output:
        opj(resources_dir, "ref", "NC_000962.3.fa.fai"),
    log:
        opj(logs_dir, "samtools", "ref_index.log"),
    wrapper:
        "v3.13.8/bio/samtools/faidx"
