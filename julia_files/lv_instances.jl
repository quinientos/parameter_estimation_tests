push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
 using ModelingToolkit, DifferentialEquations, Plots
 using ParameterEstimation
 using JLD2, FileIO
solver = AutoVern8(Rodas4())

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.536, 0.439]
p_true = [0.539, 0.672, 0.582]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_0.csv", dat_str)
save("data/julia/lotka_volterra_0.jld2", "data", data_sample)
print("lotka_volterra_0 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.871, 0.407]
p_true = [0.617, 0.45, 0.813]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_1.csv", dat_str)
save("data/julia/lotka_volterra_1.jld2", "data", data_sample)
print("lotka_volterra_1 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.84, 0.157]
p_true = [0.733, 0.523, 0.554]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_2.csv", dat_str)
save("data/julia/lotka_volterra_2.jld2", "data", data_sample)
print("lotka_volterra_2 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.723, 0.796]
p_true = [0.17, 0.116, 0.766]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_3.csv", dat_str)
save("data/julia/lotka_volterra_3.jld2", "data", data_sample)
print("lotka_volterra_3 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.724, 0.195]
p_true = [0.883, 0.739, 0.469]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_4.csv", dat_str)
save("data/julia/lotka_volterra_4.jld2", "data", data_sample)
print("lotka_volterra_4 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.517, 0.432]
p_true = [0.612, 0.215, 0.856]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_5.csv", dat_str)
save("data/julia/lotka_volterra_5.jld2", "data", data_sample)
print("lotka_volterra_5 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.555, 0.115]
p_true = [0.312, 0.719, 0.465]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_6.csv", dat_str)
save("data/julia/lotka_volterra_6.jld2", "data", data_sample)
print("lotka_volterra_6 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.855, 0.645]
p_true = [0.594, 0.59, 0.594]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_7.csv", dat_str)
save("data/julia/lotka_volterra_7.jld2", "data", data_sample)
print("lotka_volterra_7 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.148, 0.633]
p_true = [0.388, 0.45, 0.658]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_8.csv", dat_str)
save("data/julia/lotka_volterra_8.jld2", "data", data_sample)
print("lotka_volterra_8 completed")

@parameters k1 k2 k3
@variables t r(t) w(t) y1(t)
D = Differential(t)
states = [r, w]
parameters = [k1, k2, k3]
@named model = ODESystem([
                             D(r) ~ k1*r - k2*r*w,
                             D(w) ~ k2*r*w - k3*w,
                         ], t, states, parameters)
measured_quantities = [
        y1 ~ r,
]
ic = [0.352, 0.391]
p_true = [0.637, 0.268, 0.203]
time_interval = [0.0, 1.0]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic,
                                              datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/lotka_volterra_9.csv", dat_str)
save("data/julia/lotka_volterra_9.jld2", "data", data_sample)
print("lotka_volterra_9 completed")

