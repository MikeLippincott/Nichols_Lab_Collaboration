# Processing the feature space

We use both [CytoTable](https://github.com/cytomining/CytoTable) and [pycytominer](https://github.com/cytomining/pycytominer) to process the feature space.
- CytoTable is used to ensure that the CellProfiler output is in the correct format for pycytominer.
- Pycytominer is used to process the feature space by normalizing the data and feature selecting.

## Running the processing script
To run the processing script, execute the following command:
```
source run_feature_processing.sh
```
