#!/bin/bash

# init the env
conda activate op_cell_processing_env

jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

cd scripts

# convert the tiffs to pngs
python 0.convert_tiff_to_png.py

# rotate the images
python 1.rotate_images.py

# add scale bars
python 2.add_scale_bars.py

# change enviroments
conda deactivate
conda activate R_env

# create the montages
Rscript 3.create_montage.r

conda deactivate
cd ../

echo "montages created"
