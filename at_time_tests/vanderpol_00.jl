push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters a b
@variables t x1(t) x2(t) y1(t) y2(t)
D = Differential(t)
states = [x1, x2]
parameters = [a, b]
@named model = ODESystem([
                             D(x1) ~ a * x2,
                             D(x2) ~ -(x1) - b * (x1^2 - 1) * (x2),
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ x1,
        y2 ~ x2,
]
ic = [0.603, 0.545]
p_true = [0.549, 0.715]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic, datasize; solver = solver)


@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad))
                all_params = vcat(ic, p_true)
for each in res
  estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
  println("For model ", name, ": Max abs rel. err: ", maximum(abs.((estimates .- all_params) ./ (all_params))))
end
~       
