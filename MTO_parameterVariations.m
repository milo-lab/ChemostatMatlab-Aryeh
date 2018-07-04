function varargout = MTO_parameterVariations()
%{
INPUT:
OUTPUT:
%}
varargout = cell(nargout,1);
%% INPUT
if (~exist('INPUTPARAM', 'var') || isempty(INPUTPARAM))
	INPUTPARAM = [];
end
%% PARAMS
[ParamVarStruct,calculatedVals,graphDataStruct] = MTO_getAllDataStructs();

%%
UD = MTO_paramVariations_build(ParamVarStruct,calculatedVals,graphDataStruct);


%%
%MTO_paramVariations_cb();

%%
UD.ParamVarStruct = ParamVarStruct;
UD.calculatedVals = calculatedVals;
UD.graphDataStruct = graphDataStruct;
UD.graphDataStruct.graphData = cell(size(UD.UI.AxPan.LineH));


set(UD.UI.figH, 'userdata', UD);




%%

paramVariations_init(UD.UI.figH);

%% OUTPUT
if (nargout >= 1)
	varargout{1} = [];
end
end


function varargout = paramVariations_init(figH)
%{
INPUT:
OUTPUT:
%}
varargout = cell(nargout,1);
%% INPUT
if (~exist('INPUTPARAM', 'var') || isempty(INPUTPARAM))
	INPUTPARAM = [];
end
%% PARAMS
UD = get(figH, 'userdata');

%%

try 
    load('PRESETS','PresetStruct')
catch
    PresetStruct = struct();
    PresetStruct(1).Name = 'Defaults';
    PresetStruct(1).Values = [UD.ParamVarStruct.DefaultVal];
    save('PRESETS','PresetStruct');
end
UD.PresetStruct = PresetStruct;
set(UD.UI.Cntrls.PresetPopH,'string',{UD.PresetStruct.Name});
set(UD.UI.dataEditH(2), 'enable', 'off');
set(UD.UI.sliderH(2), 'enable', 'off');
set(UD.UI.lockCheckH(2), 'enable', 'off');


set(UD.UI.figH, 'userdata', UD);
%%

MTO_paramVariations_cb([], [], 'CHOOSE PRESET', figH, [],[]);
%MTO_paramVariations_cb(UD.UI.Cntrls.CalcModeRadioBH(3), [], 'TOGGLE CALC MODE', figH, [],[]);
%% OUTPUT
%set(figH, 'userdata', UD);

if (nargout >= 1)
	varargout{1} = [UD];
end
end




