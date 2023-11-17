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

NUM_TESTS = 10
TIME_INTERVAL = [-0.5, 0.5]
PARAM_INTERVAL = [0.1, 0.9]
NUM_PTS = 21
SCIML_DAT_STR = {
"biohydrogenation": "(sol[1, :]), (sol[2, :])",
"crauste":"(sol[1, :]), (sol[2, :]), (sol[3, :] .+ sol[4, :]), (sol[5, :])",
"daisy_mamil3": "vcat(sol[1, :]), vcat(sol[2, :])",
"daisy_mamil4": "(sol[1, :]), (sol[2, :]), (sol[3, :] + sol[4, :])",
"fitzhugh_nagumo": "sol[1, :]",
"harmonic": "vcat(sol[1, :]), vcat(sol[2, :])",
"hiv": "(sol[4, :]), (sol[5, :]), (sol[1, :]), (sol[2, :] .+ sol[3, :])",
"lotka_volterra": "sol[1, :]",
"seir": "(sol[3, :]), (sol[4, :])",
"vanderpol": "(sol[1, :]), (sol[2, :])"
}

def generate_data(instance, settings):
    outfile_name = "data_gen.jl"
    header = 'push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")\n using ModelingToolkit, DifferentialEquations, Plots\n using ParameterEstimation\n using JLD2, FileIO\n solver = Tsit5()\n\n'
    with open('julia_files/' + outfile_name, 'w') as output_file:
        output_file.write(header)

    with open('julia_files/' + outfile_name, 'a') as output_file:
        for instance in instances["instances"]:
            system = systems_by_name[instance["system-name"]]
            settings = get_settings(system, instance)
            dat_gen_str = chevron.render(open('templates/julia_sample_noheader.jl.template'), settings) 
            output_file.write(dat_gen_str + "\n\n")


    ## run julia code here
    ##cmd = ['julia', 'julia_files/' + instance["name"], '>', 'dat_files/' + re.sub('.jl$', '.dat', instance["name"])]
    cmd_str = 'julia julia_files/' + outfile_name 
    cmd = shlex.split(cmd_str)
    output = subprocess.check_output(cmd)
    return

def generate_pe_test(outfilename, settings):
    with open('test_files/pe/' + outfilename + '.jl', 'w') as output_file:
        settings["at_time"] = (TIME_INTERVAL[1] - TIME_INTERVAL[0])/2 + TIME_INTERVAL[0]
        testfile = chevron.render(open('templates/pe.jl.template'), settings)
        output_file.write(testfile)

def generate_amigo2_test(outfilename, system, settings):
    with open('test_files/amigo2/' + outfilename + '.m', 'w') as output_file:
        if system["name"] == "daisy-mamil4":
            testfile = chevron.render(open('templates/amigo2_daisy_mamil4.m.template'), settings)
        elif system["name"] == "biohydrogenation":
            testfile = chevron.render(open('templates/amigo2_biohydrogenation.m.template'), settings)
        elif system["name"] == "seir":
            testfile = chevron.render(open('templates/amigo2_seir.m.template'), settings)
        else:
            testfile = chevron.render(open('templates/amigo2.m.template'), settings)
        output_file.write(testfile)

def generate_iqm_test(outfilename, system, settings):
    os.makedirs(os.path.dirname('./test_files/iqm/' + outfilename), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/' + outfilename + '/' + outfilename), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/' + outfilename + '/project/experiments/data/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/' + outfilename + '/project/models/'), exist_ok=True)
    with open('test_files/iqm/' + outfilename + '/' + outfilename + '.m', 'w') as output_file:
        if system["name"] == "daisy-mamil4":
            testfile = chevron.render(open('templates/iqm_daisy_mamil4.m.template'), settings)
        elif system["name"] == "biohydrogenation":
            testfile = chevron.render(open('templates/iqm_biohydrogenation.m.template'), settings)
        elif system["name"] == "seir":
            testfile = chevron.render(open('templates/iqm_seir.m.template'), settings)
        else:
            testfile = chevron.render(open('templates/iqm.m.template'), settings)
        output_file.write(testfile)
    with open('test_files/iqm/' + outfilename + '/project/experiments/data/experiment.csv', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_experiment.csv.template'), settings)
       output_file.write(testfile)
    with open('test_files/iqm/' + outfilename + '/project/experiments/data/experiment.exp', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_experiment.exp.template'), settings)
       output_file.write(testfile)
    with open('test_files/iqm/' + outfilename + '/project/models/models.txt', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_model.txt.template'), settings)
       output_file.write(testfile)
    #settings.pop("data")

def generate_sciml_test(outfilename, settings):
    with open('test_files/sciml/' + outfilename + '.jl', 'w') as output_file:
        testfile = chevron.render(open('templates/sciml.jl.template'), settings)
        output_file.write(testfile)

def main(args):
    sargs = getArgs(args)
    systems = load_systems(sargs["systems-file"])
    instances = load_instances(sargs["instances-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system

    os.makedirs(os.path.dirname('./test_files/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/pe/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/amigo2/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/sciml/'), exist_ok=True)

    for instance in instances["instances"]:
        print(instance["name"])
        system = systems_by_name[instance["system-name"]]

        settings = get_settings(system, instance)
        settings.update(sargs)

#        generate_data(instance, settings)

        for bounds in [[0.0, 1.0], [0.0, 2.0], [0.0, 3.0]]:
            outfilename = instance["name"] + "_" + str(int(bounds[1]))
            settings["lower_bound"] = bounds[0]
            settings["upper_bound"] = bounds[1]

#            generate_pe_test(outfilename, settings)
#
            df = pd.read_csv(settings["datadir"] + '/csv/' + instance["name"] + '.csv', header=None, index_col=False)
#
            settings["data"] = df[list(range(1, settings["num_measurements"]+1))].to_string(index=False, header=False, index_names=False)
            generate_amigo2_test(outfilename, system, settings)
#
#            settings["data"] = df.to_csv(index=False, header=False)
#            generate_iqm_test(outfilename, system, settings)

#            settings["data_expr"] = SCIML_DAT_STR[instance["system-name"]]
#            generate_sciml_test(outfilename, settings)        

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
    #add other options as they come up
    args = parser.parse_args()
    main(args)


