push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

@parameters k01 k12 k13 k14 k21 k31 k41
@variables t x1(t) x2(t) x3(t) x4(t) y1(t) y2(t) y3(t)
D = Differential(t)
states = [x1, x2, x3, x4]
parameters = [k01, k12, k13, k14, k21, k31, k41]
@named model = ODESystem([
                             D(x1) ~ -k01 * x1 + k12 * x2 + k13 * x3 + k14 * x4 - k21 * x1 - k31 * x1 - k41 * x1,
                             D(x2) ~ -k12 * x2 + k21 * x1,
                             D(x3) ~ -k13 * x3 + k31 * x1,
                             D(x4) ~ -k14 * x4 + k41 * x1,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ x1,
        y2 ~ x2,
        y3 ~ x3 + x4,
]
ic = [0.451, 0.891, 0.182, 0.267]
p_true = [0.633, 0.637, 0.268, 0.203, 0.352, 0.391, 0.556]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic, datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/daisy_mamil4_4.csv", dat_str)
save("data/julia/daisy_mamil4_4.jld2", "data", data_sample)

