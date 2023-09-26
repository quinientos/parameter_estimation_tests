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

def load_systems(sys_file):
    with open(sys_file) as systems_json:
        return json.load(systems_json)

def generate_instance(system, instance_name, param_vals, initial_vals):
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
        "lower_bound": "0.0",
        "upper_bound": "1.0"
    }
    return instance

systems = load_systems('input_files/bh_system.json') 
systems_by_name = {}
for system in systems["systems"]:
    systems_by_name[system["name"]] = system
system = systems_by_name["biohydrogenation"]    

instances = {"instances":[]}
instance_basename = "bh_orig_"
param_values = [0.143, 0.286, 0.429, 0.571, 0.714, 0.857]
state_values = [0.2, 0.4, 0.6, 0.8]
instance_name = instance_basename + "0"
instance = generate_instance(system, instance_name,\
                      param_values,\
                      state_values)
instances["instances"].append(instance)

for i in range(1,10):
    instance_name = instance_basename + str(i)
    #permute param_values and state_values
    instance = generate_instance(system, instance_name,\
                          np.random.permutation(param_values),\
                          np.random.permutation(state_values))
    instances["instances"].append(instance)
    

instance_basename = "bh_even_"
true_values = [0.091, 0.182, 0.273, 0.364, 0.455, 0.545, 0.636, 0.727, 0.818, 0.909]
for i in range(10):
    tmp_vals = np.random.permutation(true_values) if i>0 else true_values
    param_values = tmp_vals[:6]
    state_values = tmp_vals[6:]
    instance_name = instance_basename + str(i)
    instance = generate_instance(system, instance_name, param_values, state_values)
    instances["instances"].append(instance)


instance_basename = "bh_rand_"
for i in range(10):
    instance_name = instance_basename + str(i)
    param_values = np.random.rand(1,6).round(3).tolist()[0]
    state_values = np.random.rand(1,4).round(3).tolist()[0]
    instance_name = instance_basename + str(i)
    instance = generate_instance(system, instance_name, param_values, state_values)
    instances["instances"].append(instance)


with open('input_files/bh_instances.json', 'w') as outfile:
    outfile.write(chevron.render(open('templates/instances.json.template'), instances))

