import pandas as pd


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


wildcard_constraints:
    sample="|".join(samples.index),
    read="|".join(["R1", "R2"]),
