addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_9model'; % Folder to keep results
inputs.pathd.short_name='crauste_9';                 % To identify figures and reports
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
inputs.model.par = [0.722, 0.866, 0.976, 0.856, 0.012, 0.36, 0.73, 0.172, 0.521, 0.054, 0.2, 0.019, 0.794];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.224, 0.345, 0.928, 0.704, 0.032];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.3450000000000000 0.2240000000000000 1.6319999999999999 0.0320000000000000
0.3391993767955259 0.2158810839046470 1.5843547527923141 0.0308384441249756
0.3335687843266553 0.2080625680072998 1.5416784237984906 0.0297375681164430
0.3281012134195507 0.2005328165640156 1.5032731732592506 0.0286924866881711
0.3227900113248058 0.1932806961812397 1.4685633648736878 0.0276988979543085
0.3176288621804975 0.1862955480223208 1.4370701437560305 0.0267529895601733
0.3126117682084204 0.1795671623575792 1.4083920849498963 0.0258513635065542
0.3077330317848387 0.1730857551981121 1.3821902893499758 0.0249909753168738
0.3029872384123374 0.1668419467220614 1.3581767807946727 0.0241690843322386
0.2983692406168594 0.1608267412899869 1.3361053834742802 0.0233832127395208
0.2938741427166668 0.1550315088103808 1.3157644835393087 0.0226311115140574
0.2894972865207925 0.1494479674093295 1.2969712373840785 0.0219107319072081
0.2852342378370671 0.1440681671618300 1.2795669006774664 0.0212202013955750
0.2810807738141099 0.1388844748566030 1.2634130339133671 0.0205578032696171
0.2770328710511088 0.1338895596676217 1.2483883988646318 0.0199219592021878
0.2730866944304235 0.1290763796482878 1.2343864039218559 0.0193112142768620
0.2692385866523308 0.1244381690039406 1.2213129887248673 0.0187242240637039
0.2654850584056558 0.1199684260502438 1.2090848626328290 0.0181597434037340
0.2618227791619897 0.1156609018363905 1.1976280301772395 0.0176166166346897
0.2582485685067532 0.1115095893274120 1.1868765504506191 0.0170937690289511
0.2547593880491722 0.1075087131952737 1.1767714886290941 0.0165901992730743
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,13);
inputs.PEsol.global_theta_min=0.0*ones(1,13);
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
