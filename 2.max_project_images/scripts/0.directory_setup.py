#!/usr/bin/env python
# coding: utf-8

# Please run me prior to running the ImageJ Macro. I will create the necessary folders and download the necessary files for the ImageJ Macro to run.

# In[1]:


import pathlib

# In[2]:


# import image_path
image_path = pathlib.Path("../../data/2.crops/")
# max_projection paths
max_projection_path = pathlib.Path("../../data/3.maximum_projections_and_masks")

# create directories if they don't exist
image_path.mkdir(parents=True, exist_ok=True)
max_projection_path.mkdir(parents=True, exist_ok=True)


# In[3]:


print("Paths created.")
print('Please ensure that the raw images are in the folder "data/0.raw_images".')
