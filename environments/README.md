# Environments

This directory contains the environment files for the various environments needs to run the analyses in this repository.


## Environment files
- `Cell_profiling_env.yml`
- `Cell_profiling_processing_env.yml`
- `R_env.yml`
- `SAM_env.yml`

## Environment creation
To create the environments, run the following command in the terminal:

```bash
cd environments
conda env create -f Cell_profiling_env.yml
conda env create -f Cell_profiling_processing_env.yml
conda env create -f R_env.yml
conda env create -f SAM_env.yml
```
