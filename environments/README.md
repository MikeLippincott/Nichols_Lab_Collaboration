# Environments

This directory contains the environment files for the various environments needs to run the analyses in this repository.


## Environment files
- `Cell_profiling_env.yml`
    - Contains the environment for running the Cell Profiling analysis.
    - Used in modules:
        - 0.pre-process_images
        - 4.extract_features

- `Cell_profiling_processing_env.yml`
    - Contains the environment for running the Cell Profiling processing.
    - Used in modules:
        - 5.process_features
        - 6.analyse_features
        - 7.montages
- `R_env.yml`
- `SAM_env.yml`
    - Contains the environment for running the SAM analysis.
    - Used in modules:
        - 3.segmentation

## Environment creation
To create the environments, run the following command in the terminal:

```bash
cd environments
conda env create -f Cell_profiling_env.yml
conda env create -f Cell_profiling_processing_env.yml
conda env create -f R_env.yml
conda env create -f SAM_env.yml
```
