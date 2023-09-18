push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations, Plots
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
# TODO
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.333, 0.667]
p_true = [0.25, 0.5, 0.75]
time_interval = [-1.0, 1.0]
datasize = 20

data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/lk1.jld2", "data")
res = ParameterEstimation.estimate(model, measured_quantities, data_sample; solver = solver)
all_params = vcat(ic, p_true)

#put in selection for which answer in case of multiples
for each in res
    estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
end

