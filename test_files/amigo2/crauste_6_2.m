addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_6model'; % Folder to keep results
inputs.pathd.short_name='crauste_6';                 % To identify figures and reports
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
inputs.model.par = [0.223, 0.953, 0.447, 0.846, 0.699, 0.297, 0.814, 0.397, 0.881, 0.581, 0.882, 0.693, 0.725];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.501, 0.956, 0.644, 0.424, 0.606];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.956,0.501,1.068,0.606
-0.45,0.918997702525576,0.4826743363860077,1.0415241707308736,0.5799717535938796
-0.4,0.883699157454222,0.465533289521001,1.0167227065219675,0.5557819146392063
-0.35,0.8500413721777269,0.4494629421219351,0.9933377357171034,0.5332531413428999
-0.3,0.8179556677309754,0.4343635774140411,0.971161145273336,0.5122291595303838
-0.25,0.7873705025461214,0.4201475502810011,0.9500240944583408,0.4925718281874714
-0.2,0.758213497656869,0.4067375264678756,0.9297889415225882,0.4741586724767664
-0.15,0.730412869685837,0.3940650183043359,0.9103429765027728,0.4568807997673402
-0.1,0.7038984253822519,0.3820691608411259,0.8915935193342291,0.4406411316716828
-0.05,0.678602232239344,0.3706956839930767,0.8734640593281717,0.4253528982648032
0.0,0.654459050344595,0.3598960452174068,0.8558911953315627,0.4109383507575949
0.05,0.6314065898190894,0.3496266946893747,0.8388221967599565,0.3973276574810703
0.1,0.6093856408274733,0.3398484498995712,0.8222130487898354,0.3844579536891266
0.15,0.5883401121841559,0.3305259614385083,0.8060268781909413,0.3722725214768775
0.2,0.5682170048813099,0.3216272548727399,0.7902326798890238,0.3607200798310922
0.25,0.5489663402873113,0.3131233364416144,0.7748042825509867,0.349754168290579
0.3,0.5305410578402968,0.304987852564603,0.7597195052695807,0.33933261050883
0.35,0.5128968929522798,0.2971967947835282,0.7449594675955463,0.3294170460773959
0.4,0.4959922431521747,0.2897282432707938,0.7305080232808742,0.3199725209138557
0.45,0.4797880283998627,0.2825621432174105,0.7163512943124317,0.3109671280682002
0.5,0.4642475496804344,0.275680109271453,0.7024772864266928,0.3023716919509531

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
