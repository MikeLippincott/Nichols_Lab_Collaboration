#!/usr/bin/env python
# coding: utf-8

# # Run CellProfiler `OP_pipe.cppipe` pipeline
#
# In this notebook, we run the CellProfiler analysis pipeline to perform feature extraction to output CSV files.

# ## Import libraries

# In[ ]:


from __future__ import annotations

import pathlib
import sys

sys.path.append("../../utils/")

from cellprofiler_utils import (  # imported from utils and written by Jenna Tomkinson
    run_cellprofiler,
)

# ## Set paths and variables
#

# In[ ]:


# set paths for CellProfiler
path_to_pipeline = pathlib.Path("../pipelines/OP_pipe.cppipe").resolve()

path_to_input = pathlib.Path("../../data/3.maximum_projections_and_masks/").resolve()

path_to_output = pathlib.Path("../../data/4.sqlite_output/").resolve()
# make sure the output directory exists if not create it
path_to_output.mkdir(parents=True, exist_ok=True)


# ## Run CellProfiler analysis pipeline for each cell type
#
# In this notebook, we do not run the full pipelines as we use the python file to complete the whole run.

# In[ ]:


# run analysis pipeline
run_cellprofiler(
    path_to_pipeline=path_to_pipeline,
    path_to_input=path_to_input,
    path_to_output=path_to_output,
    # name each SQLite file name from each CellProfiler pipeline
    sqlite_name="OP_quantification",
    hardcode_sqlite_name="output",
    # make analysis_run True to run an analysis pipeline
    analysis_run=True,
)
