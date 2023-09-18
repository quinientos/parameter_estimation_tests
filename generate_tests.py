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
#import csv
import pandas as pd
pd.set_option("display.precision",16)
import argparse
from utils import *


def main(args): 
    sysargs = getArgs(args)
    systems = load_systems(sysargs["systems-file"])
    instances = load_instances(sysargs["instances-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    #os.makedirs(os.path.dirname('./test_files/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/pe/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/amigo2/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/sciml/'), exist_ok=True)
    
    for instance in instances["instances"]:
        system = systems_by_name[instance["system-name"]]
        settings = get_settings(system, instance)
        settings.update(sysargs)

#        #df = pd.read_csv('./data/csv/' + instance["name"] + '.csv', header=None, index_col=False)
        df = pd.read_csv(settings["datadir"] + '/csv/' + instance["name"] + '.csv', header=None, index_col=False)
#        with open('test_files/pe/' + instance["name"] + '.jl', 'w') as output_file:
#            testfile = chevron.render(open('templates/pe.jl.template'), settings)
#            output_file.write(testfile)
    
        settings["data"] = df[list(range(1, settings["num_measurements"]+1))].to_string(index=False, header=False, index_names=False)#.replace("  ", ", ")
        with open('test_files/amigo2/' + instance["name"] + '.m', 'w') as output_file:
            if system["name"] == "daisy-mamil4":
                testfile = chevron.render(open('templates/amigo2_daisy_mamil4.m.template'), settings)
            else:
                testfile = chevron.render(open('templates/amigo2.m.template'), settings)
            output_file.write(testfile)
        #settings.pop("data")
    
#        #os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"]), exist_ok=True)
#        #os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/' + instance["name"]), exist_ok=True)
#        os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/project/experiments/'), exist_ok=True)
#        os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/project/models/'), exist_ok=True)
#        settings["data"] = df.to_csv(index=False, header=False)
#        with open('test_files/iqm/' + instance["name"] + '/' + instance["name"] + '.m', 'w') as output_file:
#           testfile = chevron.render(open('templates/iqm.m.template'), settings)
#           output_file.write(testfile)
#        with open('test_files/iqm/' + instance["name"] + '/project/experiments/experiment.csv', 'w') as output_file:
#           testfile = chevron.render(open('templates/iqm_experiment.csv.template'), settings)
#           output_file.write(testfile)
#        with open('test_files/iqm/' + instance["name"] + '/project/experiments/experiment.exp', 'w') as output_file:
#           testfile = chevron.render(open('templates/iqm_experiment.exp.template'), settings)
#           output_file.write(testfile)
#        with open('test_files/iqm/' + instance["name"] + '/project/models/models.txt', 'w') as output_file:
#           testfile = chevron.render(open('templates/iqm_model.txt.template'), settings)
#           output_file.write(testfile)
#        #settings.pop("data")
#    
#        with open('test_files/sciml/' + instance["name"] + '.jl', 'w') as output_file:
#            testfile = chevron.render(open('templates/sciml.jl.template'), settings)
#            output_file.write(testfile)
    

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
    parser.add_argument('-i', '--instances', default="instances.json")
    parser.add_argument('-s', '--systems', default="systems.json")
    parser.add_argument('-pf', '--prefix', default=None)
    parser.add_argument('-sf', '--suffix', default=None)
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
