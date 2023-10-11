addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_1model'; % Folder to keep results
inputs.pathd.short_name='hiv_1';                 % To identify figures and reports
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
inputs.model.par = [0.087, 0.02, 0.833, 0.778, 0.87, 0.979, 0.799, 0.461, 0.781, 0.118];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.64, 0.143, 0.945, 0.522, 0.415];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.6400000000000000 0.4150000000000000 0.5220000000000000 1.0880000000000001
0.6194510346163841 0.4139914217025308 0.5025235691691526 1.0676700589383914
0.6006294509343023 0.4130904768720049 0.4837653239654964 1.0475402486694392
0.5833536895157547 0.4122673858234847 0.4656867691964925 1.0276596166659471
0.5674658074953156 0.4114973584202519 0.4482555899774831 1.0080650557155315
0.5528278962190049 0.4107598232354127 0.4314440773879425 0.9887837525215104
0.5393191143749804 0.4100377827084318 0.4152279602641305 0.9698351491286212
0.5268332194247957 0.4093172708167447 0.3995855388224894 0.9512325180772648
0.5152765041653536 0.4085868949097906 0.3844970430033722 0.9329842296333766
0.5045660642887142 0.4078374471925230 0.3699441584264412 0.9150947725393930
0.4946283382123445 0.4070615742876876 0.3559096782184477 0.8975655776819030
0.4853978710955423 0.4062534954738335 0.3423772484524906 0.8803956825107542
0.4768162649403518 0.4054087619751323 0.3293311839304543 0.8635822674747098
0.4688312834159557 0.4045240510036331 0.3167563362764017 0.8471210887856435
0.4613960860228520 0.4035969893476047 0.3046380010078778 0.8310068273350026
0.4544685706262915 0.4026260021432417 0.2929618532502130 0.8152333693478746
0.4480108074000841 0.4016101832023864 0.2817139047458858 0.7997940319581136
0.4419885498208029 0.4005491837955712 0.2708804760762203 0.7846817436368907
0.4363708110468217 0.3994431172887043 0.2604481798614442 0.7698891880064699
0.4311294959419621 0.3982924774233439 0.2504039117422859 0.7554089179554568
0.4262390805059891 0.3970980683342768 0.2407348465663594 0.7412334454189331
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,10);
inputs.PEsol.global_theta_min=0.0*ones(1,10);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,5);                % Maximum allowed values for the initial conditions
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
