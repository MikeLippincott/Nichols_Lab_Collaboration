#!/usr/bin/env python
# coding: utf-8

# This notebook calculates the Mahalanobis distance between points on a PCA.
# I will document more about what Mahalanobis distance is and how it is calculated in this notebook.

# In[4]:


import pathlib

import pandas as pd
from scipy.spatial.distance import mahalanobis

# In[5]:


# set the path to the data
mean_aggregated_data_path = pathlib.Path(
    "../../data/6.analysis_results/mean_aggregated_pca.parquet"
).resolve(strict=True)

# read the data
mean_aggregated_data = pd.read_parquet(mean_aggregated_data_path)
print(mean_aggregated_data.shape)
mean_aggregated_data.head()


# # Mahalanobis Distance
# For more in depth information on Mahalanobis distance, please refer to this [link](https://medium.com/@the_daft_introvert/mahalanobis-distance-5c11a757b099).
# Mahalanobis distance is a measure of the distance between a point P and a distribution D.
# It is a multi-dimensional generalization of the idea of measuring how many standard deviations away P is from the mean of D.
# This distance is zero if P is at the mean of D, and grows as P moves away from the mean along each principal component axis.
# The formula for Mahalanobis distance is given by:
# ### $D^2 = (x - \mu)^T \Sigma^{-1} (x - \mu)$
# where:
# - $D$ is the Mahalanobis distance

# In[ ]:


# In[ ]:
