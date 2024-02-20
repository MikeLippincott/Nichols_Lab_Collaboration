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

# improt anova and tukeyhsd
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
    # create a list to store the results
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
        # tmp['unique'] = tmp['group1'] + "_" + tmp['group2'] + "_" + feature
        tmp = pd.DataFrame(tmp)

        anova_results = pd.concat([anova_results, tmp], axis=0).reset_index(drop=True)
    return anova_results


# In[3]:


file_path = pathlib.Path(
    "../../data/5.converted_data/normalized_feature_selected_output.parquet"
)
df = pd.read_parquet(file_path)
df.head()


# In[4]:


# combine the genotype and idenity columns
df["Metadata_genotype_side"] = df["Metadata_genotype"] + "_" + df["Metadata_side"]
df["Metadata_genotype_identity_side"] = (
    df["Metadata_genotype"] + "_" + df["Metadata_identity"] + "_" + df["Metadata_side"]
)
# split the features and the metadata
metadata = df.columns.str.contains("Metadata")
# filter the metadata
metadata_df = df.loc[:, metadata]
# filter the features
features_df = df.loc[:, ~metadata]


# ## Anova for genotype only

# In[5]:


genotype_df = features_df.copy()
genotype_df.loc[:, "Metadata_genotype"] = metadata_df["Metadata_genotype"]
anova_results = anova_function(genotype_df, "Metadata_genotype")
# export the anova results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
anova_results_path = out_dir / "anova_results_genotype.parquet"
anova_results.to_parquet(anova_results_path)


# ## Anova for genotype and side

# In[6]:


genotype_df = features_df.copy()
genotype_df.loc[:, "Metadata_genotype_side"] = metadata_df["Metadata_genotype_side"]
anova_results = anova_function(genotype_df, "Metadata_genotype_side")
# export the anova results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
anova_results_path = out_dir / "anova_results_genotype_side.parquet"
anova_results.to_parquet(anova_results_path)


# ## Anova for genotype, side, and identity

# In[7]:


genotype_df = features_df.copy()
genotype_df.loc[:, "Metadata_genotype_identity_side"] = metadata_df[
    "Metadata_genotype_identity_side"
]
anova_results = anova_function(genotype_df, "Metadata_genotype_identity_side")
# export the anova results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
anova_results_path = out_dir / "anova_results_genotype_side_identity.parquet"
anova_results.to_parquet(anova_results_path)
