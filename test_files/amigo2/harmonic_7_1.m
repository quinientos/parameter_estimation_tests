addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='harmonic_7model'; % Folder to keep results
inputs.pathd.short_name='harmonic_7';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=2;                                  % Number of states:\\\
inputs.model.n_par=2;                                 % Number of model parameters
inputs.model.st_names=char('x1', 'x2');    % Names of the states
inputs.model.par_names=char('a', 'b');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx1 = -a*x2;',  'dx2 = +x1/b;');               % Equations describing system dynamics.
inputs.model.par = [0.522, 0.415];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.265, 0.774];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x1', 'y2 = x2');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
 0.2650000000000000 0.7740000000000000
 0.2443926383623489 0.8046943473356435
 0.2230169662936314 0.8328589333095483
 0.2009401836759879 0.8584052153573800
 0.1782316944666676 0.8812528822717370
 0.1549628885989788 0.9013301065791278
 0.1312069174680403 0.9185737704309248
 0.1070384640109156 0.9329296639820552
 0.0825335079284650 0.9443526558200042
 0.0577690867628310 0.9528068348741008
 0.0328230537721887 0.9582656232791984
 0.0077738331754809 0.9607118599437796
-0.0172998264496044 0.9601378545022728
-0.0423190996724358 0.9565454114853452
-0.0672053320512143 0.9499458246486644
-0.0918802873448492 0.9403598414859946
-0.1162663935996235 0.9278175979580524
-0.1402869868742052 0.9123585238011240
-0.1638665523352547 0.8940312185370330
-0.1869309615702516 0.8728932987550221
-0.2094077057975384 0.8490112168352922
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,2);
inputs.PEsol.global_theta_min=0.0*ones(1,2);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,2);                % Maximum allowed values for the initial conditions
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
inputs.nlpsol.eSS.log_var=1:(2+2); 
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
