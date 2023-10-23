addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_8model'; % Folder to keep results
inputs.pathd.short_name='crauste_8';                 % To identify figures and reports
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
inputs.model.par = [0.806, 0.704, 0.1, 0.919, 0.714, 0.999, 0.149, 0.868, 0.162, 0.616, 0.124, 0.848, 0.807];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.569, 0.407, 0.069, 0.697, 0.454];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.4070000000000000 0.5690000000000000 0.7660000000000000 0.4540000000000000
0.3985023589263708 0.5445565647040158 0.7433309931234436 0.4370724868974051
0.3899078029749174 0.5212339171351652 0.7215376721135943 0.4204936593244612
0.3812441045717329 0.4989764216505845 0.7005907364096809 0.4042777410613619
0.3725370416477886 0.4777313786770844 0.6804619200392089 0.3884371656858828
0.3638104553327607 0.4574488700130801 0.6611239545859375 0.3729826030945600
0.3550863129148638 0.4380816114491500 0.6425505334522592 0.3579229979215590
0.3463847751792638 0.4195848123138744 0.6247162772416479 0.3432656185714279
0.3377242674749741 0.4019160420128355 0.6075967005252623 0.3290161158697726
0.3291215535944956 0.3850351029545204 0.5911681796080659 0.3151785897739676
0.3205918118843454 0.3689039099181181 0.5754079215406784 0.3017556630849483
0.3121487127116857 0.3534863752301826 0.5602939339552394 0.2887485605602369
0.3038044969702878 0.3387483001305901 0.5458049962866901 0.2761571926898616
0.2955700547070889 0.3246572714497634 0.5319206317127079 0.2639802424117948
0.2874550035541613 0.3111825637983931 0.5186210801943971 0.2522152539977536
0.2794677663257823 0.2982950467688765 0.5058872723114211 0.2408587228323100
0.2716156475353314 0.2859670972538025 0.4937008041786733 0.2299061854137066
0.2639049082381732 0.2741725163144626 0.4820439130649935 0.2193523084124603
0.2563408389998290 0.2628864506163467 0.4708994539082503 0.2091909762266330
0.2489278306955856 0.2520853182040072 0.4602508766754400 0.1994153763559539
0.2416694427480785 0.2417467381871102 0.4500822043154756 0.1900180818275342
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
