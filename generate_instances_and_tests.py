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
TEST_INTERVAL = [0.0, 1.0]
NUM_PTS = 21
SCIML_DAT_STR = {
"biohydrogenation": "(sol[1, :]), (sol[2, :])",
"crauste":"(sol[1, :]), (sol[2, :]), (sol[3, :] .+ sol[4, :]), (sol[5, :])",
"daisy_mamil3": "vcat(sol[1, :]), vcat(sol[2, :])",
"daisy_mamil4": "(sol[1, :]), (sol[2, :]), (sol[3, :] + sol[4, :])]",
"harmonic": "vcat(sol[1, :]), vcat(sol[2, :])",
"hiv": "(sol[4, :]), (sol[5, :]), (sol[1, :]), (sol[2, :] .+ sol[3, :])",
"lotka_volterra": "sol[1, :]",
"seir": "(sol[3, :]), (sol[4, :])",
"vanderpol": "(sol[1, :]), (sol[2, :])"
}

def generate_instance(system, instance_name, param_vals, initial_vals):
    state_variables = system["state-variables"]
    states = {}
    for i, varname in enumerate(state_variables):
        states.update({
            varname: initial_vals[i]
        })
    parameter_variables = system["parameter-variables"]
    parameters = {}
    for i, varname in enumerate(parameter_variables):
        parameters.update({
            varname: param_vals[i]
        })
    instance = {
        "name": instance_name,
        "system-name": system["name"],
        "initial": states,
        "parameters": parameters,
        "time": {"start": TEST_INTERVAL[0], "end": TEST_INTERVAL[1], "count": 21},
        "count": NUM_PTS,
    }
    return instance

#this really really needs to be cleaned up
def convert_instance(system, instance_name, param_vals, initial_vals):
    state_variables = system["state-variables"]
    states = []
    for i, varname in enumerate(state_variables):
        states.append({
            "varname": varname,
            "value": initial_vals[i],
            "comma": ", " if i < len(state_variables)-1 else "",
            "space": " " if i < len(state_variables)-1 else "",
        })
    parameter_variables = system["parameter-variables"]
    parameters = []
    for i, varname in enumerate(parameter_variables):
        parameters.append({
            "varname": varname,
            "comma": ", " if i < len(parameter_variables)-1 else "",
            "space": " " if i < len(parameter_variables)-1 else "",
            "true": param_vals[i]
        })
    instance = {
        "name": instance_name,
        "system-name": system["name"],
        "states": states,
        "parameters": parameters,
        "time_start": TEST_INTERVAL[0],
        "time_end": TEST_INTERVAL[1],
        "count": NUM_PTS,
    }
    return instance
    


