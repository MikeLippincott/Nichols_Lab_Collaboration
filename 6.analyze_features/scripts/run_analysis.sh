#!/bin/bash

conda activate op_cell_processing_env

jupyter nbconvert --to=script --FilesWriter.build_directory=. ../notebooks/*.ipynb

# run the python scripts
python 00.drop_manual_defined_blacklisted_features.py
python 1.anova.py

# change environment to R environment
conda deactivate
conda activate R_env

# run the R scripts
Rscript 0.eda.r
Rscript 2.anova_visualize.r
Rscript 3.plot_features.r
Rscript 4.variance_analysis_viz.r

# deactivate R environment
# conda deactivate
echo "Analysis completed"
