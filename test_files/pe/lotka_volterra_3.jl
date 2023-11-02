push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.8, 0.883]
p_true = [0.178, 0.118, 0.849]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/lotka_volterra_3.jld2", "data")

@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad), at_time=0.5)
