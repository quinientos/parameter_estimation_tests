push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters muN muEE muLE muLL muM muP muPE muPL deltaNE deltaEL deltaLM rhoE rhoP
@variables t n(t) e(t) s(t) m(t) p(t) y1(t) y2(t) y3(t) y4(t)
D = Differential(t)
states = [n, e, s, m, p]
parameters = [muN, muEE, muLE, muLL, muM, muP, muPE, muPL, deltaNE, deltaEL, deltaLM, rhoE, rhoP]
@named model = ODESystem([
                             D(n) ~ -1 * n * muN - n * p * deltaNE,
                             D(e) ~ n * p * deltaNE - e * e * muEE - e * deltaEL + e * p * rhoE,
                             D(s) ~ s * deltaEL - s * deltaLM - s * s * muLL - e * s * muLE,
                             D(m) ~ s * deltaLM - muM * m,
                             D(p) ~ p * p * rhoP - p * muP - e * p * muPE - s * p * muPL,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ n,
        y2 ~ e,
        y3 ~ s+m,
        y4 ~ p,
]
ic = [0.612, 0.466, 0.162, 0.728, 0.508]
p_true = [0.826, 0.733, 0.19, 0.928, 0.743, 0.999, 0.235, 0.881, 0.246, 0.654, 0.211, 0.863, 0.827]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/crauste_8.jld2", "data")

@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad), at_time=0.5)
