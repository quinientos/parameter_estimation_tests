addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='hiv_4model'; % Folder to keep results
inputs.pathd.short_name='hiv_4';                 % To identify figures and reports
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
inputs.model.par = [0.159, 0.11, 0.656, 0.138, 0.197, 0.369, 0.821, 0.097, 0.838, 0.096];         % Nominal value for the parameters
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.976, 0.469, 0.977, 0.605, 0.739];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char( 'y1 = x', 'y2 = z', 'y3 = w', 'y4 = yy+vv');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.9760000000000000 0.7390000000000000 0.6050000000000000 1.4460000000000000
0.9480426515455560 0.7366071030720190 0.5902027283062959 1.4601374925197166
0.9214977206479790 0.7342593654575069 0.5759824507405134 1.4733286869981179
0.8962776928528308 0.7319514990068993 0.5622720371577020 1.4856404386098496
0.8723016492338963 0.7296786901028556 0.5490148150702310 1.4971341331658663
0.8494946813709077 0.7274365477449420 0.5361629269048611 1.5078661961531552
0.8277873655973174 0.7252210598551047 0.5236759623436530 1.5178885486944469
0.8071152899013815 0.7230285562165982 0.5115198143574465 1.5272490165130632
0.7874186274977587 0.7208556767753356 0.4996657181844826 1.5359916973084964
0.7686417520063314 0.7186993443136551 0.4880894409122225 1.5441572911878851
0.7507328894329569 0.7165567406696494 0.4767705955320442 1.5517833983829210
0.7336438034402964 0.7144252859193622 0.4656920588187083 1.5589047876507636
0.7173295098842114 0.7123026199545124 0.4548394757349478 1.5655536387553446
0.7017480179291693 0.7101865860947481 0.4442008367557900 1.5717597616444632
0.6868600945261194 0.7080752163438760 0.4337661164207362 1.5775507949835892
0.6726290505263541 0.7059667181153721 0.4235269641907754 1.5829523859399679
0.6590205455531692 0.7038594621156226 0.4134764393301078 1.5879883534382730
0.6460024102025402 0.7017519712738219 0.4036087836397053 1.5926808364014740
0.6335444836066625 0.6996429105377818 0.3939192264086543 1.5970504285960474
0.6216184650897623 0.6975310774570315 0.3844038171782353 1.6011163013394325
0.6101977783408230 0.6954153934225150 0.3750592822736872 1.6048963153512139
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
