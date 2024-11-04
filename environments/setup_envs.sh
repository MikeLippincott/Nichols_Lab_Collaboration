#!/bin/bash

# set up environments need for this repository
# get yaml files in directory
yaml_files=$(ls *.yml)

# loop through yaml files
for yaml_file in $yaml_files
do
    # try to create env
    mamba env create -f $yaml_file
    # if env already exists, update it
    if [ $? -ne 0 ]; then
        mamba env update -f $yaml_file
    fi
done
