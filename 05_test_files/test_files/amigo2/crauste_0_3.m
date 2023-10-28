addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_0model'; % Folder to keep results
inputs.pathd.short_name='crauste_0';                 % To identify figures and reports
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
inputs.model.par = [0.549, 0.715, 0.603, 0.545, 0.424, 0.646, 0.438, 0.892, 0.964, 0.383, 0.792, 0.529, 0.568];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.926, 0.071, 0.087, 0.02, 0.833];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.0710000000000000 0.9260000000000000 0.1070000000000000 0.8330000000000000
0.1066531585831193 0.8657202384539031 0.1077579844212022 0.8209306274618827
0.1392862924013003 0.8098481166417253 0.1083428428442233 0.8082264818122341
0.1690288309768698 0.7580563980162430 0.1087690322558464 0.7949612542993023
0.1960176077477749 0.7100393028956766 0.1090501964996550 0.7812061037553691
0.2203943745272503 0.6655117489387564 0.1091991298441452 0.7670292384933485
0.2423035926315318 0.6242084932633335 0.1092277623857934 0.7524955984181846
0.2618905061270373 0.5858832041106621 0.1091471633810378 0.7376666275696246
0.2792994930671610 0.5503074862003544 0.1089675588594767 0.7226001265145802
0.2946726826371854 0.5172698813734843 0.1086983602180362 0.7073501741911565
0.3081488213201608 0.4865748616216769 0.1083482008878286 0.6919671086094541
0.3198623670592760 0.4580418295692329 0.1079249785778887 0.6764975567769720
0.3299427886724896 0.4315041379953127 0.1074359010013242 0.6609845047124651
0.3385140468856065 0.4068081376101236 0.1068875333681280 0.6454673993308360
0.3456942334783538 0.3838122602312570 0.1062858462789934 0.6299822750160008
0.3515953460634023 0.3623861422526183 0.1056362629543131 0.6145618984347430
0.3563231773015076 0.3424097920182514 0.1049437050050082 0.5992359262671202
0.3599772992379239 0.3237728028187009 0.1042126361604657 0.5840310710020051
0.3626511251047976 0.3063736130367790 0.1034471035833497 0.5689712714038151
0.3644320332075379 0.2901188128954786 0.1026507765140281 0.5540778640900994
0.3654015392048815 0.2749224974319483 0.1018269821325459 0.5393697539022905
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=3.0*ones(1,13);
inputs.PEsol.global_theta_min=0.0*ones(1,13);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=3.0*ones(1,5);                % Maximum allowed values for the initial conditions
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
