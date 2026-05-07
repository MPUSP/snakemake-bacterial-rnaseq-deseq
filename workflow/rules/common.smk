import pandas as pd
from snakemake.utils import validate

# read sample sheet
# -----------------------------------------------------
na_values = ["", "NaN", "nan", "null", "-"]
samples = (
    pd.read_csv(
        config["samplesheet"], sep="\t", dtype={"sample": str}, na_values=na_values
    )
    .set_index("sample", drop=False)
    .sort_index()
)


# validate sample sheet and config file
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")


wildcard_constraints:
    sample="|".join(samples.index),
