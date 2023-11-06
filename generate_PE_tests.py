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
        "time": {"start": TIME_INTERVAL[0], "end": TIME_INTERVAL[1], "count": 21},
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
        "time_start": TIME_INTERVAL[0],
        "time_end": TIME_INTERVAL[1],
        "count": NUM_PTS,
    }
    return instance
    


def main(args):
    sargs = getArgs(args)
    systems = load_systems(sargs["systems-file"])
    systems_by_name = {}
    for system in systems["systems"]:
        systems_by_name[system["name"]] = system
    
    #instances = {"instances":[]}
    for system in systems["systems"]:
        print(system["name"])
        instance_basename = system["name"] + "_"
        
        os.makedirs(os.path.dirname('./PE_tests/'), exist_ok=True)
        
        i = 0

        #seeding for reproducibility. Remove as needed
        np.random.seed(0)

        while i < NUM_TESTS:
            instance_name = instance_basename + str(i)
            param_values = np.random.uniform(low=PARAM_INTERVAL[0], high=PARAM_INTERVAL[1], size=len(system["parameter-variables"])).round(3).tolist()
            state_values = np.random.uniform(low=PARAM_INTERVAL[0], high=PARAM_INTERVAL[1], size=len(system["state-variables"])).round(3).tolist()
            instance = generate_instance(system, instance_name, param_values, state_values)

            system = systems_by_name[instance["system-name"]]
            settings = get_settings(system, instance)
            settings.update(sargs)
            #julia_file = chevron.render(open('templates/julia_sample.jl.template'), settings)
            #with open('julia_files/' + instance["name"] + ".jl", 'w') as output_file:
            #    output_file.write(julia_file)
    
            ### run julia code here
            ###cmd = ['julia', 'julia_files/' + instance["name"], '>', 'dat_files/' + re.sub('.jl$', '.dat', instance["name"])]
            #print(instance["name"])
            #cmd_str = 'julia julia_files/' + instance["name"] + '.jl'
            #cmd = shlex.split(cmd_str)
            #try:
            #    output = subprocess.check_output(cmd)
            #    i += 1

            #except subprocess.CalledProcessError:
            #    # possibly ran into singularities
            #    print("Error excepted. Settings:")
            #    print("init conds = {}".format(instance["initial"]))
            #    print("params = {}".format(instance["parameters"]))
            #    continue
        

            with open('./PE_tests/' + instance_name + '.jl', 'w') as output_file:
                settings["at_time"] = (TIME_INTERVAL[1] - TIME_INTERVAL[0])/2 + TIME_INTERVAL[0]
                testfile = chevron.render(open('templates/pe_standalone.jl.template'), settings)
                output_file.write(testfile)
            
            #instances["instances"].append(convert_instance(system, instance_name, param_values, state_values))
            i += 1
    
    #with open(sargs["instances-file"], 'w') as outfile:
    #    outfile.write(chevron.render(open('templates/instances.json.template'), instances))


def getArgs(args):
    #instances_file = args.instances
    systems_file = args.systems
    sys_args = {
        #"instances-file": instances_file,
        "systems-file": systems_file
    }

    return sys_args
    
if __name__=='__main__':
    parser = argparse.ArgumentParser()
    #parser.add_argument('-i', '--instances', default="input_files/instances.json")
    parser.add_argument('-s', '--systems', default="input_files/systems.json")
    #add other options as they come up
    args = parser.parse_args()
    main(args)


