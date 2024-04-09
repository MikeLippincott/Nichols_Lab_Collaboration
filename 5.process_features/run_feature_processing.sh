#!/bin/bash

echo "Running feature preprocessing..."

conda activate op_cell_processing_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

python 0.process_objects.py
python 1.preprocessing_EDA.py

cd ../

conda deactivate

echo "Feature extraction complete."
