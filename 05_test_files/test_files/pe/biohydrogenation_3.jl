push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ParameterEstimation
using ModelingToolkit, DifferentialEquations
using BenchmarkTools
using JLD2, FileIO

solver = AutoVern8(Rodas4()) #Tsit5()

name = ""
@parameters k5 k6 k7 k8 k9 k10
@variables t x4(t) x5(t) x6(t) x7(t) y1(t) y2(t)
D = Differential(t)
states = [x4, x5, x6, x7]
parameters = [k5, k6, k7, k8, k9, k10]
@named model = ODESystem([
                             D(x4) ~ - k5 * x4 / (k6 + x4),
                             D(x5) ~ k5 * x4 / (k6 + x4) - k7 * x5/(k8 + x5 + x6),
                             D(x6) ~ k7 * x5 / (k8 + x5 + x6) - k9 * x6 * (k10 - x6) / k10,
                             D(x7) ~ k9 * x6 * (k10 - x6) / k10,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ x4,
        y2 ~ x5,
]
ic = [0.612, 0.617, 0.944, 0.682]
p_true = [0.265, 0.774, 0.456, 0.568, 0.019, 0.618]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/biohydrogenation_3.jld2", "data")

@time res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                solver = solver, interpolators = Dict("AAA" => ParameterEstimation.aaad))
                all_params = vcat(ic, p_true)
for each in res
  estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
  println("For model ", name, ": Max abs rel. err: ", maximum(abs.((estimates .- all_params) ./ (all_params))))
end
~       
