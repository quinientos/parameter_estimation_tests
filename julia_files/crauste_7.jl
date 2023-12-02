push!(LOAD_PATH, "/home/soogo/ParameterEstimation.jl")
using ModelingToolkit, DifferentialEquations
using ParameterEstimation
using JLD2, FileIO
solver = Tsit5()

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
ic = [0.445, 0.817, 0.394, 0.449, 0.814]
p_true = [0.115, 0.341, 0.628, 0.332, 0.594, 0.443, 0.208, 0.339, 0.556, 0.573, 0.559, 0.623, 0.622]
time_interval = [-0.5, 0.5]
datasize = 21

data_sample = ParameterEstimation.sample_data(model, measured_quantities, convert(Array{Float64},time_interval),
                                              p_true, ic, datasize; solver = solver)

ks = data_sample.keys
dat_str = ""
for i=1:21
  global dat_str = dat_str * string(data_sample["t"][i]) * ", " * join(collect(data_sample[ks[j]][i] for j=1:(length(ks)-1)), ", ") * "\n"
end
write("data/csv/crauste_7.csv", dat_str)
save("data/julia/crauste_7.jld2", "data", data_sample)

