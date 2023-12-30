import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("7.18.2")


configfile: "config/config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

df = pd.read_csv(
    config["FILES"]["runs"],
    sep="\t",
    dtype=str,
)
validate(df, schema="../schemas/runs.schema.yaml")


def get_library_type(run):
    return df[df["Run"] == run]["LibraryLayout"].iloc[0]
