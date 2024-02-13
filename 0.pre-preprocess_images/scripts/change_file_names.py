#!/usr/bin/env python
# coding: utf-8

# Replace the strings to rename the file names

# In[ ]:


import pathlib

# In[ ]:


# set path to the input files
input_path = pathlib.Path("../../data/00.raw_images_ims/").resolve()

# set path to the output files
output_path = pathlib.Path("../../data/0.raw_images_tiff/").resolve()

# create output path if it does not exist
output_path.mkdir(parents=True, exist_ok=True)

# get all files in the input path
files = input_path.glob("*.ims")


# In[ ]:


for file in files:
    new_file = (
        str(file)
        .replace(" ", "_")
        .replace("561_RFP_CF40_iXon_EMCCD_", "")
        .replace("Protocol_7_", "")
        .replace("CZC14992TJ", "")
        .split("_2024-")[0]
    )
    new_file = f"{new_file}.ims"
    print(file)
    # rename the file
    file.rename(new_file)
