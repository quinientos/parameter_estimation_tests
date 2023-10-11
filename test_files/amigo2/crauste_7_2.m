addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_7model'; % Folder to keep results
inputs.pathd.short_name='crauste_7';                 % To identify figures and reports
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
inputs.model.par = [0.019, 0.302, 0.66, 0.29, 0.618, 0.429, 0.135, 0.298, 0.57, 0.591, 0.574, 0.653, 0.652];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.431, 0.897, 0.368, 0.436, 0.892];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.897,0.431,0.804,0.892
-0.45,0.8952339327874199,0.4198029176502074,0.7886672335142191,0.8885571488161031
-0.4,0.8931022561590206,0.4089363493182593,0.7735794042519709,0.8851999668815742
-0.35,0.8906288012279466,0.3983887036438973,0.7587373501710426,0.88192577191281
-0.3,0.8878362186026354,0.3881488833497065,0.7441413990173587,0.8787319802558606
-0.25,0.8847460208117324,0.378206259914295,0.7297914243625119,0.8756161045304907
-0.2,0.8813786250907819,0.3685506497426599,0.7156868960106879,0.87257575111628
-0.15,0.8777533962142552,0.3591722917172189,0.701826925295633,0.8696086175156488
-0.1,0.8738886891305271,0.3500618260978924,0.6882103058549733,0.86671248964762
-0.05,0.8698018911517963,0.3412102746212999,0.6748355502406244,0.8638852390817412
0.0,0.8655094635249951,0.3326090217625455,0.6617009228398826,0.8611248202510023
0.05,0.8610269822283968,0.3242497970866846,0.648804469481967,0.8584292676655618
0.1,0.8563691778228981,0.3161246585407302,0.6361440439436575,0.8557966931194022
0.15,0.8515499743428615,0.3082259767973078,0.6237173319265403,0.8532252829611942
0.2,0.8465825270406415,0.3005464203885254,0.611521872470759,0.8507132953768244
0.25,0.8414792590031848,0.293078941726681,0.5995550772872905,0.8482590577427791
0.3,0.8362518965146741,0.2858167638317779,0.5878142480282319,0.8458609640166553
0.35,0.8309115032411236,0.2787533678762136,0.5762965919491138,0.8435174722233031
0.4,0.8254685131069137,0.2718824813392522,0.5649992358819047,0.841227101988157
0.45,0.8199327619231745,0.2651980668287513,0.5539192388394272,0.8389884321541229
0.5,0.8143135177641174,0.2586943115176204,0.5430536033755968,0.836800098480395

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
