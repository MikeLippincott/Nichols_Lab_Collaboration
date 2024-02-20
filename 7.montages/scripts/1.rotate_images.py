#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import cv2

# In[ ]:


# set paths
input_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path.mkdir(exist_ok=True, parents=True)


# In[ ]:


files = list(input_path.glob("*.png"))
for image in files:
    img = cv2.imread(str(image), cv2.IMREAD_UNCHANGED)
    # define dimensions of the image
    x = img.shape[0]
    y = img.shape[1]
    # print(x, y, image)
    if y > x:

        # resize the image
        img_rotated = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
        # save the image and overwrite the original image
        cv2.imwrite(str(image), img_rotated)

    else:
        pass
