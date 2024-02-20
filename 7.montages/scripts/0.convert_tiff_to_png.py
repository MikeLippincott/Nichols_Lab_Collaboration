#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import cv2

# In[2]:


# set paths
input_path = pathlib.Path("../../data/3.maximum_projections_and_masks/")
output_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path.mkdir(exist_ok=True, parents=True)


# In[ ]:


files = list(input_path.glob("*.tiff"))
for image in files:
    img = cv2.imread(str(image), cv2.IMREAD_UNCHANGED)
    # change the contrast
    img = cv2.convertScaleAbs(img, alpha=0.025, beta=1)
    # save the image as png
    cv2.imwrite(str(output_path / image.name.replace(".tiff", ".png")), img)
