using Distributions, Random, StaticArrays
solver = Tsit5()

@parameters muN muEE muLE muLL muM muP muPE muPL deltaNE deltaEL deltaLM rhoE rhoP
@variables t n(t) e(t) s(t) m(t) p(t) y1(t) y2(t) y3(t) y4(t)
D = Differential(t)
# TODO
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
        y1 ~ e,
        y2 ~ n,
        y3 ~ s+m,
        y4 ~ p,
]

ic = [0.774, 0.456, 0.568, 0.019, 0.618]
p_true = [0.778, 0.87, 0.979, 0.799, 0.461, 0.781, 0.118, 0.64, 0.143, 0.945, 0.522, 0.415, 0.265]
time_interval = [-0.5, 0.5]
datasize = 21

sampling_times = range(time_interval[1], time_interval[2], length = datasize)

prob_true = ODEProblem{false}(model, ic, time_interval, p_true)
solution_true = solve(prob_true, solver, p = p_true, saveat = sampling_times;
                      abstol = 1e-12, reltol = 1e-12)

data_sample = Dict(v.rhs => solution_true[v.rhs] for v in measured_quantities)
#data_sample = load("/home/soogo/parameter_estimation_tests/data/julia/crauste_1.jld2", "data")

p_rand = rand(Uniform(0.0, 1.0), length(ic) + length(p_true)) # Random Parameters
prob = ODEProblem{false}(model, ic, time_interval, p_rand)
sol = solve(remake(prob, u0 = p_rand[1:length(ic)]), solver,
            p = p_rand[(length(ic) + 1):end],
            saveat = sampling_times;
            abstol = 1e-12, reltol = 1e-12)

function loss(p)
    sol = solve(remake(prob; u0 = SVector{ 5 }(p[1:length(ic)])), Tsit5(), p = p[(length(ic) + 1):end],
                saveat = sampling_times;
                abstol = 1e-12, reltol = 1e-12)
    data_true = [data_sample[v.rhs] for v in measured_quantities]
    data = [TOBEFILLEDOUT] # [(sol[2, :]), (p[5] / p[6] .+ sol[4, :])]
    if sol.retcode == ReturnCode.Success
        loss = sum(sum((data[i] .- data_true[i]) .^ 2) for i in eachindex(data))
        return loss, sol
    else
        return Inf, sol
    end
end

callback = function (p, l, pred)
    return false
end

adtype = Optimization.AutoForwardDiff()
optf = Optimization.OptimizationFunction((x, p) -> loss(x), adtype)
optprob = Optimization.OptimizationProblem(optf, p_rand, lb = 0.0*ones(5+13), ub = 1.0*ones(5+13))

@time result_ode = Optimization.solve(optprob, BFGS(), callback = callback, maxiters = 100000)

println(result_ode.u)

 all_params = vcat(ic, p_true)
 println("Max. relative abs. error between true and estimated parameters:",
         maximum(abs.((result_ode.u .- all_params) ./ (all_params))))
