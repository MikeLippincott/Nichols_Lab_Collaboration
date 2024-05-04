#!/bin/bash

conda activate op_cell_processing_env

# change dir to the scripts directory
cd notebooks

papermill 0.aggregate_bones.ipynb 0.aggregate_bones.ipynb
papermill 1a.mean_aggregated_drop_manual_defined_blacklisted_features.ipynb 1a.mean_aggregated_drop_manual_defined_blacklisted_features.ipynb
papermill 1b.sum_aggregated_drop_manual_defined_blacklisted_features.ipynb 1b.sum_aggregated_drop_manual_defined_blacklisted_features.ipynb
papermill 1c.custom_aggregated_drop_manual_defined_blacklisted_features.ipynb 1c.custom_aggregated_drop_manual_defined_blacklisted_features.ipynb

# change environment to R environment
conda deactivate
conda activate R_env

papermill 2a.mean_aggregated_eda.ipynb 2a.mean_aggregated_eda.ipynb
papermill 2b.sum_aggregated_eda.ipynb 2b.sum_aggregated_eda.ipynb
papermill 2c.custom_aggregated_eda.ipynb 2c.custom_aggregated_eda.ipynb

# change environment to R environment
conda deactivate
conda activate op_cell_processing_env

papermill 3a.mean_aggregated_anova.ipynb 3a.mean_aggregated_anova.ipynb
papermill 3b.sum_aggregated_anova.ipynb 3b.sum_aggregated_anova.ipynb
papermill 3c.custom_aggregated_anova.ipynb 3c.custom_aggregated_anova.ipynb


# change environment to R environment
conda deactivate
conda activate R_env
papermill 4a.mean_aggregated_plot_features.ipynb 4a.mean_aggregated_plot_features.ipynb
papermill 4b.sum_aggregated_plot_features.ipynb 4b.sum_aggregated_plot_features.ipynb
papermill 4c.custom_aggregated_plot_features.ipynb 4c.custom_aggregated_plot_features.ipynb
papermill 5a.mean_aggregated_anova_visualize.ipynb 5a.mean_aggregated_anova_visualize.ipynb
papermill 5b.sum_aggregated_anova_visualize.ipynb 5b.sum_aggregated_anova_visualize.ipynb
papermill 5c.custom_aggregated_anova_visualize.ipynb 5c.custom_aggregated_anova_visualize.ipynb
papermill 6a.mean_aggregated_variance_analysis_viz.ipynb 6a.mean_aggregated_variance_analysis_viz.ipynb
papermill 6b.sum_aggregated_variance_analysis_viz.ipynb 6b.sum_aggregated_variance_analysis_viz.ipynb
papermill 6c.custom_aggregated_variance_analysis_viz.ipynb 6c.custom_aggregated_variance_analysis_viz.ipynb
papermill 7.object_distance_analysis.ipynb 7.object_distance_analysis.ipynb


# return to the main directory
cd ..

# convert all notebooks to scripts
conda activate op_cell_processing_env
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

# deactivate R environment
conda deactivate

# Complete
echo "Analysis completed"
