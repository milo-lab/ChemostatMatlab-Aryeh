
function [ParamVarStruct,calculatedVals,graphDataStruct] = MTO_getAllDataStructs()
ParamVarStruct = getParamVarStruct();
calculatedVals = getCalulatedValsStruct();
graphDataStruct = getGraphDataStruct();
end

function [ParamVarStruct] = getParamVarStruct()
ParamVarStruct = struct('Title',{},'ColorGroup',0);

ind = 0;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dilution Parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Refrence Dilution Parameter';
ParamVarStruct(ind).UnitText = 'D [1/h]  (Ref. Monod)';
ParamVarStruct(ind).INDX = 'D'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 2;
ParamVarStruct(ind).MinMaxVal = [0 0.3];
ParamVarStruct(ind).ValRes = [1];
ParamVarStruct(ind).ColorGroup = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Number of Mutations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Number of Mutations';
ParamVarStruct(ind).UnitText = 'Mut_# [h]';
ParamVarStruct(ind).INDX = 'n_mut'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0;
ParamVarStruct(ind).MinMaxVal = [0 10];
ParamVarStruct(ind).ValRes = [1];
ParamVarStruct(ind).ColorGroup = 0;

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% nIterations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% ParamVarStruct(ind).Title = 'Number of Iterations';
% ParamVarStruct(ind).UnitText = 'Iter_n [h]';
% ParamVarStruct(ind).INDX = 'iter'; %LOWERCASE
% ParamVarStruct(ind).DefaultVal = 10;
% ParamVarStruct(ind).MinMaxVal = [1 50];
% ParamVarStruct(ind).ValRes = [1];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Added Molecule concentration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Added Molecule concentration';
ParamVarStruct(ind).UnitText = 'S_d [g/L]';
ParamVarStruct(ind).INDX = 'sd'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 2;
ParamVarStruct(ind).MinMaxVal = [0 20];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Molecule concentration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Initial Molecule concentration';
ParamVarStruct(ind).UnitText = 'S_{init} [g/L]';
ParamVarStruct(ind).INDX = 'si'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.01;
ParamVarStruct(ind).MinMaxVal = [0 20];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TANK VOLUME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Tank Volume';% - Vt [m^3]';
ParamVarStruct(ind).UnitText = 'V_t [L]';
ParamVarStruct(ind).INDX = 'vt'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 1;
ParamVarStruct(ind).MinMaxVal = [0.00001 2];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 3;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Cell Concentration #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Initial Cell Concentration';
ParamVarStruct(ind).UnitText = 'X_i_n_i_t#1 [g/L]';
ParamVarStruct(ind).INDX = 'X_init1'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.01;
ParamVarStruct(ind).MinMaxVal = [0 1];
ParamVarStruct(ind).ValRes = [1];
ParamVarStruct(ind).ColorGroup = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Yield #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Yield - Cell/Element ratio';
ParamVarStruct(ind).UnitText = 'y_l_d#1';
ParamVarStruct(ind).INDX = 'yld1'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.5;
ParamVarStruct(ind).MinMaxVal = [0 5];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Monod relation parameter 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Monod relation parameter';
ParamVarStruct(ind).UnitText = 'K_{m1} [g/L]';
ParamVarStruct(ind).INDX = 'k1'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.5;
ParamVarStruct(ind).MinMaxVal = [0 0.01];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Maximal growth rate #1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Maximal growth rate';
ParamVarStruct(ind).UnitText = '\mu1_{max} [1/h]';
ParamVarStruct(ind).INDX = 'mu1'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.3;
ParamVarStruct(ind).MinMaxVal = [0.01 2];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Displacement Pulse Volume %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Dilution Pulse Volume';% - Vd [m^3]';
ParamVarStruct(ind).UnitText = 'V_d [L]';
ParamVarStruct(ind).INDX = 'vd'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.1;
ParamVarStruct(ind).MinMaxVal = [0.00001 1];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 3;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Cell Concentration #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Initial Cell Concentration';
ParamVarStruct(ind).UnitText = 'X_i_n_i_t#2 [g/L]';
ParamVarStruct(ind).INDX = 'X_init2'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.01;
ParamVarStruct(ind).MinMaxVal = [0 1];
ParamVarStruct(ind).ValRes = [1];
ParamVarStruct(ind).ColorGroup = 2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Yield #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Yield - Cell/Element ratio';
ParamVarStruct(ind).UnitText = 'y_l_d#2';
ParamVarStruct(ind).INDX = 'yld2'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.5;
ParamVarStruct(ind).MinMaxVal = [0 5];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Monod relation parameter 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Monod relation parameter';
ParamVarStruct(ind).UnitText = 'K_{m2} [g/L]';
ParamVarStruct(ind).INDX = 'k2'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.5;
ParamVarStruct(ind).MinMaxVal = [0 0.01];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Maximal growth rate #2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Maximal growth rate';
ParamVarStruct(ind).UnitText = '\mu2_{max} [1/h]';
ParamVarStruct(ind).INDX = 'mu2'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.3;
ParamVarStruct(ind).MinMaxVal = [0.01 2];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Minimal growth rate #2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
ParamVarStruct(ind).Title = 'Minimal growth rate';
ParamVarStruct(ind).UnitText = '\mu2_{min} [1/h]';
ParamVarStruct(ind).INDX = 'mu2min'; %LOWERCASE
ParamVarStruct(ind).DefaultVal = 0.3;
ParamVarStruct(ind).MinMaxVal = [0 10];
ParamVarStruct(ind).ValRes = [0.1];
ParamVarStruct(ind).ColorGroup = 2;




% ParamVarStruct(ind).Values = [1, 2, 3];
% ParamVarStruct(ind).nDataTypes = size(ParamVarStruct(ind).Values,2);
% ParamVarStruct(ind).Names = {'m/s','Km/h','Miles/h'};


% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dilution Interval %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% ParamVarStruct(ind).Title = 'Dilution Interval';
% ParamVarStruct(ind).UnitText = '\tau_d [h]';
% ParamVarStruct(ind).INDX = 'td'; %LOWERCASE
% ParamVarStruct(ind).DefaultVal = 6;
% ParamVarStruct(ind).MinMaxVal = [0.01 20];
% ParamVarStruct(ind).ValRes = [0.1];
% ParamVarStruct(ind).ColorGroup = 3;




end


function [calculatedVals] = getCalulatedValsStruct()
%%
calculatedVals = struct();
ind = 0;
strSpace = ':     ';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% PHI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'phi';
calculatedVals(ind).Description = char(['\phi - Ratio of media remaining after dilution', strSpace, '\phi = 1 - V_d / V_t'],' ') ;
calculatedVals(ind).ShortDescription = 'Dilution Remainder';
calculatedVals(ind).INDX = 'phi';
calculatedVals(ind).Symbol = '\phi';
calculatedVals(ind).Range = [0 1];
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%% td %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% calculatedVals(ind).Names =  'Dilution Interval';
% calculatedVals(ind).Description = char(['\tau_d - Dilution Interval [h]', strSpace, '\tau_d = (V_d / D)/V_t'],' ') ;
% calculatedVals(ind).ShortDescription = 'Dilution Interval [h]';
% calculatedVals(ind).INDX = 'td';
% calculatedVals(ind).Symbol = '\tau_d ';
% calculatedVals(ind).Range = [eps inf];
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%% D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% calculatedVals(ind).Names = 'D';
% calculatedVals(ind).Description = char(['D - dilution parameter [units?]', strSpace, 'D = (V_d / \tau_d)/V_t'],' ') ;
% calculatedVals(ind).ShortDescription = 'Dilution Param [u?]';
% calculatedVals(ind).INDX = 'D';
% calculatedVals(ind).Symbol = 'D';
% calculatedVals(ind).Range = [eps inf];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% max DOUBLING TIME 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'Max Doubling Time';
calculatedVals(ind).Description = char(['\mu_{max1}^{x2 time} - Max Doubling Time 1 [h]', strSpace, 'ln(2)/\alpha_{max}'],' ') ;
calculatedVals(ind).ShortDescription = 'Max Doubling Time 1 [h]';
calculatedVals(ind).INDX = 'muD1_t';
calculatedVals(ind).Symbol = '\mu_{max1}^{x2 time}';
calculatedVals(ind).Range = [0 10];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% max DOUBLING TIME 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'Max Doubling Time 2';
calculatedVals(ind).Description = char(['\mu2_{max}^{x2 time} - Max Doubling Time 1 [h]', strSpace, 'ln(2)/\alpha_{max}'],' ') ;
calculatedVals(ind).ShortDescription = 'Max Doubling Time 2 [h]';
calculatedVals(ind).INDX = 'muD2_t';
calculatedVals(ind).Symbol = '\mu_{max2}^{x2 time}';
calculatedVals(ind).Range = [0 10];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% min DOUBLING TIME 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'Min Doubling Time 2';
calculatedVals(ind).Description = char(['\mu2_{min}^{x2 time} - Max Doubling Time 1 [h]', strSpace, 'ln(2)/\alpha_{max}'],' ') ;
calculatedVals(ind).ShortDescription = 'Min Doubling Time 2 [h]';
calculatedVals(ind).INDX = 'muD2min_t';
calculatedVals(ind).Symbol = '\mu_{min2}^{x2 time}';
calculatedVals(ind).Range = [0 inf];
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%% BETA DOUBLING TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% calculatedVals(ind).Names = 'Mean Doubling Time';
% calculatedVals(ind).Description = char(['\mu_{chemos.}^{x2 time} - Mean Doubling Time [h]', strSpace, 'ln(2)/\mu'],' ') ;
% calculatedVals(ind).ShortDescription = 'Mean Doubling Time [h]';
% calculatedVals(ind).INDX = 'Bx2_t';
% calculatedVals(ind).Symbol = '\mu_{chemos.}^{x2 time}';
% calculatedVals(ind).Range = [0 50];
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%% BETA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% calculatedVals(ind).Names = 'Mean Growth';
% calculatedVals(ind).Description = char(['\mu - mean growth rate [1/h]', strSpace, '-ln(\phi)/\tau_d'],' ') ;
% calculatedVals(ind).ShortDescription = 'Mean Growth Rate [1/h]';
% calculatedVals(ind).INDX = 'BBeta';
% calculatedVals(ind).Symbol = '\mu_{chemos.}';
% calculatedVals(ind).Range = [0 5];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% xmax %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'Max Cells';
calculatedVals(ind).Description = char([ 'St.St. cell concentration [g/L]', strSpace, 'S_d/yld_1'],' ') ;
calculatedVals(ind).ShortDescription = 'Chemo. cell concentration [g/L]';
calculatedVals(ind).INDX = 'xmax';
calculatedVals(ind).Symbol = 'xmax';
calculatedVals(ind).Range = [0 10];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% OD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'OD';
calculatedVals(ind).Description = char([ 'OD_{600}1', strSpace, 'xmax/0.45'],' ') ;
calculatedVals(ind).ShortDescription = 'at OD_{600}1 = 0.45 gCDW/L';
calculatedVals(ind).INDX = 'OD';
calculatedVals(ind).Symbol = 'OD';
calculatedVals(ind).Range = [0 10];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% nCells %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
calculatedVals(ind).Names = 'nCells';
calculatedVals(ind).Description = char([ 'nCells ', strSpace, 'OD * V_t * 10^{12}'],' ') ;
calculatedVals(ind).ShortDescription = 'number of cells in the vat';
calculatedVals(ind).INDX = 'nCells';
calculatedVals(ind).Symbol = 'nCells';
calculatedVals(ind).Range = [1e9 1e14];

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%% r0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% calculatedVals(ind).Names = 'S(0)';
% calculatedVals(ind).Description = 'S(0) - Steady State sugar density[g/L]';
% calculatedVals(ind).ShortDescription = 'SS Sugar dens.[g/L]';
% calculatedVals(ind).INDX = 'S_0';
% calculatedVals(ind).Symbol = 'S(mean)';
% calculatedVals(ind).Range = [eps 10];


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[calculatedVals(:).Values] = deal(0);
end

function [graphDataStruct] = getGraphDataStruct()
graphDataStruct = struct();

graphDataStruct.lineSubTypes = {'time'}; % ,'StartStop', 'MeanBehaviour'};
graphDataStruct.lineSubToHide = [0]; %[0 1 1];
graphDataStruct.ExtraLines = {'mumax1', 'mumax2', 'Ref. D'};%{'xmax', 'Sd', 'Ctotal'};
graphDataStruct.ExtraLinesToHide = [1 0 1];%[1,1,1];
graphDataStruct.Labels = {'D [1/h]','Takeover Time [days]'};
%graphDataStruct.CalculationModes = {'Steady State', 'Temporal Dynamics', 'Competition'};
graphDataStruct.CalculationModes = {'Monod','Sugar', 'Growth rates', 'Takeover','Full Dynamics'};

%lTypeColors = 'grbycmkrgbycmkrgbycmk';
ind = 0;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
graphDataStruct.Title{ind}    = 'GREEN';
graphDataStruct.UnitText{ind} = 'GREEN';
graphDataStruct.Symbol{ind}   = 'GREEN';
graphDataStruct.Data{ind} = zeros(0,2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
graphDataStruct.Title{ind}    = 'RED';
graphDataStruct.UnitText{ind} = 'RED';
graphDataStruct.Symbol{ind}   = 'RED';
graphDataStruct.Data{ind} = zeros(0,2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
graphDataStruct.Title{ind}    = 'BLUE';
graphDataStruct.UnitText{ind} = 'BLUE';
graphDataStruct.Symbol{ind}   = 'BLUE';
graphDataStruct.Data{ind} = zeros(0,2);

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% graphDataStruct.Title{ind} = 'Takeover Time(t)';
% graphDataStruct.UnitText{ind} = 'TO(t) [Days]';
% graphDataStruct.Symbol{ind} = 'Takeover(D)';
% graphDataStruct.Data{ind} = zeros(0,2);
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% graphDataStruct.Title{ind} = 'Mutation Time(t)';
% graphDataStruct.UnitText{ind} = 'Mut(t) [Days]';
% graphDataStruct.Symbol{ind} = 'Mutation(D)';
% graphDataStruct.Data{ind} = zeros(0,2);
% 
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ind = ind + 1;
% graphDataStruct.Title{ind} = 'Total time';
% graphDataStruct.UnitText{ind} = 'Total(D) [Days]';
% graphDataStruct.Symbol{ind} = 'Total(D)';
% graphDataStruct.Data{ind} = zeros(0,2);
end