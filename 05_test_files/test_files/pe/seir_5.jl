push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters a b nu
@variables t S(t) E(t) In(t) NN(t) y1(t) y2(t)
D = Differential(t)
states = [S, E, In, NN]
parameters = [a, b, nu]
@named model = ODESystem([
                             D(S) ~ -b * S * In / NN,
                             D(E) ~ b * S * In / NN - nu * E,
                             D(In) ~ nu * E - a * In,
                             D(NN) ~ 0,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ In,
        y2 ~ NN,
]
ic = [0.944, 0.682, 0.36, 0.437]
p_true = [0.618, 0.612, 0.617]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/seir_5.jld2", "data")

@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad))
                all_params = vcat(ic, p_true)
for each in res
  estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
  println("For model ", name, ": Max abs rel. err: ", maximum(abs.((estimates .- all_params) ./ (all_params))))
end
~       
