#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import statsmodels.api as sm
import tqdm
from scipy.stats import levene

# import anova and tukeyhsd
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# In[2]:


def anova_function(features_df: pd.DataFrame, Metdata_column: str) -> pd.DataFrame:
    """
    This function will take in a dataframe and a metadata column and return the results of an anova and tukeyhsd test for each feature.


    Parameters
    ----------
    features_df : pd.DataFrame
        The dataframe containing the features with only one metadata column
    Metdata_column : str
        The name of the metadata column to be used for the anova test

    Returns
    -------
    pd.DataFrame
        A dataframe containing the results of the anova and tukeyhsd test for each feature
    """

    # anova and tukeyhsd for each feature
    # create a pandas data frame to store the results
    anova_results = pd.DataFrame()

    # loop through each feature
    for feature in tqdm.tqdm(features_df.columns[:-1]):
        # create a model
        model = ols(f"{feature} ~ C({Metdata_column})", data=features_df).fit()
        # create an anova table
        anova_table = sm.stats.anova_lm(model, typ=2)
        # create a tukeyhsd table
        tukeyhsd = pairwise_tukeyhsd(features_df[feature], features_df[Metdata_column])
        # get the f-statistic based p-value
        anova_p_value = anova_table["PR(>F)"][0]
        tmp = pd.DataFrame(
            tukeyhsd._results_table.data, columns=tukeyhsd._results_table.data[0]
        ).drop(0)
        tmp.reset_index(inplace=True, drop=True)
        # drop the first row
        tmp["feature"] = feature
        tmp["anova_p_value"] = anova_p_value
        tmp = pd.DataFrame(tmp)

        anova_results = pd.concat([anova_results, tmp], axis=0).reset_index(drop=True)
    return anova_results


# In[3]:


file_path = pathlib.Path("../../data/5.converted_data/mean_aggregated_data.parquet")
df = pd.read_parquet(file_path)
df.head()


# In[4]:


# split the features and the metadata
metadata = df.columns.str.contains("Metadata")
# filter the metadata
metadata_df = df.loc[:, metadata]
# filter the features
features_df = df.loc[:, ~metadata]


# ## Anova for genotype only

# In[5]:


anova_input_df = features_df.copy()
anova_input_df["Metadata_genotype"] = metadata_df["Metadata_genotype"]
anova_output_df = anova_function(anova_input_df, "Metadata_genotype")
print(anova_output_df.shape)
anova_output_df.head()


# In[6]:


# save the results
output_file = pathlib.Path(
    "../../data/6.analysis_results/mean_aggregated_anova_results.parquet"
)
output_file.parent.mkdir(exist_ok=True, parents=True)
anova_output_df.to_parquet(output_file)


# ## Levene's test for homogeneity of variance

# In[7]:


# split the df into three genotypes
high_df = df[df["Metadata_genotype"] == "high"]
unsel_df = df[df["Metadata_genotype"] == "unsel"]
wt_df = df[df["Metadata_genotype"] == "wt"]
levene_test_results = {"feature": [], "levene_statistic": [], "levene_p_value": []}
for feature in tqdm.tqdm(features_df.columns):
    # calculate the levene test for each feature
    levene_results = levene(wt_df[feature], unsel_df[feature], high_df[feature])
    levene_test_results["feature"].append(feature)
    levene_test_results["levene_statistic"].append(levene_results.statistic)
    levene_test_results["levene_p_value"].append(levene_results.pvalue)

levene_test_results_df = pd.DataFrame(levene_test_results)
levene_test_results_df


# ## Calculate the levenes test statistic for the equality of variances

# In[8]:


# split the df into three genotypes
high_df = df[df["Metadata_genotype"] == "high"]
unsel_df = df[df["Metadata_genotype"] == "unsel"]
wt_df = df[df["Metadata_genotype"] == "wt"]
group_dict = {
    "high_vs_unsel": [high_df, unsel_df],
    "high_vs_wt": [high_df, wt_df],
    "unsel_vs_wt": [wt_df, unsel_df],
    "all": [high_df, unsel_df, wt_df],
}


