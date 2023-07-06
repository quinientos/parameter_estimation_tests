#!/usr/bin/env python3

import json
from pprint import pprint
import numpy as np
from scipy.integrate import solve_ivp

def load_systems():
    with open('systems.json') as systems_json:
        return json.load(systems_json)

def load_instances():
    with open('instances.json') as instances_json:
        return json.load(instances_json)

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
        print(result)
        return result

    return func


systems = load_systems()
instances = load_instances()
systems_by_name = {}
for system in systems["systems"]:
    systems_by_name[system["name"]] = system

for instance in instances["instances"]:
    print("instance name:", instance["name"])
    system = systems_by_name[instance["system-name"]]
    pprint(instance)
    pprint(system)

    time = instance["time"]
    time_evaluated = np.linspace(time["start"], time["end"], num=time["count"])

    f = to_function(
        system["pde-system"],
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
    if result.status == 0:
        print(time_evaluated)
        for t, y in zip(result.t, result.y.transpose()):
            print(t, y)
