#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import pandas as pd

# In[2]:


input_path = pathlib.Path(
    "../../data/5.converted_data/mean_aggregated_data.parquet"
).resolve(strict=True)


# In[3]:


# read in the data
df = pd.read_parquet(input_path)
df.head()


# In[4]:


# drop the columns that are not needed
uneeded_columns = ["Metadata_replicate", "Metadata_side"]
df = df.drop(columns=uneeded_columns)


# In[5]:


# get the variance of each feature for each genotype
variances = df.groupby("Metadata_genotype").var()
variances


# In[6]:


# save the per feature per genotype variance data
output_path = pathlib.Path(
    "../results/mean_aggregated_results/mean_aggregated_per_feature_per_genotype_variance.csv"
).resolve()
variances.to_csv(output_path)