def main(args):
    sargs = getArgs(args)
    systems = load_systems(sargs["systems-file"])
    #instances = load_instances(sargs["instances-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    instances = {"instances":[]}
    for system in systems["systems"]:
        print(system["name"])
        instance_basename = system["name"] + "_"
        #instance_basename = "bh_rand_"
        
        os.makedirs(os.path.dirname('./test_files/'), exist_ok=True)
        os.makedirs(os.path.dirname('./test_files/pe/'), exist_ok=True)
        os.makedirs(os.path.dirname('./test_files/amigo2/'), exist_ok=True)
        os.makedirs(os.path.dirname('./test_files/iqm/'), exist_ok=True)
        os.makedirs(os.path.dirname('./test_files/sciml/'), exist_ok=True)
        
        i = 0
        np.random.seed(0)
        while i < NUM_TESTS:
            instance_name = instance_basename + str(i)
            param_values = np.random.rand(1,len(system["parameter-variables"])).round(3).tolist()[0]
            state_values = np.random.rand(1,len(system["state-variables"])).round(3).tolist()[0]
            instance = generate_instance(system, instance_name, param_values, state_values)

            os.makedirs(os.path.dirname('./julia_files/'), exist_ok=True)
            os.makedirs(os.path.dirname(sargs["datadir"]+'/csv/'), exist_ok=True)
            os.makedirs(os.path.dirname(sargs["datadir"]+'/julia/'), exist_ok=True)
            system = systems_by_name[instance["system-name"]]

            settings = get_settings(system, instance)
            settings.update(sargs)
            julia_file = chevron.render(open('templates/julia_sample.jl.template'), settings)
            with open('julia_files/' + instance["name"] + ".jl", 'w') as output_file:
                output_file.write(julia_file)
    
            ## run julia code here
            ##cmd = ['julia', 'julia_files/' + instance["name"], '>', 'dat_files/' + re.sub('.jl$', '.dat', instance["name"])]
            print(instance["name"])
            cmd_str = 'julia julia_files/' + instance["name"] + '.jl'
            cmd = shlex.split(cmd_str)
            try:
                output = subprocess.check_output(cmd)
            
                ##store data
                #values = solve_ode(system, instance)
    
                i += 1
            except subprocess.CalledProcessError:
                print("Error excepted. Settings:")
                print("init conds = {}".format(instance["initial"]))
                print("params = {}".format(instance["parameters"]))
                continue
        
            df = pd.read_csv(settings["datadir"] + '/csv/' + instance["name"] + '.csv', header=None, index_col=False)
            settings["data"] = df[list(range(1, settings["num_measurements"]+1))].to_string(index=False, header=False, index_names=False)#.replace("  ", ", ")

            with open('test_files/pe/' + instance["name"] + '.jl', 'w') as output_file:
                settings["at_time"] = (TEST_INTERVAL[1] - TEST_INTERVAL[0])/2 + TEST_INTERVAL[0]
                testfile = chevron.render(open('templates/pe.jl.template'), settings)
                output_file.write(testfile)

            for bounds in [[0.0, 1.0], [0.0, 2.0], [0.0, 3.0]]:
                file_suffix = "_" + str(int(bounds[1]))
                settings["lower_bound"] = bounds[0]
                settings["upper_bound"] = bounds[1]

                with open('test_files/amigo2/' + instance["name"] + file_suffix + '.m', 'w') as output_file:
                    if system["name"] == "daisy-mamil4":
                        testfile = chevron.render(open('templates/amigo2_daisy_mamil4.m.template'), settings)
                    elif system["name"] == "biohydrogenation":
                        testfile = chevron.render(open('templates/amigo2_biohydrogenation.m.template'), settings)
                    elif system["name"] == "seir":
                        testfile = chevron.render(open('templates/amigo2_seir.m.template'), settings)
                    else:
                        testfile = chevron.render(open('templates/amigo2.m.template'), settings)
                    output_file.write(testfile)
        
        
                os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + file_suffix), exist_ok=True)
                os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + file_suffix + '/' + instance["name"] + file_suffix), exist_ok=True)
                os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + file_suffix + '/project/experiments/data/'), exist_ok=True)
                os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + file_suffix + '/project/models/'), exist_ok=True)
                settings["data"] = df.to_csv(index=False, header=False)
                with open('test_files/iqm/' + instance["name"]  + file_suffix + '/' + instance["name"] + file_suffix + '.m', 'w') as output_file:
                    if system["name"] == "daisy-mamil4":
                        testfile = chevron.render(open('templates/iqm_daisy_mamil4.m.template'), settings)
                    elif system["name"] == "biohydrogenation":
                        testfile = chevron.render(open('templates/iqm_biohydrogenation.m.template'), settings)
                    elif system["name"] == "seir":
                        testfile = chevron.render(open('templates/iqm_seir.m.template'), settings)
                    else:
                        testfile = chevron.render(open('templates/iqm.m.template'), settings)
                    output_file.write(testfile)
                with open('test_files/iqm/' + instance["name"] + file_suffix + '/project/experiments/data/experiment.csv', 'w') as output_file:
                   testfile = chevron.render(open('templates/iqm_experiment.csv.template'), settings)
                   output_file.write(testfile)
                with open('test_files/iqm/' + instance["name"] + file_suffix + '/project/experiments/data/experiment.exp', 'w') as output_file:
                   testfile = chevron.render(open('templates/iqm_experiment.exp.template'), settings)
                   output_file.write(testfile)
                with open('test_files/iqm/' + instance["name"] + file_suffix + '/project/models/models.txt', 'w') as output_file:
                   testfile = chevron.render(open('templates/iqm_model.txt.template'), settings)
                   output_file.write(testfile)
                #settings.pop("data")
            
                settings["data_expr"] = SCIML_DAT_STR[instance["system-name"]]
                with open('test_files/sciml/' + instance["name"] + file_suffix + '.jl', 'w') as output_file:
                    testfile = chevron.render(open('templates/sciml.jl.template'), settings)
                    output_file.write(testfile)
            
                instances["instances"].append(convert_instance(system, instance_name, param_values, state_values))
    
    with open(sargs["instances-file"], 'w') as outfile:
        outfile.write(chevron.render(open('templates/instances.json.template'), instances))


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


