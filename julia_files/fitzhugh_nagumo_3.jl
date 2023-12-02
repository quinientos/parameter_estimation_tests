push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

@parameters g a b
@variables t V(t) R(t) y1(t)
D = Differential(t)
states = [V, R]
parameters = [g, a, b]
@named model = ODESystem([
                             D(V) ~ g * (V - V^3 / 3 + R),
                             D(R) ~ 1 / g * (V - a + b * R),
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ V,
]
ic = [0.723, 0.796]
p_true = [0.17, 0.116, 0.766]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic, datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/fitzhugh_nagumo_3.csv", dat_str)
save("data/julia/fitzhugh_nagumo_3.jld2", "data", data_sample)

