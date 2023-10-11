addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_7model'; % Folder to keep results
inputs.pathd.short_name='hiv_7';                 % To identify figures and reports
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
inputs.model.par = [0.576, 0.592, 0.572, 0.223, 0.953, 0.447, 0.846, 0.699, 0.297, 0.814];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.397, 0.881, 0.581, 0.882, 0.693];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.397,0.693,0.882,1.462
-0.45,0.4070507976671185,0.6875449900434685,0.8594532416957784,1.487641747687825
-0.4,0.4163190913430392,0.6816785408941628,0.8378112294834879,1.5130511398592428
-0.35,0.4248351902983626,0.6754549891124916,0.8170044362413206,1.5382560664720268
-0.3,0.4326297849605803,0.6689233806415323,0.7969699251714798,1.5632817176579454
-0.25,0.4397337306161231,0.6621279356539159,0.7776506845460771,1.588150790146211
-0.2,0.4461778562748118,0.6551084731385807,0.7589950335466701,1.6128836822356776
-0.15,0.4519927972524973,0.6479007988165298,0.7409560912073019,1.637498677644119
-0.1,0.4572088495920699,0.6405370599850898,0.7234913022850474,1.6620121173814957
-0.05,0.4618558449156079,0.6330460700724739,0.7065620132229596,1.6864385607003736
0.0,0.4659630439574468,0.6254536056885093,0.6901330929161812,1.710790935150142
0.05,0.4695590471015272,0.6177826787371707,0.674172593583606,1.7350806757568014
0.1,0.4726717204604733,0.6100537856430942,0.658651446967277,1.7593178542935497
0.15,0.4753281359366699,0.6022851357522495,0.6435431920912705,1.7835112989040505
0.2,0.4775545238320339,0.5944928607474868,0.6288237311401295,1.8076687044756845
0.25,0.4793762366882968,0.586691206629832,0.6144711101872664,1.8317967345268085
0.3,0.4808177230818688,0.578892709804814,0.6004653221200935,1.855901114942295
0.35,0.4819025102183434,0.5711083585339622,0.5867881291676208,1.8799867203062088
0.4,0.4826531942317416,0.5633477410689136,0.5734229030307847,1.9040576530239144
0.45,0.4830914372149676,0.5556191814553694,0.5603544804844119,1.928117316068659
0.5,0.4832379700714384,0.5479298640894509,0.5475690328707251,1.952168479588898

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
