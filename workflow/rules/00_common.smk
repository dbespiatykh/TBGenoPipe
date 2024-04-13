import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("7.18.2")


configfile: "config/config.yaml"


if config["FASTQ"]["activate"]:
    reads = (
        pd.read_csv(
            config["FILES"]["reads"],
            sep="\t",
            dtype=str,
        )
        .set_index(["Run"], drop=False)
        .sort_index()
    )
    validate(reads, schema="../schemas/reads.schema.yaml")

    def get_fastq(wildcards):
        run = reads.loc[wildcards.run]

        if pd.isna(run["R2"]):
            return [run["R1"]]
        else:
            return [run["R1"], run["R2"]]

    def get_library_type(run):
        if reads.loc[reads["Run"] == run]["R2"].notna().any():
            return "PAIRED"
        else:
            return "SINGLE"

else:
    accessions = (
        pd.read_csv(
            config["FILES"]["runs"],
            sep="\t",
            dtype=str,
        )
        .set_index(["Run"], drop=False)
        .sort_index()
    )
    validate(accessions, schema="../schemas/accessions.schema.yaml")

    def get_library_type(run):
        return accessions[accessions["Run"] == run]["LibraryLayout"].iloc[0]
