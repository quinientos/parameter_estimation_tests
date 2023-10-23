addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_5model'; % Folder to keep results
inputs.pathd.short_name='hiv_5';                 % To identify figures and reports
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
inputs.model.par = [0.039, 0.283, 0.12, 0.296, 0.119, 0.318, 0.414, 0.064, 0.692, 0.567];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.265, 0.523, 0.094, 0.576, 0.929];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.2650000000000000 0.9290000000000000 0.5760000000000000 0.6170000000000000
0.2630638055742518 0.9034170277448248 0.5576087716735664 0.6110477758524425
0.2611534852560530 0.8785315080194906 0.5397770490293610 0.6051384694099151
0.2592688017052001 0.8543247399724077 0.5224894286651477 0.5992720548303532
0.2574095154042207 0.8307785108224894 0.5057308341962096 0.5934484999030303
0.2555753848946476 0.8078750836556652 0.4894865155431141 0.5876677661645805
0.2537661670019825 0.7855971854943878 0.4737420477114040 0.5819298090117312
0.2519816170539867 0.7639279956873644 0.4584833291417091 0.5762345778242507
0.2502214890801972 0.7428511344610664 0.4436965795612327 0.5705820160585066
0.2484855360164458 0.7223506519131481 0.4293683375747561 0.5649720613862552
0.2467735098888876 0.7024110171270609 0.4154854578073462 0.5594046457963898
0.2450851619947442 0.6830171076076450 0.4020351077757797 0.5538796957134816
0.2434202430760702 0.6641541989820188 0.3890047644835051 0.5483971321205060
0.2417785034756124 0.6458079548334391 0.3763822106802908 0.5429568706487146
0.2401596933017593 0.6279644169660298 0.3641555310226782 0.5375588217224746
0.2385635625718022 0.6106099957425770 0.3523131079170308 0.5322028906568552
0.2369898613540330 0.5937314607203247 0.3408436172276646 0.5268889777745484
0.2354383399021624 0.5773159315023187 0.3297360238183563 0.5216169785198225
0.2339087487865808 0.5613508688451243 0.3189795769792248 0.5163867835839193
0.2324008390050308 0.5458240658328674 0.3085638056331562 0.5111982789814878
0.2309143621104715 0.5307236395060240 0.2984785136048698 0.5060513462062050
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
