addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='daisy_mamil4_0model'; % Folder to keep results
inputs.pathd.short_name='daisy_mamil4_0';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=4;                                  % Number of states:\\\
inputs.model.n_par=7;                                 % Number of model parameters
inputs.model.st_names=char('x1', 'x2', 'x3', 'x4');    % Names of the states
inputs.model.par_names=char('k01', 'k12', 'k13', 'k14', 'k21', 'k31', 'k41');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx1 = -k01 * x1 + k12 * x2 + k13 * x3 + k14 * x4 - k21 * x1 - k31 * x1 - k41 * x1;',  'dx2 = -k12 * x2 + k21 * x1;',  'dx3 = -k13 * x3 + k31 * x1;',  'dx4 = -k14 * x4 + k41 * x1;');               % Equations describing system dynamics.
inputs.model.par = [0.549, 0.715, 0.603, 0.545, 0.424, 0.646, 0.438];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.892, 0.964, 0.383, 0.792];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=3;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x1', 'y2 = x2', 'y3 = x3 + x4');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.8920000000000000 0.9640000000000000 1.1750000000000000
0.8689986045361567 0.9484772802450392 1.1893595555640182
0.8481138969889539 0.9330433050866636 1.2021154169280588
0.8291000731689068 0.9177364103936396 1.2134203941424939
0.8117405367229960 0.9025887790851794 1.2234105802880983
0.7958444159353758 0.8876272282775410 1.2322072946694442
0.7812434962032677 0.8728739006233787 1.2399187958199285
0.7677895186710765 0.8583468714237459 1.2466417916755212
0.7553518012934985 0.8440606816219215 1.2524627710885610
0.7438151438065008 0.8300268055553977 1.2574591779712507
0.7330779827358690 0.8162540613345224 1.2617004467927553
0.7230507666068693 0.8027489707701402 1.2652489159288889
0.7136545249692405 0.7895160748014255 1.2681606334346445
0.7048196082816880 0.7765582100121174 1.2704860679674890
0.6964845780584786 0.7638767506810840 1.2722707362139625
0.6885952294817576 0.7514718207016076 1.2735557566927027
0.6811037306066550 0.7393424789316553 1.2743783387012473
0.6739678642355444 0.7274868811924482 1.2747722141087894
0.6671503602458725 0.7159024217858245 1.2747680187686581
0.6606183075399638 0.7045858569747652 1.2743936295348330
0.6543426361086432 0.6935334126111268 1.2736744621421925
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=3.0*ones(1,7);
inputs.PEsol.global_theta_min=0.0*ones(1,7);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=3.0*ones(1,4);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,4);
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
inputs.nlpsol.eSS.log_var=1:(4+7); 
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
