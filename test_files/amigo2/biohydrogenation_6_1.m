addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='biohydrogenation_6model'; % Folder to keep results
inputs.pathd.short_name='biohydrogenation_6';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=4;                                  % Number of states:\\\
inputs.model.n_par=6;                                 % Number of model parameters
inputs.model.st_names=char('x4', 'x5', 'x6', 'x7');    % Names of the states
inputs.model.par_names=char('k5', 'k6', 'k7', 'k8', 'k9', 'k10');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx4 = - k5 * x4 / (k6 + x4);',  'dx5 = k5 * x4 / (k6 + x4) - k7 * x5/(k8 + x5 + x6);',  'dx6 = k7 * x5 / (k8 + x5 + x6) - k9 * x6 * (k10 - x6) / k10;',  'dx7 = k9 * x6 * (k10 - x6) / k10;');               % Equations describing system dynamics.
inputs.model.par = [0.159, 0.11, 0.656, 0.138, 0.197, 0.369];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.821, 0.097, 0.838, 0.096];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x4', 'y2 = x5');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.8210000000000000 0.0970000000000000
0.8139928658570800 0.1010053681938020
0.8069929055573946 0.1049343352437539
0.8000002215352074 0.1087926076417847
0.7930149183051617 0.1125856232093319
0.7860371025259449 0.1163185740332265
0.7790668830642622 0.1199964278144430
0.7721043710232933 0.1236239478138700
0.7651496798331128 0.1272057114943480
0.7582029252931047 0.1307461280544372
0.7512642256578337 0.1342494549318748
0.7443337016585455 0.1377198134477107
0.7374114766159725 0.1411612036193806
0.7304976764844978 0.1445775183234347
0.7235924299412938 0.1479725568439506
0.7166958684300510 0.1513500379400256
0.7098081262691643 0.1547136124618397
0.7029293407135997 0.1580668756506802
0.6960596520358202 0.1614133791679368
0.6891992036324334 0.1647566429264415
0.6823481420590989 0.1681001668476349
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta=char('k5', 'k6', 'k7');
inputs.PEsol.global_theta_max=1.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0*ones(1,3);
inputs.PEsol.id_global_theta_y0=char('x4', 'x5', 'x7');               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,3);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,3)

inputs.PEsol.id_local_theta{1}=char('k8', 'k9', 'k10');                % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_max{1}=1.0*ones(1,3);              % Maximum allowed values for the paramters
inputs.PEsol.local_theta_min{1}=0.0*ones(1,3)              % Minimum allowed values for the parameters
inputs.PEsol.local_theta_guess{1}=[];            % [] Initial guess
inputs.PEsol.id_local_theta_y0{1}=char('x6');             % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_y0_max{1}=1.0*ones(1,1);           % Maximum allowed values for the initial conditions
inputs.PEsol.local_theta_y0_min{1}=0.0*ones(1,1);           % Minimum allowed values for the initial conditions
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
inputs.nlpsol.eSS.log_var=1:(4+6); 
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



