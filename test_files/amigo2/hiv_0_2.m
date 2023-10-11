addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_0model'; % Folder to keep results
inputs.pathd.short_name='hiv_0';                 % To identify figures and reports
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
inputs.model.par = [0.549, 0.715, 0.603, 0.545, 0.424, 0.646, 0.438, 0.892, 0.964, 0.383];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.792, 0.529, 0.568, 0.926, 0.071];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.792,0.071,0.926,1.097
-0.45,0.7780294880922031,0.0788918315014627,0.8813326204189005,1.0889290946814865
-0.4,0.7649339984222395,0.0861672926556271,0.8386912425827011,1.080697984738626
-0.35,0.7526591404332574,0.0928549743752981,0.7979997663455514,1.0723266565498366
-0.3,0.7411542860662798,0.0989832855218319,0.7591831839360883,1.0638334316580875
-0.25,0.7303722720710166,0.1045802711194966,0.7221677640114856,1.0552351174867334
-0.2,0.7202691296584153,0.1096734636962922,0.6868812151810059,1.0465471423001929
-0.15,0.7108038384319175,0.114289763436894,0.6532528277747028,1.0377836761473649
-0.1,0.701938102383461,0.1184553430842588,0.6212135951240134,1.0289577396981544
-0.05,0.693636145358434,0.1221955743306365,0.5906963138013162,1.0200813021107615
0.0,0.6858645241806381,0.1255349725729359,0.5616356644393408,1.0111653693019793
0.05,0.6785919576895552,0.1284971573634336,0.5339682744507382,1.0022200637287058
0.1,0.6717891700544845,0.1311048262459434,0.507632763778087,0.9932546965404738
0.15,0.6654287470607362,0.1333797398880065,0.4825697754645409,0.9842778330222094
0.2,0.6594850040374176,0.1353427167497653,0.4587219921706451,0.9752973519220912
0.25,0.6539338644856355,0.1370136356626686,0.4360341407374186,0.9663204995161688
0.3,0.6487527482677392,0.1384114450115273,0.4144529856086865,0.9573539387534422
0.35,0.6439204685911114,0.1395541772948073,0.3939273129125883,0.9484037941330592
0.4,0.6394171369302379,0.1404589680583854,0.374407906188352,0.9394756926348932
0.45,0.6352240752640206,0.1411420782962213,0.3558475152903717,0.9305748012387154
0.5,0.6313237349157584,0.1416189195759924,0.3382008192256724,0.9217058612331596

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
