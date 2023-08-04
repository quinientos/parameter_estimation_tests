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
from julia.api import Julia

def load_systems():
    with open('systems.json') as systems_json:
        return json.load(systems_json)

def load_instances():
    with open('instances.json') as instances_json:
        return json.load(instances_json)


def generate_julia(system, instance):
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
    for state_var in state_variables:
        components.append({
            "state_var": state_var,
            "state_expr": system["ode-system"][state_var],
        })
    measured_quantities = []
    for measure_var in system['measurement-variables']:
        measured_quantities.append({
            "measurement": measure_var,
            "measurement_expression": system['measurements'][measure_var],
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
        "measurements": measurements,
        "parameters": parameters,
        "components": components,
        "measured_quantities": measured_quantities,
        "initial_conditions": initial_conditions,
        "time_start": instance["time"]["start"],
        "time_end": instance["time"]["end"],
        "time_count": instance["time"]["count"],
    }
    return chevron.render(open('templates/julia_sample.jl.template'), settings)


def to_function(ode, state_vars, param_vars, param_setting):
    for varname in state_vars:
        assert varname in ode
    for varname in ode:
        assert varname in state_vars
    ode_set = {}
    for k in ode:
        expr = ode[k]
        for param, val in param_setting.items():
            expr = expr.replace(param, "(%f)" % val)
        ode_set[k] = expr
    def func(t, state):
        assert len(state) == len(state_vars)
        result = []
        for state_var in state_vars:
            expr = ode_set[state_var]
            for varname, value in zip(state_vars, state):
                expr = expr.replace(varname, "(%f)" % value)
            result.append(eval(expr))
        result = np.array(result,dtype="float")
        return result
    return func

def solve_ode(system, instance):
    time = instance["time"]
    time_evaluated = np.linspace(time["start"], time["end"], num=time["count"])
    f = to_function(
        system["ode-system"],
        system["state-variables"],
        system["parameter-variables"],
        instance["parameters"]
    )
    init_value = np.array([instance["initial"][varname] for varname in system["state-variables"]])
    result = solve_ivp(
        fun=f,
        t_span=(time["start"], time["end"]),
        y0=init_value,
        t_eval=time_evaluated
        )
    assert result.status == 0
    result_list = []
    for t, y in zip(result.t, result.y.transpose()):
        result_list.append((t, y))
    return result_list

systems = load_systems()
instances = load_instances()
systems_by_name = {}
for system in systems["systems"]:
    systems_by_name[system["name"]] = system

os.makedirs(os.path.dirname('./julia_files/'), exist_ok=True)
os.makedirs(os.path.dirname('./data/csv/'), exist_ok=True)
os.makedirs(os.path.dirname('./data/julia/'), exist_ok=True)
for instance in instances["instances"]:
    system = systems_by_name[instance["system-name"]]
    with open('julia_files/' + instance["name"] + ".jl", 'w') as output_file:
        output_file.write(generate_julia(system, instance))

    ## run julia code here
    ##cmd = ['julia', 'julia_files/' + instance["name"], '>', 'dat_files/' + re.sub('.jl$', '.dat', instance["name"])]
    cmd_str = 'julia julia_files/' + instance["name"] + '.jl'
    cmd = shlex.split(cmd_str)
    output = subprocess.check_output(cmd)

    ##store data
    values = solve_ode(system, instance)
