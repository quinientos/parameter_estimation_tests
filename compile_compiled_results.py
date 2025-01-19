#!/usr/bin/python
import os
from pathlib import Path
import shutil

os.makedirs("results", exist_ok=True)

prefixes = {
        "." : "0", 
        "../parameter_estimation_tests_1em2" : "1em2",
        "../parameter_estimation_tests_1em4" : "1em4",
        "../parameter_estimation_tests_1em6" : "1em6",
        "../parameter_estimation_tests_1em8" : "1em8"
}

for prefix, codename in prefixes.items():
    for root, dirs, files in os.walk(Path(prefix) / "table_files"):
        for file in files:
            if file.startswith("results"):
                new_file = file.split(".")[0] + f"_{codename}." + file.split(".")[1]
                print(f"Copy from {prefix} file {file} to file {new_file}")
                shutil.copy(Path(root) / file, Path("results") / new_file)

