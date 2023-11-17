using ParameterEstimation
using ModelingToolkit, DifferentialEquations
solver = Tsit5()

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)

ic = [0.517, 0.432]
time_interval = [-0.5, 0.5]
datasize = 21
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.612, 0.215, 0.856] # True Parameters
measured_quantities = [y1 ~ r]
states = [r, w]
parameters = [k1, k2, k3]

@named model = ODESystem([D(r) ~ k1 * r - k2 * r * w, D(w) ~ k2 * r * w - k3 * w], t,
                        states, parameters)

data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                             p_true, ic, datasize; solver = solver)

res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                                  solver = solver)

using ParameterEstimation
using ModelingToolkit, DifferentialEquations
solver = Tsit5()

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)

ic = [0.871, 0.407]
time_interval = [-0.5, 0.5]
datasize = 21
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.617, 0.45, 0.813] # True Parameters
measured_quantities = [y1 ~ r]
states = [r, w]
parameters = [k1, k2, k3]

@named model = ODESystem([D(r) ~ k1 * r - k2 * r * w, D(w) ~ k2 * r * w - k3 * w], t,
                        states, parameters)

data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                             p_true, ic, datasize; solver = solver)

res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                                  solver = solver)

import ParameterEstimation
using ModelingToolkit, DifferentialEquations#, Plots
solver = Tsit5()

@parameters a12 a13 a21 a31 a01
@variables t x1(t) x2(t) x3(t) y1(t) y2(t)
D = Differential(t)

ic = [0.182, 0.267, 0.229]
time_interval = [-0.5, 0.5]
datasize = 21
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.352, 0.391, 0.556, 0.451, 0.891] # True Parameters

states = [x1, x2, x3]
parameters = [a12, a13, a21, a31, a01]
@named model = ODESystem([D(x1) ~ -(a21 + a31 + a01) * x1 + a12 * x2 + a13 * x3,
                            D(x2) ~ a21 * x1 - a12 * x2,
                            D(x3) ~ a31 * x1 - a13 * x3],
                        t, states, parameters)
measured_quantities = [y1 ~ x1, y2 ~ x2]
data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                             p_true, ic, datasize; solver = solver)

res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                                  solver = solver)
