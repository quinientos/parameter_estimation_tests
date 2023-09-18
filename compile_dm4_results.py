#!/usr/bin/env python3

import os
import sys
import re
import json
import numpy as np
import shlex
import subprocess
import chevron
from scipy.integrate import solve_ivp
from pprint import pprint
#from julia.api import Julia
import csv
import pandas as pd
pd.set_option("display.precision",16)
from utils import *
import argparse

def compile_results(system, instance, csv_writer):
    res_file = "./test_files/amigo2/outputs/{}.csv".format(instance["name"])
    csv_writer.writerow([instance["name"]] + [""]*11)
    df = pd.read_csv(res_file)
    true_vals = ["True Value"]
    test_res = ["Test Result"]
    abs_errs = ["Abs Error"]
    rel_errs = ["Rel Error"]

    for var in system["parameter-variables"]:
        true_val = instance["parameters"][var]
        test_val = float(df[var].iloc[0])
        abs_err = abs(test_val - true_val)

        true_vals.append(true_val)
        test_res.append(test_val)
        abs_errs.append(round(abs_err,5))
        rel_errs.append(round(abs_err/true_val, 5))

    for var in system["state-variables"]:
        true_val = instance["initial"][var]
        test_val = float(df[var].iloc[0])
        abs_err = abs(test_val - true_val)

        true_vals.append(true_val)
        test_res.append(test_val)
        abs_errs.append(round(abs_err,5))
        rel_errs.append(round(abs_err/true_val, 5))

    csv_writer.writerow(true_vals)
    csv_writer.writerow(test_res)
    csv_writer.writerow(abs_errs)
    csv_writer.writerow(rel_errs)
    csv_writer.writerow(["" for i in range(1+len(system["parameter-variables"]) + len(system["state-variables"]))])
 
    return


def main(args): 
    sysargs = getArgs(args)
    systems = load_systems(sysargs["systems-file"])
    instances = load_instances(sysargs["instances-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    system = systems_by_name["daisy-mamil4"]

    with open("dm4_results.csv", "w") as csv_file:
        csvwriter = csv.writer(csv_file)

        #write header
        csvwriter.writerow([""] + system["parameter-variables"] + system["state-variables"])        

        for instance in instances["instances"]:
            compile_results(system, instance, csvwriter)            

    

def getArgs(args):
    datadir = os.path.abspath(args.data)
    if not os.path.exists( datadir ): throwError("invalid directory path")

    instances_file = args.instances
    systems_file = args.systems
    sys_args = {
        "datadir": datadir,
        "instances-file": instances_file,
        "systems-file": systems_file
    }

    return sys_args
    
if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--data', default="./data")
    parser.add_argument('-i', '--instances', default="input_files/instances.json")
    parser.add_argument('-s', '--systems', default="input_files/systems.json")
    parser.add_argument('-o', '--outputs', default="outputs")
    #add other options as they come up
    args = parser.parse_args()
    main(args)


# TODO
# 1. make data gen one big file to avoid initialization
# 2. customize folder locations: 
#     a. data dir pre/suffix
# 3. add in cv generation code in each of the tests
# 4. write bash scripts collecting all the stats
# 5. link to the table generation script
# 6. wrapper script
