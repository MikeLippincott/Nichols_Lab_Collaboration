#!/usr/bin/env python
# coding: utf-8

# Please run me prior to running the ImageJ Macro. I will create the necessary folders and download the necessary files for the ImageJ Macro to run.

# In[3]:


import pathlib

# In[4]:


# import image_path
image_path = pathlib.Path("../../data/0.raw_images/")
# max_projection paths
max_projection_path = pathlib.Path("../../data/1.maximum_projections/")

# create directories if they don't exist
image_path.mkdir(parents=True, exist_ok=True)
max_projection_path.mkdir(parents=True, exist_ok=True)


# In[5]:


print("Paths created.")
print('Please ensure that the raw images are in the folder "data/0.raw_images".')
