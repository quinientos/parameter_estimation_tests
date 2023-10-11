addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_8model'; % Folder to keep results
inputs.pathd.short_name='hiv_8';                 % To identify figures and reports
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
inputs.model.par = [0.725, 0.501, 0.956, 0.644, 0.424, 0.606, 0.019, 0.302, 0.66, 0.29];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.618, 0.429, 0.135, 0.298, 0.57];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.618,0.57,0.298,0.5640000000000001
-0.45,0.6344468847520042,0.561830051431752,0.2883641668168685,0.5592843087076155
-0.4,0.6502411214049713,0.5537758182869709,0.279040884885282,0.5547783216523132
-0.35,0.6654063564155922,0.5458357621833176,0.2700198901987799,0.5504784656646443
-0.3,0.6799659376631607,0.538008357391052,0.2612912732640329,0.5463805214776192
-0.25,0.6939428294638106,0.5302920913430026,0.2528454645845974,0.5424797454061794
-0.2,0.7073595418445672,0.5226854651064846,0.2446732210041803,0.5387709765631938
-0.15,0.7202380726859102,0.5151869937529919,0.2367656127705138,0.5352487309016102
-0.1,0.7325998610874013,0.5077952067631673,0.2291140114036945,0.5319072833956975
-0.05,0.7444657508917145,0.5005086483392474,0.2217100781696876,0.5287407394623455
0.0,0.7558559630970921,0.4933258776642134,0.2145457531499453,0.5257430967294405
0.05,0.7667900759669385,0.4862454691717885,0.2076132449204868,0.5229082981813294
0.1,0.7772870119899007,0.4792660127368043,0.2009050207028689,0.5202302775666404
0.15,0.7873650306542829,0.4723861138715452,0.1944137970310066,0.5177029979517047
0.2,0.797041726388404,0.4656043938185411,0.1881325307904718,0.5153204841516936
0.25,0.806334030676638,0.45891948971446,0.182054410762577,0.5130768498094267
0.3,0.8152582179637351,0.4523300546452648,0.176172849470935,0.510966319692774
0.35,0.8238299145618947,0.4458347577318453,0.17048147543322,0.5089832478379864
0.4,0.8320641102182644,0.4394322841175908,0.1649741256764309,0.5071221320167739
0.45,0.8399751716487899,0.4331213350347297,0.1596448386492688,0.5053776250488498
0.5,0.8475768578629339,0.4269006277787643,0.1544878473593174,0.5037445433244859

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
