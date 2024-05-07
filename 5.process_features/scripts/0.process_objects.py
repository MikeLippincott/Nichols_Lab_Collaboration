#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

# impot open cv
import cv2
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from cytotable import convert, presets
from skimage import io

# In[2]:


# set paths
dest_datatype = "parquet"

input_dir = pathlib.Path("../../data/4.sqlite_output")

# directory where parquet files are saved to
output_dir = pathlib.Path("../../data/5.converted_data")
output_dir.mkdir(exist_ok=True)

source_path = input_dir / "output.sqlite"
dest_path = output_dir / f"output.{dest_datatype}"


# In[3]:


convert(
    source_path=source_path,
    dest_path=dest_path,
    dest_datatype=dest_datatype,
    metadata=["image"],
    compartments=["object"],
    identifying_columns=["ImageNumber"],
    joins="""
        SELECT
            *
        FROM
            read_parquet('per_image.parquet') as per_image
        INNER JOIN read_parquet('per_object.parquet') AS per_object ON
            per_object.Metadata_ImageNumber = per_image.Metadata_ImageNumber
        """,
)


# In[4]:


# read in the parquet file
df = pd.read_parquet(dest_path)


# In[5]:


# From Jenna Tomkinson:
# path to unwanted image cols text file
unwanted_list_path = pathlib.Path("../unwanted_image_cols.txt")
# Load the list of columns to remove from the text file
with open(unwanted_list_path, "r") as file:
    columns_to_remove = [line.strip() for line in file]
# remove columns from the dataframe
df = df.drop(columns=columns_to_remove)


# In[6]:


# get the column names that have BoundingBox in them
bounding_box_cols = [x for x in df.columns if "BoundingBox" in x]
# get the column names that have Location in them
location_cols = [x for x in df.columns if "Location" in x]
# get the column names that have Center in them
center_cols = [x for x in df.columns if "Center" in x]
# manual list
manual_cols = [
    "Image_FileName_OP",
    "ObjectNumber",
    "Object_ConvertImageToObjects_Number_Object_Number",
]

final_metadata_cols = manual_cols + bounding_box_cols + location_cols + center_cols


# In[7]:


# select all of the metadata columns
metadata_df = df[final_metadata_cols]
metadata_df.head()
# add "Metadata to the front of the column names"
metadata_df.columns = ["Metadata_" + x for x in metadata_df.columns]
metadata_df["Metadata_ImageNumber"] = df["Metadata_ImageNumber"]
metadata_df.head()

df = df.drop(columns=final_metadata_cols)


# In[8]:


metadata_df


# In[9]:


# get the ConvertImageToObjects columns and remove the ConvertImageToObjects_ prefix
convert_cols = [x for x in df.columns if "ConvertImageToObjects" in x]
convert_df = df[convert_cols]

# replace the ConvertImageToObjects_ prefix with ""
convert_df.columns = [
    x.replace("ConvertImageToObjects_", "") for x in convert_df.columns
]
convert_df.columns = [x.replace("Object_", "") for x in convert_df.columns]
convert_df.drop(columns=["Image_Count_ConvertImageToObjects"], inplace=True)
convert_df.head()


# In[10]:


# add the metadata and convert dataframes together
df = pd.concat([metadata_df, convert_df], axis=1)
duplicates = df.columns[df.columns.duplicated()].tolist()
print("Duplicate columns are:", duplicates)
# drop the duplicate columns
df = df.loc[:, ~df.columns.duplicated()]
# filter out small objects
df = df[df["AreaShape_Area"] > 100]
# if column contains Image_Mean then remove
df = df.loc[:, ~df.columns.str.contains("Image_Mean_")]
df = df.loc[:, ~df.columns.str.contains("Image_Median_")]
df = df.loc[:, ~df.columns.str.contains("Image_StDev_")]


# In[11]:


# split the dataframe into 3 dataframes by genotype
df1 = df[df["Metadata_Image_FileName_OP"].str.contains("wt")]
df2 = df[df["Metadata_Image_FileName_OP"].str.contains("unsel")]
df3 = df[df["Metadata_Image_FileName_OP"].str.contains("high")]

