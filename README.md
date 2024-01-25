# Quantifying Zebrafish opercle bone morphology
This repository contains the code for analysis performed by the Way Lab in collaboration with the [Nichols Lab](https://www.nicholslab.org/) at the University of Colorado Anschutz Medical Campus.
The code is organized into folders that correspond to the order in which the analysis was performed.
The README.md file in each folder contains a description of the analysis performed in that folder.
The README.md file also contains instructions for running the code in that folder.


The purpose of this analysis is to determine if there exist a difference in morphological features in the Zebrafish opercle bone and the brachiostegal ray bones.
We are performing this analysis in Zerbrafish with varying penetrance of the gene *mef2c*.

## Environment
Please ensure that both environments are installed on your machine before running the code in this repository.

To do so run the following commands in your terminal:
```bash
conda env create -f Cell_profiling_env.yml
conda env create -f SAM_env.yml
```
