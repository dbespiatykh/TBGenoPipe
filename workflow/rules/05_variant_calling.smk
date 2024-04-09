rule download_mask:
    output:
        "resources/mask/compass-mask.bed",
    params:
        url=config["LINKS"]["mask"],
    log:
        "logs/downloading/get_mask.log",
    shell:
        "curl -L {params.url} -o {output} &> {log}"


rule bedtools_complement_bed:
    input:
        in_file=rules.download_mask.output,
        genome=rules.samtools_genome_index.output,
    output:
        "resources/mask/complement-mask.bed",
    log:
        "logs/bedtools/complement_bed.log",
    wrapper:
        "v3.0.3/bio/bedtools/complement"


rule bcftools_mpileup:
    input:
        alignments=rules.bwa_mem2_mapping.output.bam,
        ref=rules.download_reference.output.fasta,
        index=rules.samtools_genome_index.output,
    output:
        pileup=protected("results/BCF/{run}.pileup.bcf"),
    params:
        uncompressed_bcf=True,
        extra="--min-MQ 30 --ignore-overlaps --max-depth 3000",
    log:
        "logs/bcftools/mpileup/{run}.log",
    threads: config["BCFTOOLS"]["mpileup"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/mpileup"


rule bcftools_call:
    input:
        pileup=rules.bcftools_mpileup.output.pileup,
    output:
        calls=temp("results/BCF/{run}.calls.bcf"),
    params:
        uncompressed_bcf=True,
        caller="--consensus-caller",
        extra="--ploidy 1 --variants-only",
    log:
        "logs/bcftools/call/{run}.log",
    threads: config["BCFTOOLS"]["call"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/call"


rule bcftools_view:
    input:
        rules.bcftools_call.output.calls,
        targets=rules.bedtools_complement_bed.output,
    output:
        protected("results/VCF/{run}.vcf.gz"),
    log:
        "logs/bcftools/view/{run}.log",
    params:
        extra="--include 'QUAL>20 && DP>10' --types snps",
    threads: config["BCFTOOLS"]["view"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/view"


rule bcftools_index:
    input:
        rules.bcftools_view.output,
    output:
        protected("results/VCF/{run}.vcf.gz.tbi"),
    log:
        "logs/bcftools/index/{run}.log",
    threads: config["BCFTOOLS"]["index"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/index"