levene_test_results = {
    "feature": [],
    "levene_statistic": [],
    "levene_p_value": [],
    "group": [],
}
for group in tqdm.tqdm(group_dict.keys()):
    for feature in features_df.columns:
        # calculate the levene test for each feature
        if not group == "all":
            levene_results = levene(
                group_dict[group][0][feature], group_dict[group][1][feature]
            )
            levene_test_results["feature"].append(feature)
            levene_test_results["levene_statistic"].append(levene_results.statistic)
            levene_test_results["levene_p_value"].append(levene_results.pvalue)
            levene_test_results["group"].append(group)
        else:
            levene_results = levene(
                group_dict[group][0][feature],
                group_dict[group][1][feature],
                group_dict[group][2][feature],
            )
            levene_test_results["feature"].append(feature)
            levene_test_results["levene_statistic"].append(levene_results.statistic)
            levene_test_results["levene_p_value"].append(levene_results.pvalue)
            levene_test_results["group"].append(group)

levene_test_results_df = pd.DataFrame(levene_test_results)

# sort the levene test results levene_test_results_df
# change the levene p-value to a float
levene_test_results_df["levene_p_value"] = levene_test_results_df[
    "levene_p_value"
].astype(float)
levene_test_results_df = levene_test_results_df.sort_values(
    "levene_p_value", ascending=False
)
levene_test_results_df


# In[9]:


# save the levene test results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
levene_test_results_path = pathlib.Path(
    out_dir / "mean_aggregated_levene_test_results.csv"
)
levene_test_results_df.to_csv(levene_test_results_path)


# ### Calculate the levene test statistic for the aggregated data across feature types and genotypes

# In[10]:


data_path = pathlib.Path(
    "../../data/5.converted_data/mean_aggregated_data.parquet"
).resolve(strict=True)
# Read the data
data = pd.read_parquet(data_path)

# Drop all metadata except for the genotype data
features_df = data.drop(columns=data.filter(like="Metadata").columns)
features_df["Metadata_genotype"] = data["Metadata_genotype"]


# turn the features into a long format
features_long_df = features_df.melt(
    id_vars="Metadata_genotype", var_name="feature", value_name="value"
)
features_long_df.head()
# Separate the feature into different parts
features_long_df[
    ["feature_group", "measurement", "bone", "parameter1", "parameter2", "parameter3"]
] = features_long_df["feature"].str.split("_", expand=True)

# Replace the Metadata_genotype with the actual genotype name
features_long_df["Metadata_genotype"] = features_long_df["Metadata_genotype"].replace(
    {"high": "High-Severity", "unsel": "Mid-Severity", "wt": "Wild Type"}
)
features_long_df.head()


# In[11]:


# break each genotype and featuretype into a separate dataframe
high_df = features_long_df[features_long_df["Metadata_genotype"] == "High-Severity"]
unsel_df = features_long_df[features_long_df["Metadata_genotype"] == "Mid-Severity"]
wt_df = features_long_df[features_long_df["Metadata_genotype"] == "Wild Type"]

# each feature group
high_df_AreaShape = high_df[high_df["feature_group"] == "AreaShape"]
high_df_Intensity = high_df[high_df["feature_group"] == "Intensity"]
high_df_Neighbors = high_df[high_df["feature_group"] == "Neighbors"]
high_df_radial = high_df[high_df["feature_group"] == "RadialDistribution"]
high_df_Granularity = high_df[high_df["feature_group"] == "Granularity"]

unsel_df_AreaShape = unsel_df[unsel_df["feature_group"] == "AreaShape"]
unsel_df_Intensity = unsel_df[unsel_df["feature_group"] == "Intensity"]
unsel_df_Neighbors = unsel_df[unsel_df["feature_group"] == "Neighbors"]
unsel_df_radial = unsel_df[unsel_df["feature_group"] == "RadialDistribution"]
unsel_df_Granularity = unsel_df[unsel_df["feature_group"] == "Granularity"]

wt_df_AreaShape = wt_df[wt_df["feature_group"] == "AreaShape"]
wt_df_Intensity = wt_df[wt_df["feature_group"] == "Intensity"]
wt_df_Neighbors = wt_df[wt_df["feature_group"] == "Neighbors"]
wt_df_radial = wt_df[wt_df["feature_group"] == "RadialDistribution"]
wt_df_Granularity = wt_df[wt_df["feature_group"] == "Granularity"]

# levene test for each feature group
levene_test_results = {
    "feature_group": [],
    "levene_statistic": [],
    "levene_p_value": [],
    "group": [],
}

