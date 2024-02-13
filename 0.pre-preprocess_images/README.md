# Image pre-processing
This folder contains the scripts used to pre-process the images.

## 1. Pre-processing
The pre-processing is done in two steps:
1. Rename files
2. Convert `.ims` to `.tiff`

### 1.1. Rename files
To rename the files to remove the spaces and the special characters, run the following command from the repository root folder:

```bash
# Go to the folder containing the scripts
cd 0.pre-preprocess_images

# Run the script
source rename_files.sh
```

### 1.2. Convert `.ims` to `.tiff`
To convert the `.ims` files to `.tiff` use the FIJI script `file_type_convert.ijm`.
To run the script, open FIJI and drag and drop the script into the FIJI window.
Then, select the folder containing the `.ims` files.
In this repository, the `.ims` files are located in `data/00.raw_images_ims/`.
Then, select the output folder.
In this repository, the output folder is `data/0.raw_images_tiff/`.
Click `OK` and wait for the conversion to finish.

Ensure that the `Open all series` option is selected in the `Bio-Formats Import Options` window.
This is sub-optimal and will open for each `.ims` file all the series.
Human intervention is required to close the windows...
