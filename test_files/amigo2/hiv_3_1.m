addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_3model'; % Folder to keep results
inputs.pathd.short_name='hiv_3';                 % To identify figures and reports
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
inputs.model.par = [0.671, 0.21, 0.129, 0.315, 0.364, 0.57, 0.439, 0.988, 0.102, 0.209];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.161, 0.653, 0.253, 0.466, 0.244];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.1610000000000000 0.2440000000000000 0.4660000000000000 0.9060000000000000
0.1924032108003359 0.2479240026386005 0.4583098578824668 0.9006031223592564
0.2234214712478294 0.2516063382147365 0.4510225257023250 0.8951150243016437
0.2540581573461907 0.2550600078460011 0.4441128944102990 0.8895453279187968
0.2843167891888915 0.2582971896385704 0.4375577119151730 0.8839031237549941
0.3142010159106036 0.2613293006909650 0.4313354262350704 0.8781969951886066
0.3437146015254328 0.2641670537366641 0.4254260434317353 0.8724350418762924
0.3728614117364417 0.2668205089505813 0.4198109987810543 0.8666249022582952
0.4016454013406325 0.2692991213485648 0.4144730398912605 0.8607737752156543
0.4300706025710840 0.2716117842297845 0.4093961204867579 0.8548884408301269
0.4581411141227238 0.2737668690117410 0.4045653038272441 0.8489752803142061
0.4858610907925452 0.2757722617904393 0.3999666748072674 0.8430402951450817
0.5132347340964454 0.2776353969544830 0.3955872598151276 0.8370891253432863
0.5402662830849559 0.2793632880675136 0.3914149537125923 0.8311270670798679
0.5669600061235081 0.2809625563209902 0.3874384531184127 0.8251590894671896
0.5933201931030369 0.2824394567391105 0.3836471954690251 0.8191898506657171
0.6193511482597592 0.2837999023481085 0.3800313032748204 0.8132237132862168
0.6450571832822304 0.2850494864727337 0.3765815331224396 0.8072647591784015
0.6704426116112669 0.2861935033697151 0.3732892288530175 0.8013168034159368
0.6955117421840270 0.2872369672545663 0.3701462787593985 0.7953834078961064
0.7202688744158885 0.2881846299492622 0.3671450761933694 0.7894678941602649
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
