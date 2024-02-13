#!/bin/bash

echo "Renaming files..."

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

dir=$(pwd)
echo $dir
cd scripts
python change_file_names.py
cd ../

echo "Done!"

# prep the output directory for file type conversion in Fiji
mkdir ../data/0.raw_images_tiff/
