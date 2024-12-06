#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import numpy as np
import pandas as pd

# In[2]:


file_path = pathlib.Path(
    "../../data/6.analysis_results/mean_aggregated_levene_test_results.csv"
).resolve(strict=True)


df = pd.read_csv(file_path, index_col=0).reset_index(drop=True)
df


# In[3]:


# subset the data
high_vs_wt = df.loc[df["group"] == "high_vs_wt"]
unsel_vs_wt = df.loc[df["group"] == "unsel_vs_wt"]
high_vs_unsel = df.loc[df["group"] == "high_vs_unsel"]

high_vs_wt.rename(
    columns={
        "levene_p_value": "high_vs_wt_levene_p_value",
        "holm_bonferroni_p_value": "high_vs_wt_levene_p_value_holm_bonferroni",
    },
    inplace=True,
)
unsel_vs_wt.rename(
    columns={
        "levene_p_value": "unsel_vs_wt_levene_p_value",
        "holm_bonferroni_p_value": "unsel_vs_wt_levene_p_value_holm_bonferroni",
    },
    inplace=True,
)
high_vs_unsel.rename(
    columns={
        "levene_p_value": "high_vs_unsel_levene_p_value",
        "holm_bonferroni_p_value": "high_vs_unsel_levene_p_value_holm_bonferroni",
    },
    inplace=True,
)


# drop columns
high_vs_wt.drop(columns=["group", "levene_statistic"], inplace=True)
unsel_vs_wt.drop(columns=["group", "levene_statistic"], inplace=True)
high_vs_unsel.drop(columns=["group", "levene_statistic"], inplace=True)


# combine the data
combined_df = pd.merge(high_vs_wt, unsel_vs_wt, on="feature")
combined_df = pd.merge(combined_df, high_vs_unsel, on="feature")
combined_df.head()


# In[4]:


variance_df_path = pathlib.Path(
    "../../data/6.analysis_results/mean_aggregated_variance_results_each_feature.csv"
).resolve(strict=True)
variance_df = pd.read_csv(variance_df_path)
variance_df.head()


# In[5]:


# replace metadata genotype with the correct group
variance_df["Metadata_genotype"].replace(
    {"high": "High-Severity", "unsel": "Mid-Severity", "wt": "Wild Type"}, inplace=True
)
variance_df.head()


# In[6]:


high_severity = variance_df.loc[variance_df["Metadata_genotype"] == "High-Severity"]
mid_severity = variance_df.loc[variance_df["Metadata_genotype"] == "Mid-Severity"]
wt = variance_df.loc[variance_df["Metadata_genotype"] == "Wild Type"]

# rename the columns
high_severity.rename(columns={"variance": "high_severity_variance"}, inplace=True)
mid_severity.rename(columns={"variance": "mid_severity_variance"}, inplace=True)
wt.rename(columns={"variance": "wild_type_severity_variance"}, inplace=True)

# drop columns
high_severity.drop(columns=["Metadata_genotype"], inplace=True)
mid_severity.drop(columns=["Metadata_genotype"], inplace=True)
wt.drop(columns=["Metadata_genotype"], inplace=True)

high_severity.reset_index(drop=True, inplace=True)
mid_severity.reset_index(drop=True, inplace=True)
wt.reset_index(drop=True, inplace=True)


# In[7]:


all_severities = pd.merge(
    mid_severity, high_severity, left_on="feature", right_on="feature"
)
all_severities = pd.merge(all_severities, wt, left_on="feature", right_on="feature")
combined_df = pd.merge(combined_df, all_severities, on="feature")
combined_df.head()


# In[8]:


# make a new column that contains permutation test results for each feature
np.random.seed(0)
n_permutations = 1000
# permute each column
permuted_df = combined_df.copy()
for column in permuted_df.columns:
    if column != "feature":
        permuted_df[column] = np.random.permutation(permuted_df[column].values)


# In[9]:


combined_df.head()


# We now identify which complexes match the exact hypothesis of the problem.
# The hypothesis is that the high-severity and wild type genotype complexes have less morphology variance than that of the unselected severity genotype complexes.
# In addition there should be no statistically significant difference between the variance of morphology high-severity and wild type genotype complexes.

# In[10]:


