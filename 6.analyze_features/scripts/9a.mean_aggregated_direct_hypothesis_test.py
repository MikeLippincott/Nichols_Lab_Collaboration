#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import numpy as np
import pandas as pd

# In[7]:


file_path = pathlib.Path(
    "../../data/6.analysis_results/mean_aggregated_levene_test_results.csv"
)
df = pd.read_csv(file_path, index_col=0).reset_index(drop=True)
df


# In[15]:


# subset the data
high_vs_wt = df.loc[df["group"] == "high_vs_wt"]
unsel_vs_wt = df.loc[df["group"] == "unsel_vs_wt"]
high_vs_unsel = df.loc[df["group"] == "high_vs_unsel"]
all_groups = df.loc[df["group"] == "all"]

high_vs_wt.rename(columns={"levene_p_value": "high_vs_wt_levene_p_value"}, inplace=True)
unsel_vs_wt.rename(
    columns={"levene_p_value": "unsel_vs_wt_levene_p_value"}, inplace=True
)
high_vs_unsel.rename(
    columns={"levene_p_value": "high_vs_unsel_levene_p_value"}, inplace=True
)
all_groups.rename(columns={"levene_p_value": "all_groups_levene_p_value"}, inplace=True)

# drop columns
high_vs_wt.drop(columns=["group", "levene_statistic"], inplace=True)
unsel_vs_wt.drop(columns=["group", "levene_statistic"], inplace=True)
high_vs_unsel.drop(columns=["group", "levene_statistic"], inplace=True)
all_groups.drop(columns=["group", "levene_statistic"], inplace=True)

# combine the data
combined_df = pd.merge(high_vs_wt, unsel_vs_wt, on="feature")
combined_df = pd.merge(combined_df, high_vs_unsel, on="feature")
combined_df = pd.merge(combined_df, all_groups, on="feature")
combined_df.head()


# In[21]:


# make a 0 1 bool column for significance for each group
combined_df["high_vs_wt_bool"] = combined_df["high_vs_wt_levene_p_value"] < 0.05
combined_df["unsel_vs_wt_bool"] = combined_df["unsel_vs_wt_levene_p_value"] < 0.05
combined_df["high_vs_unsel_bool"] = combined_df["high_vs_unsel_levene_p_value"] < 0.05
combined_df["all_groups_bool"] = combined_df["all_groups_levene_p_value"] < 0.05
# conver the bool to int
combined_df["high_vs_wt_bool"] = combined_df["high_vs_wt_bool"].astype(int)
combined_df["unsel_vs_wt_bool"] = combined_df["unsel_vs_wt_bool"].astype(int)
combined_df["high_vs_unsel_bool"] = combined_df["high_vs_unsel_bool"].astype(int)
combined_df["all_groups_bool"] = combined_df["all_groups_bool"].astype(int)

combined_df["hypothesis_match"] = np.where(
    (combined_df["high_vs_wt_bool"] == 0)
    & (combined_df["unsel_vs_wt_bool"] == 1)
    & (combined_df["high_vs_unsel_bool"] == 1),
    1,
    0,
)


combined_df["hypothesis_match"].value_counts()


# In[25]:


variance_df_path = pathlib.Path(
    "../../data/6.analysis_results/custom_aggregated_variance_results_feature_types.csv"
).resolve(strict=True)


# In[27]:


variance_df = pd.read_csv(variance_df_path)
variance_df


# In[ ]:
