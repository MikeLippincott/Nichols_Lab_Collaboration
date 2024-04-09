#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pathlib

import cv2

# In[2]:


# set paths
input_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path = pathlib.Path("../../data/7.montage_images/individual_images/")
output_path.mkdir(exist_ok=True, parents=True)


# images need to be manually rotated or mirrored so that each are in the correct orientation.

# In[3]:


files = sorted(input_path.glob("*.png"))


# In[4]:


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

# In[5]:


img = cv2.imread(str(wt[1]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[1]), img)


# In[6]:


img = cv2.imread(str(wt[2]), cv2.IMREAD_UNCHANGED)
# mirror image
cv2.imwrite(str(wt[2]), img)


# In[7]:


img = cv2.imread(str(wt[3]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[3]), img)


# In[8]:


img = cv2.imread(str(wt[4]), cv2.IMREAD_UNCHANGED)
cv2.imwrite(str(wt[4]), img)


# In[9]:


img = cv2.imread(str(wt[5]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[5]), img)


# In[10]:


img = cv2.imread(str(wt[6]), cv2.IMREAD_UNCHANGED)
cv2.imwrite(str(wt[6]), img)


# In[11]:


img = cv2.imread(str(wt[7]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[7]), img)


# In[12]:


img = cv2.imread(str(wt[8]), cv2.IMREAD_UNCHANGED)
cv2.imwrite(str(wt[8]), img)


# In[13]:


img = cv2.imread(str(wt[9]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[9]), img)


# In[14]:


img = cv2.imread(str(wt[10]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
cv2.imwrite(str(wt[10]), img)


# In[15]:


img = cv2.imread(str(wt[11]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[11]), img)


# In[16]:


img = cv2.imread(str(wt[12]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(wt[12]), img)


# In[17]:


img = cv2.imread(str(wt[13]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[13]), img)


# In[18]:


img = cv2.imread(str(wt[14]), cv2.IMREAD_UNCHANGED)

cv2.imwrite(str(wt[14]), img)


# In[19]:


img = cv2.imread(str(wt[15]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[15]), img)


# In[20]:


img = cv2.imread(str(wt[16]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(wt[16]), img)


# In[21]:


img = cv2.imread(str(wt[17]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[17]), img)


# In[22]:


img = cv2.imread(str(wt[18]), cv2.IMREAD_UNCHANGED)

cv2.imwrite(str(wt[18]), img)


# In[23]:


img = cv2.imread(str(wt[19]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[19]), img)


# In[24]:


img = cv2.imread(str(wt[20]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(wt[20]), img)


# In[25]:


img = cv2.imread(str(wt[21]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(wt[21]), img)


# In[26]:


img = cv2.imread(str(wt[22]), cv2.IMREAD_UNCHANGED)
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

cv2.imwrite(str(wt[24]), img)


# In[29]:


img = cv2.imread(str(wt[25]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[25]), img)


# In[30]:


img = cv2.imread(str(wt[26]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

# mirror image
cv2.imwrite(str(wt[26]), img)


# In[31]:


img = cv2.imread(str(wt[27]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(wt[27]), img)


# ## Unselected mutants rotate

# In[32]:


img = cv2.imread(str(unsel[0]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[0]), img)


# In[33]:


img = cv2.imread(str(unsel[1]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[1]), img)


# In[34]:


img = cv2.imread(str(unsel[2]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
cv2.imwrite(str(unsel[2]), img)
# view the image


# In[35]:


img = cv2.imread(str(unsel[3]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

# mirror image
cv2.imwrite(str(unsel[3]), img)


# In[36]:


img = cv2.imread(str(unsel[4]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[4]), img)


# In[37]:


img = cv2.imread(str(unsel[5]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# mirror image
cv2.imwrite(str(unsel[5]), img)


# In[38]:


img = cv2.imread(str(unsel[6]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[6]), img)


# In[39]:


img = cv2.imread(str(unsel[7]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[7]), img)


# In[40]:


img = cv2.imread(str(unsel[8]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[8]), img)


# In[41]:


img = cv2.imread(str(unsel[9]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[9]), img)


# In[42]:


img = cv2.imread(str(unsel[10]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)

img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[10]), img)


# In[43]:


img = cv2.imread(str(unsel[11]), cv2.IMREAD_UNCHANGED)

cv2.imwrite(str(unsel[11]), img)


# In[44]:


img = cv2.imread(str(unsel[12]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[12]), img)


# In[45]:


img = cv2.imread(str(unsel[13]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[13]), img)


# In[46]:


img = cv2.imread(str(unsel[14]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[14]), img)


# In[47]:


img = cv2.imread(str(unsel[15]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
cv2.imwrite(str(unsel[15]), img)


# In[48]:


img = cv2.imread(str(unsel[16]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[16]), img)


# In[49]:


img = cv2.imread(str(unsel[17]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[17]), img)


# In[50]:


img = cv2.imread(str(unsel[18]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)

cv2.imwrite(str(unsel[18]), img)


# In[51]:


img = cv2.imread(str(unsel[19]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

cv2.imwrite(str(unsel[19]), img)


# In[52]:


img = cv2.imread(str(unsel[20]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)

cv2.imwrite(str(unsel[20]), img)


# In[53]:


img = cv2.imread(str(unsel[21]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
# mirror image
cv2.imwrite(str(unsel[21]), img)


# In[54]:


img = cv2.imread(str(unsel[22]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)

img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[22]), img)


# In[55]:


img = cv2.imread(str(unsel[23]), cv2.IMREAD_UNCHANGED)

cv2.imwrite(str(unsel[23]), img)


# In[56]:


img = cv2.imread(str(unsel[24]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[24]), img)


# In[57]:


img = cv2.imread(str(unsel[25]), cv2.IMREAD_UNCHANGED)

cv2.imwrite(str(unsel[25]), img)


# In[58]:


img = cv2.imread(str(unsel[26]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(unsel[26]), img)


#  ## High penetrance mutants rotate

# In[59]:


img = cv2.imread(str(high[0]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[0]), img)


# In[60]:


img = cv2.imread(str(high[1]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[1]), img)


# In[61]:


img = cv2.imread(str(high[2]), cv2.IMREAD_UNCHANGED)
# img = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
# img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[2]), img)


# In[62]:


img = cv2.imread(str(high[3]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[3]), img)


# In[63]:


img = cv2.imread(str(high[4]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[4]), img)


# In[64]:


img = cv2.imread(str(high[5]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[5]), img)

img = cv2.imread(str(high[6]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[6]), img)

img = cv2.imread(str(high[7]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[7]), img)

img = cv2.imread(str(high[8]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[8]), img)

img = cv2.imread(str(high[9]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[9]), img)

img = cv2.imread(str(high[10]), cv2.IMREAD_UNCHANGED)

img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[10]), img)

img = cv2.imread(str(high[11]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[11]), img)

img = cv2.imread(str(high[12]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[12]), img)

img = cv2.imread(str(high[13]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[13]), img)

img = cv2.imread(str(high[14]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[14]), img)

img = cv2.imread(str(high[15]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[15]), img)

img = cv2.imread(str(high[16]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[16]), img)

img = cv2.imread(str(high[17]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[17]), img)

img = cv2.imread(str(high[18]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[18]), img)

img = cv2.imread(str(high[19]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[19]), img)

img = cv2.imread(str(high[20]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[20]), img)

img = cv2.imread(str(high[21]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)


cv2.imwrite(str(high[21]), img)
img = cv2.imread(str(high[22]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[22]), img)

img = cv2.imread(str(high[23]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[23]), img)

img = cv2.imread(str(high[24]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[24]), img)

img = cv2.imread(str(high[25]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[25]), img)

img = cv2.imread(str(high[26]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[26]), img)

img = cv2.imread(str(high[27]), cv2.IMREAD_UNCHANGED)
img = cv2.rotate(img, cv2.ROTATE_180)
# mirror image
img = cv2.flip(img, 1)
cv2.imwrite(str(high[27]), img)
