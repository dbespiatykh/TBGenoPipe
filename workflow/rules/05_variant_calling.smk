rule download_mask:
    output:
        "resources/mask/compass-mask.bed",
    params:
        url=config["LINKS"]["mask"],
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/downloading/get_mask.log"),
    shell:
        "curl -L {params.url} -o {output} &> {log}"


rule bedtools_complement_bed:
    input:
        in_file=rules.download_mask.output,
        genome=rules.samtools_genome_index.output,
    output:
        "resources/mask/complement-mask.bed",
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/bedtools/complement_bed.log"),
    wrapper:
        "v3.8.0/bio/bedtools/complement"


rule bcftools_mpileup:
    input:
        alignments=rules.bwa_mem2_mapping.output.bam,
        ref=rules.download_reference.output.fasta,
        index=rules.samtools_genome_index.output,
    output:
        pileup=protected(config["OUTPUT"]["output_directory"] + "/BCF/{run}.pileup.bcf"),
    params:
        uncompressed_bcf=True,
        extra="--min-MQ 30 --ignore-overlaps --max-depth 3000",
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/bcftools/mpileup/{run}.log"),
    threads: config["BCFTOOLS"]["mpileup"]["threads"]
    wrapper:
        "v3.8.0/bio/bcftools/mpileup"


rule bcftools_call:
    input:
        pileup=rules.bcftools_mpileup.output.pileup,
    output:
        calls=temp(config["OUTPUT"]["output_directory"] + "/BCF/{run}.calls.bcf"),
    params:
        uncompressed_bcf=True,
        caller="--multiallelic-caller",
        extra="--ploidy 1 --variants-only",
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/bcftools/call/{run}.log"),
    threads: config["BCFTOOLS"]["call"]["threads"]
    wrapper:
        "v3.8.0/bio/bcftools/call"


rule bcftools_view:
    input:
        rules.bcftools_call.output.calls,
        targets=rules.bedtools_complement_bed.output,
    output:
        protected(config["OUTPUT"]["output_directory"] + "/VCF/{run}.vcf.gz"),
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/bcftools/view/{run}.log"),
    params:
        extra="--include 'QUAL>20 && DP>10' --types snps",
    threads: config["BCFTOOLS"]["view"]["threads"]
    wrapper:
        "v3.8.0/bio/bcftools/view"


rule bcftools_index:
    input:
        rules.bcftools_view.output,
    output:
        protected(config["OUTPUT"]["output_directory"] + "/VCF/{run}.vcf.gz.tbi"),
    log:
        (config["OUTPUT"]["output_directory"] + "/logs/bcftools/index/{run}.log"),
    threads: config["BCFTOOLS"]["index"]["threads"]
    wrapper:
        "v3.8.0/bio/bcftools/index"
