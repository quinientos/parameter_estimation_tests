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

def generate_instance(system, instance_name, param_vals, initial_vals, bounds=[0.0, 1.0]):
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
        "time": {"start": -0.5, "end": 0.5, "count": 21},
        "count": 21,
        "bounds": {"lower": bounds[0], "upper": bounds[1]}
    }
    return instance

#this really really needs to be cleaned up
def convert_instance(system, instance_name, param_vals, initial_vals, bounds=[0.0, 1.0]):
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
        "sys_name": system["name"],
        "states": states,
        "parameters": parameters,
        "time_start": "-0.5",
        "time_end": "0.5",
        "count": "21",
        "lower_bound": bounds[0],
        "upper_bound": bounds[1]
    }
    return instance
    


def main(args):
    np.random.seed(0)
    sargs = getArgs(args)
    systems = load_systems(sargs["systems-file"])
    #instances = load_instances(sargs["instances-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    # for system in systems:
    system = systems_by_name["biohydrogenation"]    
    instance_basename = system["name"] + "_"
    #instance_basename = "bh_rand_"
    
    instances = {"instances":[]}
    #for i in range(10):
    #os.makedirs(os.path.dirname('./test_files/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/pe/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/amigo2/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/sciml/'), exist_ok=True)
    
    tmp_instances = {"instances":[]}
    i = 0
    while i < 10:
        instance_name = instance_basename + str(i)
        param_values = np.random.rand(1,len(system["parameter-variables"])).round(3).tolist()[0] #len(parameters)
        state_values = np.random.rand(1,len(system["state-variables"])).round(3).tolist()[0] #len(states)
        instance_name = instance_basename + str(i)
        instance = generate_instance(system, instance_name, param_values, state_values)
        instances["instances"].append(instance)
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
        with open('test_files/amigo2/' + instance["name"] + '.m', 'w') as output_file:
            if system["name"] == "daisy-mamil4":
                testfile = chevron.render(open('templates/amigo2_daisy_mamil4.m.template'), settings)
            elif system["name"] == "biohydrogenation":
                testfile = chevron.render(open('templates/amigo2_biohydrogenation.m.template'), settings)
            elif system["name"] == "seir":
                testfile = chevron.render(open('templates/amigo2_seir.m.template'), settings)
            else:
                testfile = chevron.render(open('templates/amigo2.m.template'), settings)
            output_file.write(testfile)

        tmp_instances["instances"].append(convert_instance(system, instance_name, param_values, state_values))
    
    #with open('{}'.format(sargs["instances-file"]), 'w') as outfile:

    with open('input_files/bh_instances.json', 'w') as outfile:
        outfile.write(chevron.render(open('templates/instances.json.template'), tmp_instances))


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
    parser.add_argument('-i', '--instances', default="./instances.json")
    parser.add_argument('-s', '--systems', default="./systems.json")
    #add other options as they come up
    args = parser.parse_args()
    main(args)


