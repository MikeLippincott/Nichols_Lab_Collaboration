#!/bin/bash

echo "Running feature preprocessing..."

conda activate op_cell_processing_env


cd notebooks

papermill 0.process_objects.ipynb 0.process_objects.ipynb
papermill 1.preprocessing_EDA.ipynb 1.preprocessing_EDA.ipynb

cd ../

# convert all notebooks to scripts
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

conda deactivate

echo "Feature extraction complete."
