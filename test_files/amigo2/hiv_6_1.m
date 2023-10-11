addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_6model'; % Folder to keep results
inputs.pathd.short_name='hiv_6';                 % To identify figures and reports
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
inputs.model.par = [0.319, 0.667, 0.132, 0.716, 0.289, 0.183, 0.587, 0.02, 0.829, 0.005];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.678, 0.27, 0.735, 0.962, 0.249];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.6780000000000000 0.2490000000000000 0.9620000000000000 1.0049999999999999
0.6682436058673923 0.2490857299348792 0.9276731148078926 0.9958496040570760
0.6588652087113657 0.2491628231362562 0.8943991390287993 0.9867992966972872
0.6498505626436155 0.2492317674311493 0.8621608573218044 0.9778480755538204
0.6411859530325303 0.2492930255581878 0.8309398047177173 0.9689949295369904
0.6328581773883137 0.2493470361574791 0.8007164641737308 0.9602388397588862
0.6248545268848247 0.2493942147591057 0.7714704458457253 0.9515787804832172
0.6171627683946547 0.2494349547649173 0.7431806490092074 0.9430137199754464
0.6097711272574051 0.2494696284171481 0.7158254087518914 0.9345426214987316
0.6026682705147721 0.2494985877512168 0.6893826277233003 0.9261644441825272
0.5958432907846251 0.2495221655281628 0.6638298947616950 0.9178781439633108
0.5892856905714883 0.2495406761447378 0.6391445907721712 0.9096826743762876
0.5829853672656808 0.2495544165178702 0.6153039838554893 0.9015769875127730
0.5769325985361918 0.2495636669428244 0.5922853135825907 0.8935600348063605
0.5711180282884387 0.2495686919230611 0.5700658659856790 0.8856307678688347
0.5655326530677132 0.2495697409711359 0.5486230396891671 0.8777881392415799
0.5601678089919477 0.2495670493799197 0.5279344043131080 0.8700311031929404
0.5550151591004500 0.2495608389639050 0.5079777514752124 0.8623586164250611
0.5500666811682098 0.2495513187704631 0.4887311392860911 0.8547696387759831
0.5453146559579587 0.2495386857612147 0.4701729308875713 0.8472631338987470
0.5407516558646320 0.2495231254637162 0.4522818274661301 0.8398380698658923
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
