addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_9model'; % Folder to keep results
inputs.pathd.short_name='hiv_9';                 % To identify figures and reports
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
inputs.model.par = [0.591, 0.574, 0.653, 0.652, 0.431, 0.897, 0.368, 0.436, 0.892, 0.806];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.704, 0.1, 0.919, 0.714, 0.999];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.7040000000000000 0.9990000000000000 0.7140000000000000 1.0189999999999999
0.6929882365717562 0.9601372608729308 0.6832133035202818 0.9979612751014740
0.6834052765220935 0.9228686267566516 0.6537896108649969 0.9772701700069364
0.6751076343247658 0.8871170230165524 0.6256610412777869 0.9569614537981324
0.6679681365114427 0.8528105781892180 0.5987648980900027 0.9370610839431226
0.6618737627758612 0.8198821064957539 0.5730428907085413 0.9175877450997816
0.6567238102635139 0.7882686577955414 0.5484405244405277 0.8985541287618642
0.6524283277690383 0.7579111250162129 0.5249066186593159 0.8799679992633903
0.6489067759556754 0.7287539000376496 0.5023929229122942 0.8618330827518930
0.6460868775341895 0.7007445707918627 0.4808538081259735 0.8441498091806410
0.6439036276474400 0.6738336540523013 0.4602460159415598 0.8269159322840484
0.6422984396862088 0.6479743584645057 0.4405284526488327 0.8101270475698372
0.6412184060081846 0.6231223738446675 0.4216620178299797 0.7937770252288079
0.6406156563968932 0.5992356833023760 0.4036094600890340 0.7778583719052636
0.6404467998845007 0.5762743950216913 0.3863352538410721 0.7623625327356989
0.6406724378774340 0.5542005913216524 0.3698054927626314 0.7472801433508264
0.6412567384244440 0.5329781926331623 0.3539877962811182 0.7326012397062547
0.6421670630427393 0.5125728348263487 0.3388512266462346 0.7183154326235539
0.6433736388406361 0.4929517579909346 0.3243662142953620 0.7044120524336718
0.6448492697598317 0.4740837055169774 0.3105044900879811 0.6908802685729768
0.6465690817009283 0.4559388320934469 0.2972390230363373 0.6777091879438977
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=3.0*ones(1,10);
inputs.PEsol.global_theta_min=0.0*ones(1,10);
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
