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


def load_systems(sys_file):
    with open(sys_file) as systems_json:
        return json.load(systems_json)

def load_instances(inst_file):
    with open(inst_file) as instances_json:
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
            "state_expr": system["ode-system"][state_var],
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