print(f"Original dataframe shape: {df.shape}")
print(f"WT dataframe shape: {df1.shape}")
print(f"Unselected dataframe shape: {df2.shape}")
print(f"High dataframe shape: {df3.shape}")

# df1 is the wt dataframe
# df2 is the unsel dataframe
# df3 is the high dataframe

# filter the df to have the object with the largest area
df3 = df3.loc[df3.groupby("Metadata_ImageNumber")["AreaShape_Area"].idxmax()]

# filter the df to have the 2 objects with the 2 largest areas
df1 = df1.loc[
    df1.groupby("Metadata_ImageNumber")["AreaShape_Area"]
    .nlargest(2)
    .index.get_level_values(1)
]
df2 = df2.loc[
    df2.groupby("Metadata_ImageNumber")["AreaShape_Area"]
    .nlargest(2)
    .index.get_level_values(1)
]

print(f"Filtered dataframe shape: {df.shape}")
print(f"Filtered WT dataframe shape: {df1.shape}")
print(f"Filtered Unselected dataframe shape: {df2.shape}")
print(f"Filtered High dataframe shape: {df3.shape}")


df = pd.concat([df1, df2, df3])


# Theorectical number of objects:
#
# 2 sides (L and R)
# 2 bones per side for unsel and wt, 1 bone per side for high
# 15 fish (1-15) per genotype
# 3 genotypes (wt, unsel, high)
#
# 2 x 15 = 30 objects for high
# 2 x 2 x 15 x 2 = 60 objects for wt
# between 2 x 2 x 15 x 2 = 30 and 2 x 2 x 15 x 3 = 60 objects for unsel
#
# Total = 120-150 objects theoretically

# In[12]:


# keep the two largest areas for each image
df = df.sort_values(by=["Metadata_ImageNumber", "AreaShape_Area"], ascending=False)

# get the top two largest areas for each image
df = df.groupby("Metadata_ImageNumber").head(2)
df.rename(
    columns={"Number_Object_Number": "Metadata_Number_Object_Number"}, inplace=True
)
df.shape


# In[13]:


df


# ## Annotate objects

# In[14]:


# sort by Metadata_ImageNumber
df = df.sort_values(by=["Metadata_ImageNumber"], ascending=True)
df.reset_index(drop=True, inplace=True)


# In[15]:


input_dir = pathlib.Path("../../data/3.maximum_projections_and_masks").resolve()


# In[16]:


# set the image size when printed
plt.rcParams["figure.figsize"] = (1, 1)


# In[17]:


for i in range(df.shape[0]):

    image_path = df.loc[i, "Metadata_Image_FileName_OP"]
    print(i, image_path)
    image_path = input_dir / image_path
    x_min = df.loc[
        i, "Metadata_Object_ConvertImageToObjects_AreaShape_BoundingBoxMaximum_X"
    ].astype(int)
    x_max = df.loc[
        i, "Metadata_Object_ConvertImageToObjects_AreaShape_BoundingBoxMinimum_X"
    ].astype(int)
    y_min = df.loc[
        i, "Metadata_Object_ConvertImageToObjects_AreaShape_BoundingBoxMaximum_Y"
    ].astype(int)
    y_max = df.loc[
        i, "Metadata_Object_ConvertImageToObjects_AreaShape_BoundingBoxMinimum_Y"
    ].astype(int)
    # read the image
    img = cv2.imread(str(image_path))
    # draw the bounding box
    cv2.rectangle(img, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)
    # show the image
    plt.imshow(img)
    plt.show()
    plt.close()


# In[18]:


identity_list = [
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "both",
    "br",
    "op",
    "br",
    "op",
    "both",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "both",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "br",
    "op",
    "op",
    "br",
    "br",
    "op",
]
df["Metadata_identity"] = identity_list


# In[19]:


df.head()


# In[20]:


# write the df to a parquet file
df.to_parquet(dest_path, index=False)
