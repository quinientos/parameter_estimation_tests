addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='seir_3model'; % Folder to keep results
inputs.pathd.short_name='seir_3';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=4;                                  % Number of states:\\\
inputs.model.n_par=3;                                 % Number of model parameters
inputs.model.st_names=char('S', 'E', 'In', 'NN');    % Names of the states
inputs.model.par_names=char('a', 'b', 'nu');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dS = -b * S * In / NN;',  'dE = b * S * In / NN - nu * E;',  'dIn = nu * E - a * In;',  'dNN = 0;');               % Equations describing system dynamics.
inputs.model.par = [0.799, 0.461, 0.781];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.118, 0.64, 0.143, 0.945];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = In', 'y2 = NN');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.143,0.945
-0.45,0.1614319828871442,0.945
-0.4,0.178239126165274,0.945
-0.35,0.1935213747080819,0.945
-0.3,0.2073731832374359,0.945
-0.25,0.219883802952487,0.945
-0.2,0.2311375540549485,0.945
-0.15,0.2412140846087314,0.945
-0.1,0.2501886164222787,0.945
-0.05,0.2581321784701924,0.945
0.0,0.2651118285426987,0.945
0.05,0.2711908634596487,0.945
0.1,0.2764290185995766,0.945
0.15,0.2808826571481166,0.945
0.2,0.2846049495504895,0.945
0.25,0.2876460437004789,0.945
0.3,0.2900532262828629,0.945
0.35,0.2918710757348665,0.945
0.4,0.2931416072198671,0.945
0.45,0.2939044100435429,0.945
0.5,0.2941967778805217,0.945

];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta=char('b');
inputs.PEsol.global_theta_max=2.0*ones(1,1);
inputs.PEsol.global_theta_min=0.0*ones(1,1);
inputs.PEsol.id_global_theta_y0=char('In', 'NN');               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=2.0*ones(1,2);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,2)

inputs.PEsol.id_local_theta{1}=char('a', 'nu');                % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_max{1}=2.0*ones(1,2);              % Maximum allowed values for the paramters
inputs.PEsol.local_theta_min{1}=0.0*ones(1,2)              % Minimum allowed values for the parameters
inputs.PEsol.local_theta_guess{1}=[];            % [] Initial guess
inputs.PEsol.id_local_theta_y0{1}=char('E', 'S');             % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_y0_max{1}=2.0*ones(1,2);           % Maximum allowed values for the initial conditions
inputs.PEsol.local_theta_y0_min{1}=0.0*ones(1,2);           % Minimum allowed values for the initial conditions
inputs.PEsol.local_theta_y0_guess{1}=[];         % [] Initial guess

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
inputs.nlpsol.eSS.log_var=1:(4+3); 
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

%val names
inputs.model.par_names
inputs.model.st_names
%true vals:
inputs.model.par
inputs.exps.exp_y0{1}



