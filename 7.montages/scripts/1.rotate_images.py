#!/usr/bin/env python
# coding: utf-8

# In[43]:


import pathlib

import cv2

# In[44]:


# set paths
input_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path.mkdir(exist_ok=True, parents=True)


# In[45]:


files = list(input_path.glob("*.png"))
# for image in files:
#     img = cv2.imread(str(image), cv2.IMREAD_UNCHANGED)
#     # define dimensions of the image
#     x = img.shape[0]
#     y = img.shape[1]
#     # print(x, y, image)
#     if y > x:

#         # resize the image
#         img_rotated = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
#         # save the image and overwrite the original image
#         cv2.imwrite(str(image), img_rotated)

#     else:
#         pass


# images need to be manually rotated or mirrored so that each are in the correct orientation.

# In[46]:


# break the files into 3 lists
# wt unsel and high
wt = [file for file in files if "wt" in file.stem]
unsel = [file for file in files if "unsel" in file.stem]
high = [file for file in files if "high" in file.stem]
# sort the lists
wt.sort()
unsel.sort()
high.sort()


# ## WT rotate

# In[47]:


img = cv2.imread(str(wt[1]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[1]), img)


# In[54]:


img = cv2.imread(str(wt[2]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[2]), img)


# In[53]:


img = cv2.imread(str(wt[3]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[3]), img)


# In[52]:


img = cv2.imread(str(wt[4]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[4]), img)


# In[51]:


img = cv2.imread(str(wt[5]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[5]), img)


# In[42]:


img = cv2.imread(str(wt[6]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[6]), img)


# In[11]:


img = cv2.imread(str(wt[7]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[7]), img)


# In[12]:


img = cv2.imread(str(wt[8]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[8]), img)


# In[13]:


img = cv2.imread(str(wt[9]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[9]), img)


# In[14]:


img = cv2.imread(str(wt[10]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[10]), img)


# In[15]:


img = cv2.imread(str(wt[11]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[11]), img)


# In[16]:


img = cv2.imread(str(wt[12]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[12]), img)


# In[17]:


img = cv2.imread(str(wt[13]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[13]), img)


# In[18]:


img = cv2.imread(str(wt[14]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[14]), img)


# In[19]:


img = cv2.imread(str(wt[15]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[15]), img)


# In[20]:


img = cv2.imread(str(wt[16]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[16]), img)


# In[21]:


img = cv2.imread(str(wt[17]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[17]), img)


# In[22]:


img = cv2.imread(str(wt[18]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[18]), img)


# In[23]:


img = cv2.imread(str(wt[19]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[19]), img)


# In[24]:


img = cv2.imread(str(wt[20]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[20]), img)


# In[25]:


img = cv2.imread(str(wt[21]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[21]), img)


# In[26]:


img = cv2.imread(str(wt[22]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[22]), img)


# In[27]:


img = cv2.imread(str(wt[23]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[23]), img)


# In[28]:


img = cv2.imread(str(wt[24]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[24]), img)


# In[29]:


img = cv2.imread(str(wt[25]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[25]), img)


# In[30]:


img = cv2.imread(str(wt[26]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(wt[26]), img)


# In[31]:


img = cv2.imread(str(wt[27]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[27]), img)


# ## Unselected mutants rotate

# In[ ]:


img = cv2.imread(str(unsel[1]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[1]), img)


# In[ ]:


img = cv2.imread(str(unsel[2]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[2]), img)


# In[ ]:


img = cv2.imread(str(unsel[3]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[3]), img)


# In[ ]:


img = cv2.imread(str(unsel[4]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[4]), img)


# In[ ]:


img = cv2.imread(str(unsel[5]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)\
cv2.imwrite(str(unsel[5]), img)


# In[ ]:


img = cv2.imread(str(unsel[6]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[6]), img)


# In[ ]:


img = cv2.imread(str(unsel[7]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[7]), img)


# In[ ]:


img = cv2.imread(str(unsel[8]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[8]), img)


# In[ ]:


img = cv2.imread(str(unsel[9]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[9]), img)


# In[ ]:


img = cv2.imread(str(unsel[10]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[10]), img)


# In[ ]:


img = cv2.imread(str(unsel[11]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[11]), img)


# In[ ]:


img = cv2.imread(str(unsel[12]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[12]), img)


# In[ ]:


img = cv2.imread(str(unsel[13]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[13]), img)


# In[ ]:


img = cv2.imread(str(unsel[14]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[14]), img)


# In[ ]:


img = cv2.imread(str(unsel[15]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[15]), img)


# In[ ]:


img = cv2.imread(str(unsel[16]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[16]), img)


# In[ ]:


img = cv2.imread(str(unsel[17]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[17]), img)


# In[ ]:


img = cv2.imread(str(unsel[18]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[18]), img)


# In[ ]:


img = cv2.imread(str(unsel[19]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[19]), img)


# In[ ]:


img = cv2.imread(str(unsel[20]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[20]), img)


# In[ ]:


img = cv2.imread(str(unsel[21]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[21]), img)


# In[ ]:


img = cv2.imread(str(unsel[22]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[22]), img)


# In[ ]:


img = cv2.imread(str(unsel[23]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[23]), img)


# In[ ]:


img = cv2.imread(str(unsel[24]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[24]), img)


# In[ ]:


img = cv2.imread(str(unsel[25]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
# img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[25]), img)


# In[ ]:


img = cv2.imread(str(unsel[26]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[26]), img)


# High mutants need to be rotated not in python as the collaborators know better which orientation is correct.