group_dict = {
    "AreaShape": {
        "high_area_v_unsel_area": [high_df_AreaShape, unsel_df_AreaShape],
        "high_area_v_wt_area": [high_df_AreaShape, wt_df_AreaShape],
        "unsel_area_v_wt_area": [wt_df_AreaShape, unsel_df_AreaShape],
    },
    "Intensity": {
        "high_intensity_v_unsel_intensity": [high_df_Intensity, unsel_df_Intensity],
        "high_intensity_v_wt_intensity": [high_df_Intensity, wt_df_Intensity],
        "unsel_intensity_v_wt_intensity": [wt_df_Intensity, unsel_df_Intensity],
    },
    "Neighbors": {
        "high_neighbors_v_unsel_neighbors": [high_df_Neighbors, unsel_df_Neighbors],
        "high_neighbors_v_wt_neighbors": [high_df_Neighbors, wt_df_Neighbors],
        "unsel_neighbors_v_wt_neighbors": [wt_df_Neighbors, unsel_df_Neighbors],
    },
    "RadialDistribution": {
        "high_radial_v_unsel_radial": [high_df_radial, unsel_df_radial],
        "high_radial_v_wt_radial": [high_df_radial, wt_df_radial],
        "unsel_radial_v_wt_radial": [wt_df_radial, unsel_df_radial],
    },
    "Granularity": {
        "high_granularity_v_unsel_granularity": [
            high_df_Granularity,
            unsel_df_Granularity,
        ],
        "high_granularity_v_wt_granularity": [high_df_Granularity, wt_df_Granularity],
        "unsel_granularity_v_wt_granularity": [wt_df_Granularity, unsel_df_Granularity],
    },
}

for feature_group in tqdm.tqdm(group_dict.keys()):
    for group in group_dict[feature_group].keys():
        if not group == "all":
            levene_results = levene(
                group_dict[feature_group][group][0]["value"],
                group_dict[feature_group][group][1]["value"],
            )
            # calculate the variance for each feature group

            levene_test_results["feature_group"].append(feature_group)
            levene_test_results["levene_statistic"].append(levene_results.statistic)
            levene_test_results["levene_p_value"].append(levene_results.pvalue)
            levene_test_results["group"].append(group)
        else:
            pass

levene_test_results_df = pd.DataFrame(levene_test_results)
levene_test_results_df.head()


# In[12]:


# save the levene test results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
levene_test_results_path = pathlib.Path(
    out_dir / "mean_aggregated_levene_test_results_feature_types.csv"
)
levene_test_results_df.to_csv(levene_test_results_path, index=False)


# In[13]:


# Drop all metadata except for the genotype data
features_df = data.drop(columns=data.filter(like="Metadata").columns)
features_df["Metadata_genotype"] = data["Metadata_genotype"]

# turn the features into a long format
features_long_df = features_df.melt(
    id_vars="Metadata_genotype", var_name="feature", value_name="value"
)
features_long_df


# In[14]:


# get the variance for each feature group
var_df = features_long_df.groupby(["Metadata_genotype", "feature"]).var().reset_index()
var_df.head()
# change the value column name to variance
var_df.rename(columns={"value": "variance"}, inplace=True)


# In[15]:


var_df[
    ["feature_group", "measurement", "bone", "parameter1", "parameter2", "parameter3"]
] = var_df["feature"].str.split("_", expand=True)

# Replace the Metadata_genotype with the actual genotype name
var_df["Metadata_genotype"] = var_df["Metadata_genotype"].replace(
    {"high": "High-Severity", "unsel": "Mid-Severity", "wt": "Wild Type"}
)
var_df
var_df = var_df.drop(
    columns=["feature", "measurement", "bone", "parameter1", "parameter2", "parameter3"]
)
var_df
# save the variance results
var_path = pathlib.Path(out_dir / "mean_aggregated_variance_results_feature_types.csv")
var_df.to_csv(var_path, index=False)


# In[16]:


# get the mean and stdev for each feature group's variance
var_df = (
    var_df.groupby(["Metadata_genotype", "feature_group"])
    .agg(["mean", "std", "max", "min", "count"])
    .reset_index()
)
# ungroup the columns
var_df.columns = ["_".join(col).strip() for col in var_df.columns.values]
# rename the Metadata_genotype_ column and the feature_group_ column
var_df.rename(
    columns={
        "Metadata_genotype_": "Metadata_genotype",
        "feature_group_": "feature_group",
    },
    inplace=True,
)
var_df


# In[17]:


# save the variance results
var_path = pathlib.Path(
    out_dir / "mean_aggregated_variance_results_feature_types_stats.csv"
)
var_df.to_csv(var_path, index=False)
