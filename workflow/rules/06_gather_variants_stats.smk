rule bcftools_stats:
    input:
        rules.bcftools_view.output,
        index=rules.bcftools_index.output,
    output:
        touch(opj(stats_dir, "bcftools_stats", "{run}.bcftools.txt")),
    log:
        opj(logs_dir, "stats", "bcftools_stats", "{run}.bcftools.txt"),
    threads: config["BCFTOOLS"]["stats"]["threads"]
    wrapper:
        "v3.13.8/bio/bcftools/stats"
