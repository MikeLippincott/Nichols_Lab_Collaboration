#!/bin/bash

echo "Running feature extraction..."

conda activate op_cellprofiler_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

python 0.extract_features.py

cd ../

conda deactivate

echo "Feature extraction complete."
