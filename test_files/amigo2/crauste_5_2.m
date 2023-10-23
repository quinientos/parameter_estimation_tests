addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_5model'; % Folder to keep results
inputs.pathd.short_name='crauste_5';                 % To identify figures and reports
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
inputs.model.par = [0.319, 0.667, 0.132, 0.716, 0.289, 0.183, 0.587, 0.02, 0.829, 0.005, 0.678, 0.27, 0.735];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.962, 0.249, 0.576, 0.592, 0.572];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.2490000000000000 0.9620000000000000 1.1679999999999999 0.5720000000000000
0.2710935559667405 0.9245525380674944 1.1473066744314171 0.5741294532212323
0.2921677192113705 0.8884898598069541 1.1276106192952744 0.5759610487592818
0.3122202878427073 0.8537741746602887 1.1087982399830381 0.5775017591862224
0.3312539026328173 0.8203673688603996 1.0907724009474402 0.5787593741547062
0.3492756741252726 0.7882311375610338 1.0734497312858458 0.5797423834754525
0.3662967915169678 0.7573271118109517 1.0567584227110136 0.5804598637243602
0.3823321212747271 0.7276169795709996 1.0406364204190015 0.5809213695134504
0.3973998029804567 0.6990625996402062 1.0250299292127432 0.5811368303891122
0.4115208490157654 0.6716261075691252 1.0098921740269022 0.5811164541128390
0.4247187533516803 0.6452700136613433 0.9951823672798756 0.5808706368799544
0.4370191144146882 0.6199572921845660 0.9808648447280895 0.5804098808634695
0.4484492757726015 0.5956514616555475 0.9669083394645186 0.5797447192803478
0.4590379872694995 0.5723166567861665 0.9532853700204408 0.5788856490482998
0.4688150890850522 0.5499176915049794 0.9399717224982660 0.5778430709481219
0.4778112199376935 0.5284201136585454 0.9269460109836092 0.5766272371066649
0.4860575502124462 0.5077902517207555 0.9141893032438666 0.5752482055279625
0.4935855403108558 0.4879952537347166 0.9016848009710670 0.5737158013138134
0.5004267239189983 0.4690031190988765 0.8894175659277386 0.5720395841811527
0.5066125156723548 0.4507827234218174 0.8773742846163601 0.5702288218145363
0.5121740421670140 0.4333038373109819 0.8655430657313041 0.5682924686220036
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
