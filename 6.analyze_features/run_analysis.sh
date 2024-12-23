#!/bin/bash

# change dir to the scripts directory
cd notebooks || exit

# activate env to run the analysis
conda activate op_cell_processing_env
papermill 0.aggregate_bones.ipynb 0.aggregate_bones.ipynb
papermill 1a.mean_aggregated_drop_manual_defined_blacklisted_features.ipynb 1a.mean_aggregated_drop_manual_defined_blacklisted_features.ipynb
papermill 1b.sum_aggregated_drop_manual_defined_blacklisted_features.ipynb 1b.sum_aggregated_drop_manual_defined_blacklisted_features.ipynb
papermill 1c.custom_aggregated_drop_manual_defined_blacklisted_features.ipynb 1c.custom_aggregated_drop_manual_defined_blacklisted_features.ipynb
papermill 1d.non_aggregated_drop_manual_defined_blacklisted_features.ipynb 1d.non_aggregated_drop_manual_defined_blacklisted_features.ipynb

# change environment to R environment
conda deactivate
conda activate R_env

papermill 2a.mean_aggregated_eda.ipynb 2a.mean_aggregated_eda.ipynb
papermill 2b.sum_aggregated_eda.ipynb 2b.sum_aggregated_eda.ipynb
papermill 2c.custom_aggregated_eda.ipynb 2c.custom_aggregated_eda.ipynb
papermill 2d.non_aggregated_eda.ipynb 2d.non_aggregated_eda.ipynb

# change environment to op_cell_processing_env environment
conda deactivate
conda activate op_cell_processing_env

papermill 3a.mean_aggregated_anova.ipynb 3a.mean_aggregated_anova.ipynb
papermill 3b.sum_aggregated_anova.ipynb 3b.sum_aggregated_anova.ipynb
papermill 3c.custom_aggregated_anova.ipynb 3c.custom_aggregated_anova.ipynb
papermill 3d.non_aggregated_anova.ipynb 3d.non_aggregated_anova.ipynb

# change environment to R environment
conda deactivate
conda activate R_env
papermill 4a.mean_aggregated_plot_features.ipynb 4a.mean_aggregated_plot_features.ipynb
papermill 4b.sum_aggregated_plot_features.ipynb 4b.sum_aggregated_plot_features.ipynb
papermill 4c.custom_aggregated_plot_features.ipynb 4c.custom_aggregated_plot_features.ipynb
papermill 4d.non_aggregated_plot_features.ipynb 4d.non_aggregated_plot_features.ipynb
papermill 5a.mean_aggregated_anova_visualize.ipynb 5a.mean_aggregated_anova_visualize.ipynb
papermill 5b.sum_aggregated_anova_visualize.ipynb 5b.sum_aggregated_anova_visualize.ipynb
papermill 5c.custom_aggregated_anova_visualize.ipynb 5c.custom_aggregated_anova_visualize.ipynb
papermill 5d.non_aggregated_anova_visualize.ipynb 5d.non_aggregated_anova_visualize.ipynb
papermill 6.object_distance_analysis.ipynb 6.object_distance_analysis.ipynb

# change environment to op_cell_processing_env environment
# conda deactivate
conda activate op_cell_processing_env
# run the mahalanobis distance analysis
papermill 8a.mean_aggregated_PCA_calculate_mahalanobis_distance.ipynb 8a.mean_aggregated_PCA_calculate_mahalanobis_distance.ipynb
papermill 8b.sum_aggregated_PCA_calculate_mahalanobis_distance.ipynb 8b.sum_aggregated_PCA_calculate_mahalanobis_distance.ipynb
papermill 8c.custom_aggregated_PCA_calculate_mahalanobis_distance.ipynb 8c.custom_aggregated_PCA_calculate_mahalanobis_distance.ipynb
papermill 8d.non_aggregated_PCA_calculate_mahalanobis_distance.ipynb 8d.non_aggregated_PCA_calculate_mahalanobis_distance.ipynb

papermill 9a.mean_aggregated_direct_hypothesis_test.ipynb 9a.mean_aggregated_direct_hypothesis_test.ipynb
papermill 9b.sum_aggregated_direct_hypothesis_test.ipynb 9b.sum_aggregated_direct_hypothesis_test.ipynb
papermill 9c.custom_aggregated_direct_hypothesis_test.ipynb 9c.custom_aggregated_direct_hypothesis_test.ipynb
papermill 9d.non_aggregated_direct_hypothesis_test.ipynb 9d.non_aggregated_direct_hypothesis_test.ipynb

papermill 10a.mean_aggregated_direct_hypothesis_viz.ipynb 10a.mean_aggregated_direct_hypothesis_viz.ipynb
papermill 10b.sum_aggregated_direct_hypothesis_viz.ipynb 10b.sum_aggregated_direct_hypothesis_viz.ipynb
papermill 10c.custom_aggregated_direct_hypothesis_viz.ipynb 10c.custom_aggregated_direct_hypothesis_viz.ipynb
papermill 10d.non_aggregated_direct_hypothesis_viz.ipynb 10d.non_aggregated_direct_hypothesis_viz.ipynb

papermill 11a.mean_aggregated_variance_table_generation.ipynb 11a.mean_aggregated_variance_table_generation.ipynb
papermill 11b.sum_aggregated_variance_table_generation.ipynb 11b.sum_aggregated_variance_table_generation.ipynb
papermill 11c.custom_aggregated_variance_table_generation.ipynb 11c.custom_aggregated_variance_table_generation.ipynb
papermill 11d.non_aggregated_variance_table_generation.ipynb 11d.non_aggregated_variance_table_generation.ipynb

# return to the main directory
cd .. || exit

# convert all notebooks to scripts
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts notebooks/*.ipynb

# deactivate R environment
conda deactivate

# Complete
echo "Analysis completed"
