#!/bin/bash

echo "Running segmentation..."

conda activate op_sam_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

python scripts/0.segment_images.py

cd ../

conda deactivate

echo "Segmentation complete."
