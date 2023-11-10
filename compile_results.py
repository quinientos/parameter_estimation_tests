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
from tqdm.auto import tqdm
from collections import defaultdict

#PLATFORMS = ["pe", "iqm", "sciml"]
#PLATFORMS = ["pe", "amigo2", "iqm", "sciml"]
PLATFORMS = ["amigo2"]

def parse_output(output, system, platform):
    if platform == "pe":
        pat = r"^(Parameter\(s\) +:|Initial Condition\(s\):)\s*(.+)$"
        lines = re.findall(pat, output, re.MULTILINE)
        total_res = len(lines)
        pairs = []
        for match in lines:
            line_text = match[1]
            key_value_pairs = re.findall(r"([A-Za-z0-9\_]+)[\(t\)]*[ ]*=[ ]*([0-9.e+-]+[ a-zA-Z0-9]*)", line_text)
            tmp_list = []
            for key, value in key_value_pairs:
                if value[-2:]=="im":
                    print("COMPLEX SOLUTION\n")
                    continue
                tmp_list.append((key, value))
            pairs = pairs + tmp_list
    elif platform == "amigo2":
        pairs = re.findall(r"([A-Za-z0-9\_]+)\s+:\s+([0-9.e+-]+)", output)
    elif platform == "iqm":
        pairs = re.findall(r"\n([A-Za-z0-9\_]+)[ ]*=[ ]*([0-9.e+-]+[ a-zA-Z0-9]*)", output)
    elif platform == "sciml":
        res = re.findall(r'\[([\d\s.,e-]+)\]', output)
        # ([A-Za-z0-9\_]+) : ([0-9.e+-]+)
        if res:
            res = re.findall(r'-?\d+\.\d+(?:e-?\d+)?', res[0])
            num_states = len(system["state-variables"])
            pairs = list(zip(system["state-variables"], res[:num_states])) + list(zip(system["parameter-variables"], res[num_states:]))

    return pairs



def rmsre(true_vals, res_vals):
    total = sum([ (abs(true_vals[key] - res_vals[key])/true_vals[key])**2 for key in true_vals.keys() ])
    return (total/len(true_vals))**(0.5)

def compile_results(system, instance, bound, platform, csv_writer):
    res_file = "./test_files/"+ platform + "/outputs/{}.out".format(instance["name"]+"_"+str(bound))

    #pbar.update(1)
    #pbar.set_description(res_file)
    print(instance["name"]+"_"+str(bound))

    df = pd.DataFrame()  # create a dataframe to store the results
    results_dict = defaultdict(list)
    with open(res_file, "r") as f:
        output = f.read()
        res = parse_output(output, system, platform)
        for each in res:
            results_dict[each[0]].append(float(each[1]))
    for key, value in results_dict.items():
        df[key] = value
    
    true_vals = instance["parameters"].copy()
    true_vals.update(instance["initial"])
    if system["name"] == "biohydrogenation":
        true_vals.pop('x7')

    min_err = np.inf
    min_ind = -1
    for index, res_vals in df.iterrows():
        if system["name"] == "biohydrogenation":
            res_vals.pop('x7')
        err = rmsre(true_vals, res_vals)
        if err < min_err:
            min_ind = index
            min_err = err

    total_num_vars = len(system["parameter-variables"]) + len(system["state-variables"])
    csv_writer.writerow([instance["name"]] + [""]*(total_num_vars + 2))

    true_vals = ["True Value"]
    test_res = ["Test Result"]
#    abs_errs = ["Abs Error"]
    rel_errs = ["Rel Error"]

    if min_ind != -1:
        for var in system["parameter-variables"]:
            true_val = instance["parameters"][var]
            test_val = float(df[var].iloc[min_ind])
#            abs_err = abs(test_val - true_val)
    
            true_vals.append(true_val)
            test_res.append(test_val)
#            abs_errs.append(round(abs_err,5))
            rel_errs.append(round(abs(test_val - true_val) /true_val, 5))
    
        for var in system["state-variables"]:
            true_val = instance["initial"][var]
            test_val = float(df[var].iloc[min_ind])
#            abs_err = abs(test_val - true_val)
    
            true_vals.append(true_val)
            test_res.append(test_val)
#            abs_errs.append(round(abs_err,5))
            rel_errs.append(round(abs(test_val - true_val)/true_val, 5))
    
    csv_writer.writerow(true_vals)
    csv_writer.writerow(test_res)
#    csv_writer.writerow(abs_errs)
    csv_writer.writerow(rel_errs + ["", min_err] if min_ind != -1 else [""]*total_num_vars + ["", min_err])
    csv_writer.writerow(["" for i in range(1+len(system["parameter-variables"]) + len(system["state-variables"]))])

    return


def main(args): 
    sysargs = getArgs(args)
    systems = load_systems(sysargs["systems-file"])
    instances = load_instances(sysargs["instances-file"])
    systems_by_name = {}
    instances_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    for instance in instances["instances"]:
        instances_by_name[instance["name"]] = instance

    for system in systems["systems"]:
        print(system["name"])
        for platform in PLATFORMS:
            print(platform)
            with open("table_files/"+system["name"] + "_results_" + platform + ".csv", "w") as csv_file:
                csvwriter = csv.writer(csv_file)
                #write header
                csvwriter.writerow([""] + system["parameter-variables"] + system["state-variables"] + ["", "RMSRE"])        
                for bound in range(1,4):
                    csvwriter.writerow(["Searching in [0.0, {}.0]".format(str(bound))])
                    for i in range(10):
                        instance = instances_by_name[system["name"] + "_" + str(i)]
                        print(instance["name"])
                        compile_results(system, instance, bound, platform, csvwriter)            

    

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
    parser.add_argument('-i', '--instances', default="input_files/all_instances.json")
    parser.add_argument('-s', '--systems', default="input_files/all_systems.json")
    parser.add_argument('-o', '--outputs', default="outputs")
    #add other options as they come up
    args = parser.parse_args()
    main(args)

