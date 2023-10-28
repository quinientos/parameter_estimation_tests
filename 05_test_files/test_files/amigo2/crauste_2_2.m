addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_2model'; % Folder to keep results
inputs.pathd.short_name='crauste_2';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=5;                                  % Number of states:\\\
inputs.model.n_par=13;                                 % Number of model parameters
inputs.model.st_names=char('n', 'e', 's', 'm', 'p');    % Names of the states
inputs.model.par_names=char('muN', 'muEE', 'muLE', 'muLL', 'muM', 'muP', 'muPE', 'muPL', 'deltaNE', 'deltaEL', 'deltaLM', 'rhoE', 'rhoP');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dn = -1 * n * muN - n * p * deltaNE;',  'de = n * p * deltaNE - e * e * muEE - e * deltaEL + e * p * rhoE;',  'ds = s * deltaEL - s * deltaLM - s * s * muLL - e * s * muLE;',  'dm = s * deltaLM - muM * m;',  'dp = p * p * rhoP - p * muP - e * p * muPE - s * p * muPL;');               % Equations describing system dynamics.
inputs.model.par = [0.612, 0.617, 0.944, 0.682, 0.36, 0.437, 0.698, 0.06, 0.667, 0.671, 0.21, 0.129, 0.315];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.364, 0.57, 0.439, 0.988, 0.102];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.5700000000000000 0.3640000000000000 1.4270000000000000 0.1020000000000000
0.5433237810684260 0.3518557225451171 1.4060481661299624 0.0979022078788755
0.5182665480771386 0.3401616889242932 1.3860178065355466 0.0940500935252686
0.4946966904289378 0.3288973097860188 1.3668394139579694 0.0904227156070908
0.4724964151342085 0.3180433119931273 1.3484520518122234 0.0870014334256740
0.4515599745749800 0.3075816168596951 1.3308020405596497 0.0837696014711454
0.4317921603751462 0.2974952333687219 1.3138418750300005 0.0807123111574851
0.4131070180579862 0.2877681642111348 1.2975293273436772 0.0778161714967253
0.3954267455429405 0.2783853227254878 1.2818266997065209 0.0750691220368854
0.3786807454899670 0.2693324591742931 1.2667001989679834 0.0724602726706287
0.3628048070831983 0.2605960951182796 1.2521194107566056 0.0699797659443967
0.3477403969693936 0.2521634647289290 1.2380568552902846 0.0676186582584946
0.3334340428448277 0.2440224621950719 1.2244876107106373 0.0653688170291195
0.3198367956623165 0.2361615943220973 1.2113889922142018 0.0632228313409624
0.3069037593078647 0.2285699378606042 1.1987402779658152 0.0611739341244928
0.2945936777635676 0.2212371007964703 1.1865224738352829 0.0592159341175165
0.2828685719323776 0.2141531872638808 1.1747181109601312 0.0573431562431992
0.2716934191096985 0.2073087655472227 1.1633110708025909 0.0555503891900195
0.2610358695915585 0.2006948389631050 1.1522864337094323 0.0538328392375419
0.2508659952686851 0.1943028191570417 1.1416303471967251 0.0521860894441248
0.2411560662247244 0.1881245016556565 1.1313299112133293 0.0506060635111216
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=2.0*ones(1,13);
inputs.PEsol.global_theta_min=0.0*ones(1,13);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=2.0*ones(1,5);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,5);
%=============================================================
% COST FUNCTION RELATED DATA
% SOLVING THE PROBLEM WITH WEIGHTED LEAST SQUARES FUNCTION
%=============================================================
inputs.PEsol.PEcost_type='lsq';          % 'lsq' (weighted least squares default)
inputs.PEsol.lsq_type='Q_I';             % Weights:
                                         % Q_I: identity matrix; Q_expmax: maximum experimental data
                                         % Q_expmean: mean experimental data;
                                         % Q_mat: user selected weighting matrix
% OPTIMIZATION
%inputs.nlpsol.nlpsolver='local_lsqnonlin';  % In this case the problem will be solved with
                                         % a local non linear least squares
                                         % method.AMIGO_Prep(inputs);
% %
inputs.nlpsol.nlpsolver='eSS';                      % Solver used for optimization
inputs.nlpsol.eSS.log_var=1:(5+13); 
inputs.nlpsol.eSS.local.solver = 'nl2sol';
inputs.nlpsol.eSS.local.finish = 'nl2sol';
inputs.nlpsol.eSS.maxeval = 100000;                  % Maximum number of cost function evaluations
inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization
inputs.nlpsol.eSS.local.nl2sol.maxiter             =      1000;
inputs.nlpsol.eSS.local.nl2sol.maxfeval            =      2000;
inputs.nlpsol.eSS.local.nl2sol.tolrfun             =     1e-10;
inputs.nlpsol.eSS.local.nl2sol.tolafun             =     1e-10;
inputs.nlpsol.eSS.local.nl2sol.objrtol			 =     1e-10;
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
AMIGO_Prep(inputs);
[PEresults] = AMIGO_PE(inputs);
PEresults.fit.global_theta_estimated
PEresults.fit.global_theta_y0_estimated
