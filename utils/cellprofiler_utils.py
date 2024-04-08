import os
import pathlib
import subprocess
from typing import Optional


def run_cellprofiler(
    path_to_pipeline: str,
    path_to_input: str,
    path_to_output: str,
    sqlite_name: Optional[str] = None,
    hardcode_sqlite_name: Optional[str] = None,
    analysis_run: Optional[bool] = False,
    rename_sqlite_file: Optional[bool] = False,
):
    """
    Written by Jenna Tomkinson
    Grabbed from the NF1 repo: https://github.com/WayScience/nf1_cellpainting_data/blob/main/utils/cp_parallel.py
    Run CellProfiler on data using LoadData CSV. It can be used for both a illumination correction pipeline and analysis pipeline.

    Args:
        path_to_pipeline (str):
            path to the CellProfiler .cppipe file with the segmentation and feature measurement modules
        path_to_input (str):
            path to the input folder with the images to be analyzed
        path_to_output (str):
            path to the output folder (the directory will be created if it doesn't already exist)
        sqlite_name (str, optional):
            string with name for SQLite file for an analysis pipeline to either be renamed and/or to check to see if the
            run has already happened (default is None)
        analysis_run (bool, optional):
            will run an analysis pipeline and can rename sqlite files if using one pipeline for multiple datasets (default is False)
        rename_sqlite_file (bool, optional):
            will rename the outputted SQLite file from the CellProfiler pipeline and rename it when using one
            pipeline for multiple datasets. If kept as default, the SQLite file will not be renamed and the sqlite_name is used to
            find if the analysis pipeline has already been ran (default is False)
    """
    # check to make sure the paths to files are correct and they exists before running CellProfiler
    if not pathlib.Path.exists(path_to_pipeline):
        raise FileNotFoundError(f"Directory '{path_to_pipeline}' does not exist")

    # make logs directory
    log_dir = pathlib.Path("./logs")
    os.makedirs(log_dir, exist_ok=True)

    if not analysis_run:

        # a log file is created for each plate or data set name that holds all outputs and errors
        with open(
            pathlib.Path(f"logs/cellprofiler_output.log"),
            "w",
        ) as cellprofiler_output_file:
            # run CellProfiler pipeline
            command = [
                "cellprofiler",
                "-c",
                "-r",
                "-p",
                path_to_pipeline,
                "-i",
                path_to_input,
                "-o",
                path_to_output,
            ]
            subprocess.run(
                command,
                stdout=cellprofiler_output_file,
                stderr=cellprofiler_output_file,
                check=True,
            )
            print(
                f"The CellProfiler run has been completed with log. Please check log file for any errors."
            )

    if analysis_run:
        # runs through any files that are in the output path and checks to see if analysis pipeline was already run
        if any(
            files.name.startswith(sqlite_name)
            for files in pathlib.Path(path_to_output).iterdir()
        ):
            raise NameError(
                f"The file {sqlite_name}.sqlite has already been renamed! This means it was probably already analyzed."
            )

        # a log file is created for each plate or data set name that holds all outputs and errors
        with open(
            pathlib.Path(f"logs/cellprofiler_output.log"),
            "w",
        ) as cellprofiler_output_file:
            # run CellProfiler for an analysis run
            command = [
                "cellprofiler",
                "-c",
                "-r",
                "-p",
                path_to_pipeline,
                "-i",
                path_to_input,
                "-o",
                path_to_output,
            ]
            subprocess.run(
                command,
                stdout=cellprofiler_output_file,
                stderr=cellprofiler_output_file,
                check=True,
            )
