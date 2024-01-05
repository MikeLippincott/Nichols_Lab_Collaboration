#!/bin/bash

echo "Setting up directories..."
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

dir=$(pwd)
echo $dir
cd scripts
python 0.directory_setup.py

echo "Done!"
