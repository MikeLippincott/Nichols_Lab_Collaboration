#!/bin/bash

echo "Running feature preprocessing..."

conda activate op_cellprofiler_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

python 0.process_objects.py
python 1.preprocess_features.py

cd ../

conda deactivate

echo "Feature extraction complete."
