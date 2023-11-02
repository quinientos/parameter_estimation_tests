push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters lm d beta a k uu c q b h
@variables t x(t) yy(t) vv(t) w(t) z(t) y1(t) y2(t) y3(t) y4(t)
D = Differential(t)
states = [x, yy, vv, w, z]
parameters = [lm, d, beta, a, k, uu, c, q, b, h]
@named model = ODESystem([
                             D(x) ~ lm - d * x - beta * x * vv,
                             D(yy) ~ beta * x * vv - a * yy,
                             D(vv) ~ k * yy - uu * vv,
                             D(w) ~ c * x * yy * w - c * q * yy * w - b * w,
                             D(z) ~ c * q * yy * w - h * z,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ w,
        y2 ~ z,
        y3 ~ x,
        y4 ~ yy+vv,
]
ic = [0.813, 0.576, 0.611, 0.933, 0.164]
p_true = [0.594, 0.744, 0.642, 0.59, 0.481, 0.681, 0.494, 0.903, 0.967, 0.445]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/hiv_0.jld2", "data")

@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad), at_time=0.5)
