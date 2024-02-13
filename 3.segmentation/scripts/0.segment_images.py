#!/usr/bin/env python
# coding: utf-8

# Generate masks for each object in each image.

# In[1]:


import pathlib

import cv2
import numpy as np

# from segment_anything import SamPredictor
import supervision as sv
import supervision.draw.color as sv_color
import torch
from segment_anything import SamAutomaticMaskGenerator, sam_model_registry
from skimage import io
from tqdm import tqdm

# In[2]:


# install the model
# #download the model if it doesn't exist
if not pathlib.Path("../../data/models/sam_vit_h_4b8939.pth").exists():
    get_ipython().system(
        "wget -q 'https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth'"
    )
    # move the model to the right place
    model_path = pathlib.Path("sam_vit_h_4b8939.pth").resolve(strict=True)
    model_new_path = pathlib.Path("../../data/models/sam_vit_h_4b8939.pth")
    # move the model
    model_new_path.parent.mkdir(parents=True, exist_ok=True)
    model_path.rename(model_new_path)
else:
    print("model exists")


# ## Define Paths

# In[3]:


# import image_path
image_path = pathlib.Path("../../data/0.raw_images/")
# max_projection paths
max_projection_path = pathlib.Path("../../data/3.maximum_projections_and_masks/")
# output mask path
mask_path = pathlib.Path("../../data/3.maximum_projections_and_masks")
# models path
models_path = pathlib.Path("../../data/models/")

# create directories if they don't exist
max_projection_path.mkdir(parents=True, exist_ok=True)
mask_path.mkdir(parents=True, exist_ok=True)
models_path.mkdir(parents=True, exist_ok=True)


# In[4]:


# Generate a list of all the images in the image_path directory of max projection images
image_list = list(max_projection_path.glob("*.tiff"))
image_list


# ## Load in the SAM model

# In[5]:


DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(DEVICE)


MODEL_TYPE = "vit_h"
CHECKPOINT_PATH = "../../data/models/sam_vit_h_4b8939.pth"
sam = sam_model_registry[MODEL_TYPE](checkpoint=CHECKPOINT_PATH).to(device=DEVICE)
mask_generator = SamAutomaticMaskGenerator(sam)


# ## Loop over the files and segment masks

# In[6]:


for image_path in tqdm(image_list):
    image_path = str(image_path)
    # read the image
    image = cv2.imread(image_path)
    # define the file basename
    image_path = pathlib.Path(image_path)
    file_basename = image_path.stem
    # convert the image to RGB format
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    # convert to unit8 format
    image = (image * 255).astype(np.uint8)
    # invert the image
    image = cv2.bitwise_not(image)
    # # segment the image
    masks = mask_generator.generate(image)

    # Sort the masks by area
    masks = sorted(masks, key=(lambda x: x["area"]), reverse=True)
    # remove the background mask
    # a background mask is created by default hence the segment everything model
    masks = masks[1:]

    # annotate the masks
    mask_annotator = sv.MaskAnnotator(
        color=sv_color.Color(r=255, g=0, b=255), color_lookup=sv.ColorLookup.INDEX
    )
    # detect the masks
    detections = sv.Detections.from_sam(sam_result=masks)

    # annotate the image
    annotated_image = mask_annotator.annotate(scene=image.copy(), detections=detections)

    # Convert to uint8 format for conversion to grayscale
    mask_image = (annotated_image * 255).astype(np.uint8)
    # convert image to grayscale
    gray = cv2.cvtColor(mask_image, cv2.COLOR_BGR2GRAY)
    # threshold the image to create a binary mask image
    gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
    # invert the image such that the background is black and the signal are white
    gray = cv2.bitwise_not(gray)
    # write the image to mask with basename
    outpath = str(pathlib.Path(mask_path, file_basename + ".png"))
    cv2.imwrite(outpath, gray)
