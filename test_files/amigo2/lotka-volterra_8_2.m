addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='lotka-volterra_8model'; % Folder to keep results
inputs.pathd.short_name='lotka-volterra_8';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=2;                                  % Number of states:\\\
inputs.model.n_par=3;                                 % Number of model parameters
inputs.model.st_names=char('r', 'w');    % Names of the states
inputs.model.par_names=char('k1', 'k2', 'k3');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dr = k1*r - k2*w;',  'dw = k2*r*w - k3*w;');               % Equations describing system dynamics.
inputs.model.par = [0.36, 0.437, 0.698];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.06, 0.667];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=1;                       % Number of observables
inputs.exps.obs_names{1}=char('y1'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = r');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.06
-0.45,0.0466280783515093
-0.4,0.0334950310570319
-0.35,0.0205930266453076
-0.3,0.0079141693189465
-0.25,-0.0045494856974407
-0.2,-0.0168059178468672
-0.15,-0.0288631279754737
-0.1,-0.0407291259681632
-0.05,-0.0524119193917309
0.0,-0.063919503033095
0.05,-0.0752598492696274
0.1,-0.0864408994504118
0.15,-0.0974705558506641
0.2,-0.1083566745941717
0.25,-0.1191070592370802
0.3,-0.1297294550687864
0.35,-0.1402315440588951
0.4,-0.1506209405465441
0.45,-0.1609051873407554
0.5,-0.1710917525382009

];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=2.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0*ones(1,3);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=2.0*ones(1,2);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,2);
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
inputs.nlpsol.eSS.log_var=1:(2+3); 
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
