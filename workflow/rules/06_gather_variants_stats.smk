rule bcftools_stats:
    input:
        rules.bcftools_view.output,
        index=rules.bcftools_index.output,
    output:
        touch("results/stats/bcftools_stats/{run}.bcftools.txt"),
    log:
        "results/stats/bcftools_stats/{run}.bcftools.txt",
    threads: config["BCFTOOLS"]["stats"]["threads"]
    wrapper:
        "v3.0.3/bio/bcftools/stats"
