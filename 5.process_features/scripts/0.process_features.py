#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib
import sqlite3

import numpy as np
import pandas as pd
from cytotable import convert

# In[2]:


# set paths
dest_datatype = "parquet"

# common configurations to use based on typical CellProfiler SQLite outputs
preset = "cellprofiler_sqlite_pycytominer"

input_dir = pathlib.Path("../../data/4.sqlite_output")

# directory where parquet files are saved to
output_dir = pathlib.Path("../../data/5.converted_data")
output_dir.mkdir(exist_ok=True)

source_path = input_dir / "OP_features.sqlite"
dest_path = output_dir / f"OP_features.{dest_datatype}"


# In[3]:


# Read in the sqlite file via sqlite3
conn = sqlite3.connect(source_path)

tables = pd.read_sql_query("SELECT name FROM sqlite_master WHERE type='table';", conn)
tables = tables["name"].values
tables


# In[4]:


images_df = pd.read_sql_query(f"SELECT * FROM Per_Image", conn)
# select columns to keep in the final dataframe
columns_to_keep = ["ImageNumber", "Image_FileName_OP"]
images_df = images_df[columns_to_keep]


# In[5]:


query = "SELECT * FROM Per_Object"
df = pd.read_sql_query(query, conn)


# combine the two dataframes on ImageNumber
df = df.merge(images_df, on="ImageNumber")
conn.close()


# In[6]:


# max columns
pd.set_option("display.max_columns", None)
print(df.shape)
df.head()


# In[7]:


# get the column names that have BoundingBox in them
bounding_box_cols = [x for x in df.columns if "BoundingBox" in x]
# get the column names that have Location in them
location_cols = [x for x in df.columns if "Location" in x]
# get the column names that have Center in them
center_cols = [x for x in df.columns if "Center" in x]
# manual list
manual_cols = [
    "ImageNumber",
    "Image_FileName_OP",
    "ObjectNumber",
    "ConvertImageToObjects_Number_Object_Number",
]

final_metadata_cols = manual_cols + bounding_box_cols + location_cols + center_cols


# In[8]:


# select all of the metadata columns
metadata_df = df[final_metadata_cols]
metadata_df.head()
# add "Metadata to the front of the column names"
metadata_df.columns = ["Metadata_" + x for x in metadata_df.columns]
metadata_df.head()


# In[9]:


# get the ConvertImageToObjects columns and remove the ConvertImageToObjects_ prefix
convert_cols = [x for x in df.columns if "ConvertImageToObjects" in x]
convert_df = df[convert_cols]
convert_df.columns = [
    x.replace("ConvertImageToObjects_", "") for x in convert_df.columns
]
convert_df.head()


# In[14]:


# add the metadata and convert dataframes together
df = pd.concat([metadata_df, convert_df], axis=1)
duplicates = df.columns[df.columns.duplicated()].tolist()
print("Duplicate columns are:", duplicates)
# drop the duplicate columns
df = df.loc[:, ~df.columns.duplicated()]


# In[15]:


df


# In[16]:


# write the df to a parquet file
df.to_parquet(dest_path, index=False)


# In[13]:
