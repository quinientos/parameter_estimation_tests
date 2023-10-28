addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='crauste_4model'; % Folder to keep results
inputs.pathd.short_name='crauste_4';                 % To identify figures and reports
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
inputs.model.par = [0.977, 0.605, 0.739, 0.039, 0.283, 0.12, 0.296, 0.119, 0.318, 0.414, 0.064, 0.692, 0.567];         % Nominal value for the parameters
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
inputs.exps.obs{1}=char( 'y1 = e', 'y2 = n', 'y3 = s+m', 'y4 = p');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=21;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.5230000000000000 0.2650000000000000 0.6699999999999999 0.9290000000000000
0.5246121114862373 0.2486431477099366 0.6620140117626984 0.9403905507182732
0.5262115584316174 0.2332528645052197 0.6541318007170377 0.9522124676779090
0.5278176516006130 0.2187732821639851 0.6463518656253093 0.9644906683403230
0.5294493505545175 0.2051517108646880 0.6386726618615879 0.9772517239090300
0.5311253607819251 0.1923384610767273 0.6310926026926885 0.9905240283673796
0.5328642341066868 0.1802866751961946 0.6236100602841759 1.0043379858968671
0.5346844731383180 0.1689521683002877 0.6162233663464498 1.0187262193732776
0.5366046406145326 0.1582932778065650 0.6089308125762132 1.0337238026017377
0.5386434747175022 0.1482707213091383 0.6017306507230338 1.0493685200125265
0.5408200115792868 0.1388474622661269 0.5946210923321108 1.0657011577226578
0.5431537164003655 0.1299885831783797 0.5876003081976110 1.0827658305250587
0.5456646248922633 0.1216611657447748 0.5806664274270633 1.1006103504670786
0.5483734969977440 0.1138341777328219 0.5738175361882443 1.1192866432500419
0.5513019852732927 0.1064783660303797 0.5670516759722732 1.1388512204176733
0.5544728206017967 0.0995661558148525 0.5603668415816951 1.1593657157133257
0.5579100185912244 0.0930715552258213 0.5537609785704061 1.1808974969243136
0.5616391104809600 0.0869700654291855 0.5472319802666639 1.2035203655086744
0.5656874032650591 0.0812385956362957 0.5407776841999079 1.2273153596781292
0.5700842745137091 0.0758553829829486 0.5343958680650946 1.2523716786848609
0.5748615087237327 0.0707999168122174 0.5280842449696103 1.2787877511082699
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
