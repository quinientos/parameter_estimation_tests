addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='daisy-mamil3_1model'; % Folder to keep results
inputs.pathd.short_name='daisy-mamil3_1';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=3;                                  % Number of states:\\\
inputs.model.n_par=5;                                 % Number of model parameters
inputs.model.st_names=char('x1', 'x2', 'x3');    % Names of the states
inputs.model.par_names=char('a12', 'a13', 'a21', 'a31', 'a01');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx1 = -(a21 + a31 + a01) * x1 + a12 * x2 + a13 * x3;',  'dx2 = a21 * x1 - a12 * x2;',  'dx3 = a31 * x1 - a13 * x3;');               % Equations describing system dynamics.
inputs.model.par = [0.964, 0.383, 0.792, 0.529, 0.568];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.926, 0.071, 0.087];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x2', 'y2 = x1');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.071,0.926
-0.45,0.1019158789616532,0.8483415268169803
-0.4,0.1285474187532751,0.7793740343833466
-0.35,0.1514121808522091,0.7180894392915889
-0.3,0.1709667381122778,0.6635973029696931
-0.25,0.1876138195315349,0.6151110834309049
-0.2,0.2017086192776647,0.5719359941568359
-0.15,0.2135643676145546,0.5334582824626334
-0.1,0.2234572501866372,0.4991357609358453
-0.05,0.2316307516671766,0.4684894460491112
0.0,0.2382994912581967,0.4410961739573261
0.05,0.2436526093431671,0.4165820796403826
0.1,0.2478567578901253,0.3946168380297324
0.15,0.2510587408012047,0.374908578643889
0.2,0.2533878453037373,0.3571993942930275
0.25,0.2549579003869804,0.3412613750083937
0.3,0.2558690942928642,0.3268931053396487
0.35,0.2562095791858763,0.3139165711801682
0.4,0.2560568879280668,0.3021744280101404
0.45,0.2554791849172104,0.2915275884475831
0.5,0.2545363704048934,0.2818530917283333

];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=3.0*ones(1,5);
inputs.PEsol.global_theta_min=0.0*ones(1,5);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=3.0*ones(1,3);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,3);
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
inputs.nlpsol.eSS.log_var=1:(3+5); 
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
