#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import statsmodels.api as sm

# improt anova and tukeyhsd
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# In[2]:


file_path = pathlib.Path(
    "../../data/5.converted_data/normalized_feature_selected_output.parquet"
)
df = pd.read_parquet(file_path)
df.head()


# In[3]:


# combine the genotype and idenity columns
df["Metadata_unique"] = df["Metadata_genotype"] + "_" + df["Metadata_identity"]
# split the features and the metadata
metadata = df.columns.str.contains("Metadata")
# filter the metadata
metadata_df = df.loc[:, metadata]
# filter the features
features_df = df.loc[:, ~metadata]
features_df["Metadata_unique"] = metadata_df["Metadata_unique"]
features_df


# In[4]:


# anova and tukeyhsd for each feature
# create a list to store the results
anova_results = pd.DataFrame()

# loop through each feature
for feature in features_df.columns[:-1]:
    # create a model
    model = ols(f"{feature} ~ C(Metadata_unique)", data=features_df).fit()
    # create an anova table
    anova_table = sm.stats.anova_lm(model, typ=2)
    # create a tukeyhsd table
    tukeyhsd = pairwise_tukeyhsd(features_df[feature], features_df["Metadata_unique"])

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


# In[5]:


anova_results


# In[6]:


# export the anova results
# out dir
out_dir = pathlib.Path("../../data/6.analysis_results/")
# create the dir if it does not exist
out_dir.mkdir(parents=True, exist_ok=True)
anova_results_paht = out_dir / "anova_results.parquet"
anova_results.to_parquet(anova_results_paht)
