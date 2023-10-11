addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='daisy-mamil3_2model'; % Folder to keep results
inputs.pathd.short_name='daisy-mamil3_2';                 % To identify figures and reports
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
inputs.model.par = [0.02, 0.833, 0.778, 0.87, 0.979];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.799, 0.461, 0.781];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x2', 'y2 = x1');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.461,0.799
-0.45,0.4902655278457863,0.7316045056350066
-0.4,0.5170465908209179,0.6725026411318582
-0.35,0.5416458168449964,0.6205742681484856
-0.3,0.5643250486538048,0.574853275715068
-0.25,0.5853109498533206,0.5345063314569451
-0.2,0.6047998376663413,0.4988145658468898
-0.15,0.6229618490702313,0.4671577846707092
-0.1,0.6399445323748628,0.4390008606154567
-0.05,0.6558759435407413,0.4138820031732144
0.0,0.6708673155624498,0.391402647615615
0.05,0.6850153599059144,0.3712187394286887
0.1,0.6984042506960101,0.3530332217079744
0.15,0.7111073355459571,0.3365895592846085
0.2,0.723188610631828,0.3216661566502883
0.25,0.7347039926691511,0.3080715461182401
0.3,0.7457024157101103,0.2956402400496019
0.35,0.756226777016585,0.2842291553596601
0.4,0.7663147527813238,0.2737145313790553
0.45,0.7759995016611113,0.2639892729531995
0.5,0.785310271656302,0.2549606600218896

];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=2.0*ones(1,5);
inputs.PEsol.global_theta_min=0.0*ones(1,5);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=2.0*ones(1,3);                % Maximum allowed values for the initial conditions
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
