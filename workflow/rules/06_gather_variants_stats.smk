rule bcftools_stats:
    input:
        rules.bcftools_view.output,
        index=rules.bcftools_index.output,
    output:
        touch(
            config["OUTPUT"]["output_directory"]
            + "/stats/bcftools_stats/{run}.bcftools.txt"
        ),
    log:
        (
            config["OUTPUT"]["output_directory"]
            + "/stats/bcftools_stats/{run}.bcftools.txt"
        ),
    threads: config["BCFTOOLS"]["stats"]["threads"]
    wrapper:
        "v3.13.8/bio/bcftools/stats"
