addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='biohydrogenation_9model'; % Folder to keep results
inputs.pathd.short_name='biohydrogenation_9';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=4;                                  % Number of states:\\\
inputs.model.n_par=6;                                 % Number of model parameters
inputs.model.st_names=char('x4', 'x5', 'x6', 'x7');    % Names of the states
inputs.model.par_names=char('k5', 'k6', 'k7', 'k8', 'k9', 'k10');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char( 'dx4 = - k5 * x4 / (k6 + x4);',  'dx5 = k5 * x4 / (k6 + x4) - k7 * x5/(k8 + x5 + x6);',  'dx6 = k7 * x5 / (k8 + x5 + x6) - k9 * x6 * (k10 - x6) / k10;',  'dx7 = k9 * x6 * (k10 - x6) / k10;');               % Equations describing system dynamics.
inputs.model.par = [0.725, 0.501, 0.956, 0.644, 0.424, 0.606];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.019, 0.302, 0.66, 0.29];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x4', 'y2 = x5');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.0190000000000000 0.3020000000000000
0.0177190524673077 0.2944129178141688
0.0165217070141328 0.2869803119922270
0.0154028573789237 0.2797028602890051
0.0143576651851319 0.2725809674430943
0.0133815514410504 0.2656147781146262
0.0124701875591116 0.2588041904069048
0.0116194860195699 0.2521488697694320
0.0108255908005511 0.2456482631822629
0.0100848676680041 0.2393016134256341
0.0093938944194080 0.2331079733614782
0.0087494511516636 0.2270662200672580
0.0081485106280742 0.2211750688214752
0.0075882287894399 0.2154330867719676
0.0070659354625085 0.2098387062999478
0.0065791252971240 0.2043902379569723
0.0061254489706258 0.1990858830345119
0.0057027046746447 0.1939237456344646
0.0053088299061489 0.1889018442823527
0.0049418935764521 0.1840181230700507
0.0046000884390352 0.1792704622334017
];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta=char('k5', 'k6', 'k7');
inputs.PEsol.global_theta_max=3.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0*ones(1,3);
inputs.PEsol.id_global_theta_y0=char('x4', 'x5', 'x7');               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=3.0*ones(1,3);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,3)

inputs.PEsol.id_local_theta{1}=char('k8', 'k9', 'k10');                % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_max{1}=3.0*ones(1,3);              % Maximum allowed values for the paramters
inputs.PEsol.local_theta_min{1}=0.0*ones(1,3)              % Minimum allowed values for the parameters
inputs.PEsol.local_theta_guess{1}=[];            % [] Initial guess
inputs.PEsol.id_local_theta_y0{1}=char('x6');             % [] 'all'|User selected| 'none' (default)
inputs.PEsol.local_theta_y0_max{1}=3.0*ones(1,1);           % Maximum allowed values for the initial conditions
inputs.PEsol.local_theta_y0_min{1}=0.0*ones(1,1);           % Minimum allowed values for the initial conditions
inputs.PEsol.local_theta_y0_guess{1}=[];         % [] Initial guess

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
inputs.nlpsol.eSS.log_var=1:(4+6); 
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

%val names
inputs.model.par_names
inputs.model.st_names
%true vals:
inputs.model.par
inputs.exps.exp_y0{1}



