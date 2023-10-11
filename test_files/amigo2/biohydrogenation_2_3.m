addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='biohydrogenation_2model'; % Folder to keep results
inputs.pathd.short_name='biohydrogenation_2';                 % To identify figures and reports
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
inputs.model.par = [0.979, 0.799, 0.461, 0.781, 0.118, 0.64];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.143, 0.945, 0.522, 0.415];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x4', 'y2 = x5');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
-0.5,0.143,0.945
-0.45,0.1357313696845854,0.9426055913038146
-0.4,0.1287809088123765,0.9399469552499432
-0.35,0.122139162690911,0.9370346989349132
-0.3,0.1157965913656837,0.9338794632164028
-0.25,0.1097436021234495,0.930491890550574
-0.2,0.1039705809104474,0.9268825939746218
-0.15,0.0984679224693221,0.9230621274679296
-0.1,0.0932260589343428,0.9190409578365488
-0.05,0.0882354868582552,0.9148294383640956
0.0,0.0834867923998896,0.9104377842646236
0.05,0.078970674670846,0.9058760500971844
0.1,0.0746779671098452,0.901154109154474
0.15,0.0705996569154245,0.896281634932841
0.2,0.0667269024480861,0.8912680846167957
0.25,0.0630510486598317,0.8861226846145714
0.3,0.0595636405734701,0.8808544181017245
0.35,0.0562564348276164,0.8754720144661883
0.4,0.0531214094283293,0.8699839406941847
0.45,0.0501507717035341,0.8643983944875695
0.5,0.0473369646082133,0.8587232991058275

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



