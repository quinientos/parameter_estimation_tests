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

def load_systems():
    with open('systems.json') as systems_json:
        return json.load(systems_json)

def load_instances():
    with open('instances.json') as instances_json:
        return json.load(instances_json)


def get_settings(system, instance):
    instance_name = instance["name"]
    time = instance["time"]
    state_variables = system["state-variables"]
    states = []
    for i, varname in enumerate(state_variables):
        states.append({
            "varname": varname,
            "comma": ", " if i < len(state_variables)-1 else "",
            "space": " " if i < len(state_variables)-1 else "",
        })
    measurement_variables = system["measurement-variables"]
    measurements = []
    for i, varname in enumerate(measurement_variables):
        measurements.append({
            "varname": varname,
            "comma": ", " if i < len(measurement_variables)-1 else "",
            "space": " " if i < len(measurement_variables)-1 else "",
        })
    parameter_variables = system["parameter-variables"]
    parameters = []
    for i, varname in enumerate(parameter_variables):
        parameters.append({
            "varname": varname,
            "comma": ", " if i < len(parameter_variables)-1 else "",
            "space": " " if i < len(parameter_variables)-1 else "",
            "true": instance['parameters'][varname],
        })
    components = []
    for i, state_var in enumerate(state_variables):
        components.append({
            "state_var": state_var,
            "state_expr": system["pde-system"][state_var],
            "comma": ", " if i < len(state_variables)-1 else "",
        })
    measured_quantities = []
    for i, measure_var in enumerate(system['measurement-variables']):
        measured_quantities.append({
            "measurement": measure_var,
            "measurement_expression": system['measurements'][measure_var],
            "index": i+1,
            "comma": ", " if i < len(measurement_variables)-1 else "",
        })

    initial_conditions = []
    for i, state_var in enumerate(state_variables):
        initial_conditions.append({
            "value": instance['initial'][state_var],
            "comma": ", " if i < len(state_variables)-1 else "",
        })

    settings = {
        "name": instance_name, #re.sub(".jl$", "" , instance_name),
        "states": states,
        "num_states": len(states),
        "measurements": measurements,
        "num_measurements": len(measurements),
        "parameters": parameters,
        "num_parameters": len(parameters),
        "components": components,
        "measured_quantities": measured_quantities,
        "initial_conditions": initial_conditions,
        "time_start": instance["time"]["start"],
        "time_end": instance["time"]["end"],
        "time_count": instance["time"]["count"],
        "lower_bound": instance["bounds"]["lower"],
        "upper_bound": instance["bounds"]["upper"]
    }
    return settings


def to_function(pde, state_vars, param_vars, param_setting):
    for varname in state_vars:
        assert varname in pde
    for varname in pde:
        assert varname in state_vars
    pde_set = {}
    for k in pde:
        expr = pde[k]
        for param, val in param_setting.items():
            expr = expr.replace(param, "(%f)" % val)
        pde_set[k] = expr
    def func(t, state):
        assert len(state) == len(state_vars)
        result = []
        for state_var in state_vars:
            expr = pde_set[state_var]
            for varname, value in zip(state_vars, state):
                expr = expr.replace(varname, "(%f)" % value)
            result.append(eval(expr))
        result = np.array(result,dtype="float")
        return result
    return func

systems = load_systems()
instances = load_instances()
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
    df = pd.read_csv('./data/csv/' + instance["name"] + '.csv', header=None, index_col=False)
    with open('test_files/pe/' + instance["name"] + '.jl', 'w') as output_file:
        testfile = chevron.render(open('templates/pe.jl.template'), settings)
        output_file.write(testfile)

    settings["data"] = df[list(range(1, settings["num_measurements"]+1))].to_string(index=False, header=False, index_names=False)#.replace("  ", ", ")
    with open('test_files/amigo2/' + instance["name"] + '.m', 'w') as output_file:
        testfile = chevron.render(open('templates/amigo2.m.template'), settings)
        output_file.write(testfile)
    #settings.pop("data")

    #os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"]), exist_ok=True)
    #os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/' + instance["name"]), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/project/experiments/'), exist_ok=True)
    os.makedirs(os.path.dirname('./test_files/iqm/' + instance["name"] + '/project/models/'), exist_ok=True)
    settings["data"] = df.to_csv(index=False, header=False)
    with open('test_files/iqm/' + instance["name"] + '/' + instance["name"] + '.m', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm.m.template'), settings)
       output_file.write(testfile)
    with open('test_files/iqm/' + instance["name"] + '/project/experiments/experiment.csv', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_experiment.csv.template'), settings)
       output_file.write(testfile)
    with open('test_files/iqm/' + instance["name"] + '/project/experiments/experiment.exp', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_experiment.exp.template'), settings)
       output_file.write(testfile)
    with open('test_files/iqm/' + instance["name"] + '/project/models/models.txt', 'w') as output_file:
       testfile = chevron.render(open('templates/iqm_model.txt.template'), settings)
       output_file.write(testfile)
    #settings.pop("data")

    with open('test_files/sciml/' + instance["name"] + '.jl', 'w') as output_file:
        testfile = chevron.render(open('templates/sciml.jl.template'), settings)
        output_file.write(testfile)
