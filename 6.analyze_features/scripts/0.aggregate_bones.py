#!/usr/bin/env python
# coding: utf-8

# This notebook aggregates each bone on a per fish basis.
# We will be aggregating via the following methods:
# - Mean
# - Sum
# - Custom defined per feature

# In[1]:


import pathlib

import numpy as np
import pandas as pd

# In[2]:


# set the path to the processed data
unaggregated_fs_data_path = pathlib.Path(
    "../../data/5.converted_data/normalized_feature_selected_output.parquet"
).resolve(strict=True)

# custom aggregation type
custom_aggregated_type_path = pathlib.Path(
    "../utils/morphology_aggregation_method.csv"
).resolve(strict=True)

# output data paths
# mean aggregated data
mean_aggregated_data_path = pathlib.Path(
    "../../data/5.converted_data/mean_aggregated_data.parquet"
).resolve()

# sum aggregated data
sum_aggregated_data_path = pathlib.Path(
    "../../data/5.converted_data/sum_aggregated_data.parquet"
).resolve()

# custom aggregation data
custom_aggregated_data_path = pathlib.Path(
    "../../data/5.converted_data/custom_aggregated_data.parquet"
).resolve()

# unaggregated data path
unaggregated_data_path = pathlib.Path(
    "../../data/5.converted_data/non_aggregated_data.parquet"
).resolve()


# In[3]:


# read the data
unaggregated_fs_data = pd.read_parquet(unaggregated_fs_data_path)

# show the data shape
print(f"unaggregated_fs_data shape: {unaggregated_fs_data.shape}")
unaggregated_fs_data.head()


# ## Get the features for the fs data

# In[4]:


# get the metadata
metadata_cols = unaggregated_fs_data.columns[
    unaggregated_fs_data.columns.str.contains("Metadata")
]
metadata_cols

# get the features df
fs_data = unaggregated_fs_data.drop(metadata_cols, axis=1)
fs_data.insert(0, "Metadata_replicate", unaggregated_fs_data["Metadata_replicate"])
fs_data.insert(0, "Metadata_genotype", unaggregated_fs_data["Metadata_genotype"])
fs_data.insert(0, "Metadata_side", unaggregated_fs_data["Metadata_side"])
print(f"fs_data shape: {fs_data.shape}")
fs_data.head()


# ### Mean

# In[5]:


# aggregate the data and get the mean
mean_aggreated_data = (
    fs_data.groupby(["Metadata_genotype", "Metadata_replicate", "Metadata_side"])
    .mean()
    .reset_index()
)
print(f"aggreated_data shape: {mean_aggreated_data.shape}")
# save the data
mean_aggreated_data.to_parquet(mean_aggregated_data_path)


# ### Sum

# In[6]:


# aggregate the data and get the sum
sum_aggreated_data = (
    fs_data.groupby(["Metadata_genotype", "Metadata_replicate", "Metadata_side"])
    .sum()
    .reset_index()
)
print(f"aggreated_data shape: {sum_aggreated_data.shape}")
# save the data
sum_aggreated_data.to_parquet(sum_aggregated_data_path)


# ### Custom defined per feature

# In[7]:


# read in the custom aggregation method
custom_aggregated_method = pd.read_csv(custom_aggregated_type_path)
print(custom_aggregated_method.shape)
# Double check that the features are in the data
for feature in custom_aggregated_method["Feature"]:
    assert feature in fs_data.columns, f"{feature} not found in the data"


# In[8]:


# define an output dataframe to store the custom aggregated data
custom_aggregated_data = pd.DataFrame()

# define the metadata columns to aggregate by
metadata_cols = ["Metadata_genotype", "Metadata_replicate", "Metadata_side"]

# loop through the features and aggregate the data
for feature in custom_aggregated_method["Feature"]:
    # get the aggregation method
    agg_method = custom_aggregated_method[
        custom_aggregated_method["Feature"] == feature
    ]["Aggregation"].values[0]
    # get the data
    feature_data = fs_data[metadata_cols + [feature]]
    # aggregate the data
    if agg_method == "Mean":
        feature_data = feature_data.groupby(metadata_cols).mean().reset_index()
    elif agg_method == "Sum":
        feature_data = feature_data.groupby(metadata_cols).sum().reset_index()
    else:
        raise ValueError(f"Aggregation method {agg_method} not recognized")
    # add the data to the output
    custom_aggregated_data = pd.concat([custom_aggregated_data, feature_data], axis=1)

# drop duplicate columns
custom_aggregated_data = custom_aggregated_data.loc[
    :, ~custom_aggregated_data.columns.duplicated()
]
print(f"custom_aggregated_data shape: {custom_aggregated_data.shape}")

# save the data
custom_aggregated_data.to_parquet(custom_aggregated_data_path)


# ## non-aggregated features

# In[9]:


# non aggregated data
non_aggregated_data = fs_data.copy()
non_aggregated_data.to_parquet(unaggregated_data_path)
