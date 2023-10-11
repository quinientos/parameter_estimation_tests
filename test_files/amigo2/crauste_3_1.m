addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_3model'; % Folder to keep results
inputs.pathd.short_name='crauste_3';                 % To identify figures and reports
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
inputs.model.par = [0.209, 0.161, 0.653, 0.253, 0.466, 0.244, 0.159, 0.11, 0.656, 0.138, 0.197, 0.369, 0.821];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.097, 0.838, 0.096, 0.976, 0.469];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.8380000000000000 0.0970000000000000 1.0720000000000001 0.4690000000000000
0.8353043013953576 0.0945263608470095 1.0474687858095515 0.4689437581549238
0.8326017271566372 0.0921159477896987 1.0235089911557016 0.4689041968276328
0.8298935109512876 0.0897670918619475 1.0001068330969072 0.4688813955347772
0.8271808412156622 0.0874781704655005 0.9772488852883168 0.4688754427411246
0.8244648628932517 0.0852476059859851 0.9549220674491312 0.4688864358011004
0.8217466791116541 0.0830738644532061 0.9331136352001248 0.4689144809170114
0.8190273528071831 0.0809554542493452 0.9118111703069652 0.4689596931134421
0.8163079082808000 0.0788909248489383 0.8910025711668229 0.4690221962277173
0.8135893327212725 0.0768788656153487 0.8706760437866881 0.4691021229155151
0.8108725776612443 0.0749179046239437 0.8508200929540239 0.4691996146719563
0.8081585603910058 0.0730067075282899 0.8314235137638090 0.4693148218675336
0.8054481653246446 0.0711439764622604 0.8124753834314667 0.4694479037987832
0.8027422453175911 0.0693284489750049 0.7939650533609187 0.4695990287537577
0.8000416229607462 0.0675588970130910 0.7758821416148380 0.4697683740908362
0.7973470917751392 0.0658341258968223 0.7582165252474882 0.4699561263353222
0.7946594174524579 0.0641529733852076 0.7409583334650849 0.4701624812854763
0.7919793389872430 0.0625143087247655 0.7240979405455595 0.4703876441370447
0.7893075698015846 0.0609170317471761 0.7076259591823122 0.4706318296206042
0.7866447988297182 0.0593600719919843 0.6915332340105234 0.4708952621537798
0.7839916915737867 0.0578423878594698 0.6758108353700601 0.4711781760076793
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
