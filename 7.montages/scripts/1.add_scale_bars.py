#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import cv2
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import tifffile as tf  # write tiff files
from PIL import Image  # read tiff files
from toml import load
from tqdm import tqdm  # progress bar

# In[2]:


path = pathlib.Path("../../data/7.montage_images/individual_images/").resolve()
# get the list of all the files in the directory
files = list(path.glob("*.png"))


# In[3]:


for image_path in files:
    image_path = str(image_path)
    print(image_path)
    # open the image
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    # image to array
    image_array = np.array(image)
    resolution = 1.6585  # pixels per micrometer
    # get the image size
    image_size = image_array.shape
    scale_bar_length = 50  # in micrometers
    scale_bar_height = 10  # in pixels
    padding = 10  # in pixels
    # get the bottom right most corner based on scale 1 % of pixels
    scale_bar_x = image_size[1] - (scale_bar_length / resolution) - padding - padding
    scale_bar_y = image_size[0] - (scale_bar_height) - padding
    print(scale_bar_x, scale_bar_y)
    # draw the scale bar
    new = cv2.rectangle(
        image_array,
        (int(scale_bar_x), int(scale_bar_y)),
        (image_size[1] - padding, image_size[0] - padding),
        (255, 255, 255),
        -1,
    )
    # show the image
    # plt.imshow(new)
    # plt.show()
    # save the image with the scale bar via cv2
    cv2.imwrite(image_path, new)
