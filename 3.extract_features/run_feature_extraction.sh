#!/bin/bash

echo "Running segmentation..."

conda activate op_cellprofiler_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

python extract_features.py

cd ../

conda deactivate

echo "Feature extraction complete."
