addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_1model'; % Folder to keep results
inputs.pathd.short_name='crauste_1';                 % To identify figures and reports
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
inputs.model.par = [0.778, 0.87, 0.979, 0.799, 0.461, 0.781, 0.118, 0.64, 0.143, 0.945, 0.522, 0.415, 0.265];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.774, 0.456, 0.568, 0.019, 0.618];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.456,0.774,0.587,0.618
-0.45,0.4351470481020797,0.7412703626998859,0.5880894007310742,0.5868827324192414
-0.4,0.415212940040245,0.7100785255456756,0.5896451863748426,0.5573967678394661
-0.35,0.3961636783184941,0.6803388572880129,0.5916045131679546,0.5294439294635335
-0.3,0.3779652481528733,0.6519716482880287,0.5939132406030451,0.5029339809722659
-0.25,0.3605839217886913,0.624902600012264,0.5965246208933289,0.477783702064544
-0.2,0.3439864890837302,0.5990623681917981,0.5993982047038898,0.4539161033517219
-0.15,0.3281404300484667,0.5743861531979157,0.6024989239607195,0.4312597566660459
-0.1,0.3130140414015469,0.5508133315771834,0.6057963203332942,0.4097482208965006
-0.05,0.2985765267889747,0.5282871237324205,0.6092638940638833,0.3893195473364402
0.0,0.284798058531653,0.5067542937760381,0.6128785525718203,0.3699158517680058
0.05,0.271649816835093,0.4861648776222544,0.6166201421523285,0.351482942357766
0.1,0.2591040112957207,0.4664719361083208,0.6204710491244583,0.3339699945460935
0.15,0.2471338888130988,0.4476313307692154,0.6244158591436911,0.3173292660138696
0.2,0.2357137306966265,0.4296015194046687,0.6284410655200088,0.3015158453006957
0.25,0.224818841672609,0.412343369730272,0.6325348188229508,0.2864874294247168
0.3,0.2144255324414868,0.3958199887812387,0.6366867115354614,0.2722041259035901
0.35,0.2045110978191817,0.3799965671947754,0.640887592300349,0.2586282763421734
0.4,0.1950537912127996,0.3648402361594739,0.6451294055198,0.2457242979756997
0.45,0.1860327967395488,0.3503199362704405,0.6494050524875619,0.2334585411457485
0.5,0.1774281996115148,0.3364062969049714,0.6537082710051811,0.2217991604026374

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
