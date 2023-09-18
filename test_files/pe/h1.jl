push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations, Plots
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

@parameters a b
@variables t x1(t) x2(t) y1(t) y2(t)
D = Differential(t)
# TODO
states = [x1, x2]
parameters = [a, b]
@named model = ODESystem([
                             D(x1) ~ -a*x2,
                             D(x2) ~ +x1/b,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ x1,
        y2 ~ x2,
]
ic = [0.1, 0.23]
p_true = [1.2, 1.0]
time_interval = [-1.1, 1.0]
datasize = 20

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/h1.jld2", "data")
res = ParameterEstimation.estimate(model, measured_quantities, data_sample; solver = solver)
all_params = vcat(ic, p_true)

#put in selection for which answer in case of multiples
for each in res
    estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
end

