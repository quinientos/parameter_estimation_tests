push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

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
ic = [0.881, 0.475, 0.881, 0.584, 0.691]
p_true = [0.227, 0.188, 0.625, 0.211, 0.257, 0.395, 0.757, 0.178, 0.77, 0.177]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic, datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/hiv_4.csv", dat_str)
save("data/julia/hiv_4.jld2", "data", data_sample)

