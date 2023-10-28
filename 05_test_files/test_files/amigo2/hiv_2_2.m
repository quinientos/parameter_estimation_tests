addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_2model'; % Folder to keep results
inputs.pathd.short_name='hiv_2';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=5;                                  % Number of states:\\\
inputs.model.n_par=10;                                 % Number of model parameters
inputs.model.st_names=char('x', 'yy', 'vv', 'w', 'z');    % Names of the states
inputs.model.par_names=char('lm', 'd', 'beta', 'a', 'k', 'uu', 'c', 'q', 'b', 'h');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx = lm - d * x - beta * x * vv;',  'dyy = beta * x * vv - a * yy;',  'dvv = k * yy - uu * vv;',  'dw = c * x * yy * w - c * q * yy * w - b * w;',  'dz = c * q * yy * w - h * z;');               % Equations describing system dynamics.
inputs.model.par = [0.265, 0.774, 0.456, 0.568, 0.019, 0.618, 0.612, 0.617, 0.944, 0.682];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.36, 0.437, 0.698, 0.06, 0.667];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.3600000000000000 0.6670000000000000 0.0600000000000000 1.1350000000000000
0.3538441547554242 0.6451096004429121 0.0570365899197753 1.1074463169962241
0.3481738772354789 0.6239228452185270 0.0542182722598152 1.0804551961053892
0.3429537772372985 0.6034179204696893 0.0515384659982058 1.0540263565555548
0.3381512781259355 0.5835736653113588 0.0489907963347818 1.0281581107590685
0.3337363657963674 0.5643695490251085 0.0465691029632747 1.0028475454916386
0.3296813624240799 0.5457856499787089 0.0442674454780199 0.9780906828781328
0.3259607223249116 0.5278026359443719 0.0420801063267476 0.9538826233585872
0.3225508476156917 0.5104017458212052 0.0400015917133612 0.9302176729305910
0.3194299215348133 0.4935647723346871 0.0380266307549103 0.9070894561091388
0.3165777576209562 0.4772740457903901 0.0361501732158997 0.8844910164749403
0.3139756630488879 0.4615124184292199 0.0343673860412657 0.8624149057465519
0.3116063147555151 0.4462632497856468 0.0326736489724086 0.8408532633018913
0.3094536469659530 0.4315103924312775 0.0310645493812448 0.8197978865027377
0.3075027490245178 0.4172381783647095 0.0295358765290274 0.7992402932474396
0.3057397724883737 0.4034314059183587 0.0280836153868828 0.7791717775151552
0.3041518465355629 0.3900753269001293 0.0267039401163536 0.7595834583253832
0.3027270009380842 0.3771556344470032 0.0253932073698594 0.7404663235373019
0.3014540957880140 0.3646584509674314 0.0241479494363861 0.7218112682399773
0.3003227573718089 0.3525703165211843 0.0229648673454146 0.7036091288127189
0.2993233195933283 0.3408781775400589 0.0218408239825512 0.6858507130310352
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=2.0*ones(1,10);
inputs.PEsol.global_theta_min=0.0*ones(1,10);
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
inputs.nlpsol.eSS.log_var=1:(5+10); 
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