dict_of_dfs = {"non_permuted": combined_df, "permuted": permuted_df}
output_dfs = {"non_permuted": "", "permuted": ""}
for data_shuffle_df in dict_of_dfs:
    df = dict_of_dfs[data_shuffle_df]
    # variance logic
    # wt < mid
    # mid > high
    df["variance_pattern_bool"] = np.where(
        (df["high_severity_variance"] < df["mid_severity_variance"])
        & (df["wild_type_severity_variance"] < df["mid_severity_variance"]),
        True,
        False,
    )
    # levene logic
    # high_vs_unsel <0.05
    # wt_vs_unsel <0.05
    # high_vs_wt >0.05
    df["significance_bool_holm_bonferroni"] = np.where(
        (df["high_vs_unsel_levene_p_value_holm_bonferroni"] < 0.05)
        & (df["unsel_vs_wt_levene_p_value_holm_bonferroni"] < 0.05)
        & (df["high_vs_wt_levene_p_value_holm_bonferroni"] > 0.05),
        True,
        False,
    )

    df["significance_bool_half_baked_holm_bonferroni"] = np.where(
        (df["high_vs_unsel_levene_p_value_holm_bonferroni"] < 0.05)
        & (df["unsel_vs_wt_levene_p_value_holm_bonferroni"] < 0.05),
        True,
        False,
    )

    df["hypothesis_test_bool"] = np.where(
        (df["variance_pattern_bool"] == True)
        & (df["significance_bool_holm_bonferroni"] == True),
        True,
        False,
    )
    df["hypothesis_test_bool_half_baked"] = np.where(
        (df["variance_pattern_bool"] == True)
        & (df["significance_bool_half_baked_holm_bonferroni"] == True),
        True,
        False,
    )

    output_dfs[data_shuffle_df] = df


# In[11]:


list_of_enrichment_dfs = []
for data_shuffle_df in output_dfs:
    df = output_dfs[data_shuffle_df]
    # split the feature column
    df[
        [
            "feature_group",
            "measurement",
            "bone",
            "parameter1",
            "parameter2",
            "parameter3",
        ]
    ] = df["feature"].str.split("_", expand=True)

    # get counts of each feature group and the hypothesis test bool
    hypothesis_tests_half_baked_df = (
        df.groupby(
            [
                "feature_group",
                "variance_pattern_bool",
                "significance_bool_half_baked_holm_bonferroni",
                "hypothesis_test_bool_half_baked",
            ]
        )
        .size()
        .reset_index(name="counts")
    )
    hypothesis_tests_half_baked_df["permutation"] = data_shuffle_df
    list_of_enrichment_dfs.append(hypothesis_tests_half_baked_df)
final_enrichment_half_baked_df = pd.concat(list_of_enrichment_dfs)
final_enrichment_half_baked_df.reset_index(drop=True, inplace=True)


# In[12]:


list_of_enrichment_dfs = []
for data_shuffle_df in output_dfs:
    df = output_dfs[data_shuffle_df]
    # split the feature column
    df[
        [
            "feature_group",
            "measurement",
            "bone",
            "parameter1",
            "parameter2",
            "parameter3",
        ]
    ] = df["feature"].str.split("_", expand=True)

    # get counts of each feature group and the hypothesis test bool
    hypothesis_tests_df = (
        df.groupby(
            [
                "feature_group",
                "variance_pattern_bool",
                "significance_bool_holm_bonferroni",
                "hypothesis_test_bool",
            ]
        )
        .size()
        .reset_index(name="counts")
    )
    hypothesis_tests_df["permutation"] = data_shuffle_df
    list_of_enrichment_dfs.append(hypothesis_tests_df)
final_enrichment_df = pd.concat(list_of_enrichment_dfs)
final_enrichment_df.reset_index(drop=True, inplace=True)


# In[13]:


final_enrichment_half_baked_df.head(60)


# In[14]:


final_enrichment_df.head(60)


# In[15]:


# save the final enrichment df
final_enrichment_half_baked_df.to_csv(
    "../../data/6.analysis_results/mean_aggregated_feature_group_enrichment_half_baked.csv",
    index=False,
)

final_enrichment_df.to_csv(
    "../../data/6.analysis_results/mean_aggregated_feature_group_enrichment.csv",
    index=False,
)
