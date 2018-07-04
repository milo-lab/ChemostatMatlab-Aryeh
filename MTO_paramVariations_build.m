function varargout = MTO_paramVariations_build(ParamVarStruct,calculatedVals,graphDataStruct)
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
UD = struct();
UI = struct();

% panels
panelSpaces = 0.01;
cntrlPanHight = 0.15;
cValsPanHight = 0.175;
nPanelsPerColoum = 5;
axPanelWidth = 0.55;

%controls
editBoxSpaces  = 0.1;
editBoxW = 0.3;
editBoxH  = 0.2;
sliderW = 0.7;
btnHight = 0.3;
chkHight = 0.25;
btnWidth = 0.15;
btnSpacesW = 0.01;
btnSpacesH = 0.1;

%text
cValTxtSpaces = 0.03;
textW = 0.1;

% Lines
Lwid = 2;
lineTypesCell = graphDataStruct.Symbol;
lineSubTypes = graphDataStruct.lineSubTypes;

nLineTypes = size(graphDataStruct.Title,2);
nLineSubTypes = size(graphDataStruct.lineSubTypes,2);
lTypeColors = 'grbykmcrgbycmkrgbycmk';
lSubTypeProp = {'-','.','--','d','-.'};
while length(lSubTypeProp) < nLineSubTypes
    lSubTypeProp = cat(2,lSubTypeProp,lSubTypeProp);
end
nExtraLines = size(graphDataStruct.ExtraLines,2);

if max([ParamVarStruct.ColorGroup]) == 3
    paramGroupColors = [0.5 0.9 0.5; 0.5 0.5 0.9; 0.65 0.65 0.65];
else
    paramGroupColors = lines(max([ParamVarStruct.ColorGroup]));
end


figPos = [0.1 0.1 0.8 0.8];
%axPos = [0.07 0.05 0.88 0.9];
axPos = [0.1 0.1 0.85 0.81]; %with labels

nCvals = size(calculatedVals,2);
cValTxtW = (1- (ceil(nCvals/2)+1)*cValTxtSpaces)/ceil(nCvals/2);

% colors
cValColor = [255 204 153]./255;
axsColor =  [175 240 201]./255;


%% PANAL PARAM SETUP
nPanels = size(ParamVarStruct,2);
nPanelColoums = ceil(nPanels/nPanelsPerColoum);

pWidth = (1 - (axPanelWidth + panelSpaces) - ((nPanelColoums + 1) * panelSpaces))/nPanelColoums;
if nPanels < nPanelsPerColoum
    pHight = (1 - ((nPanels+1)*panelSpaces))/nPanels;
else
    pHight = (1 - ((nPanelsPerColoum + 1)*panelSpaces))/nPanelsPerColoum;
end

axPanHight = 1 - (2*panelSpaces) - (cntrlPanHight + panelSpaces) - (cValsPanHight + panelSpaces);

%% FIGURE
figName = 'Parameter Variations';
%figPos = [0.1 0.1 0.8 0.8];
figTag = 'ParameterVariationsGUI';
figProps =  cat(2,{'IntegerHandle' 'off'},{'Name',figName},{'NumberTitle','off'},{'Units','normalized'},{'Position',figPos},{'Tag',figTag},{'UserData',UD},{'toolbar', 'none'});

figList = findobj('type','figure');
close(figList(strcmp(get(figList, 'tag'),figTag)));

figH = figure(figProps{:});
UI.figH = figH;
clf
%% AXIS PANAL
% axes
panelPosition = [(panelSpaces),(panelSpaces)*2 + (cValsPanHight),axPanelWidth, axPanHight];
UI.AxPan.AxPanH = uipanel('parent',UI.figH ,'units', 'normalized','position', panelPosition, 'Title', 'Axes', 'background', axsColor);
UI.AxPan.mainAxesH = axes('parent',UI.AxPan.AxPanH,'units', 'normalized','position',axPos);
set(get(UI.AxPan.mainAxesH,'xlabel'),'string', graphDataStruct.Labels{1});
set(get(UI.AxPan.mainAxesH,'ylabel'),'string', graphDataStruct.Labels{2});
hold(UI.AxPan.mainAxesH, 'on');

% lines
legendText = cell(0);
smallLegendText = cell(0);
for iLineType = 1:nLineTypes
    currType = lineTypesCell{iLineType};
    for iLineSubType = 1:nLineSubTypes   %?order changed for benifit of legend
        currSubType = lineSubTypes{iLineSubType};
        UI.AxPan.LineH(iLineType,iLineSubType) = plot(UI.AxPan.mainAxesH,0,0,[lTypeColors(iLineType),lSubTypeProp{iLineSubType}], 'linewidth', Lwid);
        currLegendText = [currType, ' - ', currSubType];
        legendText = {legendText{:}, currLegendText};
        if ~graphDataStruct.lineSubToHide(iLineSubType)
            smallLegendText = {smallLegendText{:}, currLegendText};
        end
    end
end
for iExtraLine = 1:size(graphDataStruct.ExtraLines,2)
    UI.AxPan.ExtraLineH(iExtraLine) = plot(UI.AxPan.mainAxesH,0,0,[lTypeColors(nLineTypes + iExtraLine)],'LineStyle', '--');%,lSubTypeProp{iLineSubType + iExtraLine}]);
    currLegendText = [graphDataStruct.ExtraLines{iExtraLine}];
    legendText = {legendText{:}, currLegendText};
    if ~graphDataStruct.ExtraLinesToHide(iExtraLine)
        smallLegendText = {smallLegendText{:}, currLegendText};
    end
end

%legend
UI.AxPan.legendH = legend(UI.AxPan.mainAxesH, legendText);
UI.AxPan.smallLegendText = smallLegendText;
%% Calculated Vals PANAL
panelPosition = [(panelSpaces),(panelSpaces),axPanelWidth, cValsPanHight];
UI.cValsPanH = uipanel('parent',UI.figH ,'units', 'normalized','position', panelPosition, 'Title', 'Calculated Values', 'background' , cValColor);
UI.cValsPan_textAXH = axes('parent',UI.cValsPanH,'units', 'normalized','position',[0 0 1 1],'Visible','off');
for iCval = 1:nCvals
    txtPos = [(iCval - 1)*(cValTxtW + cValTxtSpaces) + cValTxtSpaces, 0.85];
    if iCval > ceil(nCvals/2)
        txtPos = [(iCval - 1 - ceil(nCvals/2))*(cValTxtW + cValTxtSpaces) + cValTxtSpaces, 0.25];
    end
    currCval = calculatedVals(iCval).Values;
    currTextStr = sprintf('%s = %0.1f', calculatedVals(iCval).Symbol,currCval);
    currExplainTextStr = calculatedVals(iCval).ShortDescription;
    UI.cValTxtH(iCval) = text('parent',UI.cValsPan_textAXH,'units', 'normalized','position',txtPos,'string',currTextStr);
    UI.cValExplainTxtH(iCval) = text('parent',UI.cValsPan_textAXH,'units', 'normalized','position',txtPos - [0, 0.2],'string',currExplainTextStr, 'FontSize' , 7);
end

%% Control PANAL
panelPosition = [(panelSpaces),(3*panelSpaces)+ axPanHight+cValsPanHight,axPanelWidth, cntrlPanHight];
UI.Cntrls.CntrlPanH = uipanel('parent',UI.figH ,'units', 'normalized','position', panelPosition, 'Title', 'Controls');

% % RESET DEFAULTS BUTTON
% currPos = [1-(btnWidth + btnSpacesW), btnSpacesH, btnWidth,btnHight];
% controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'RESET DEFAULTS',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
%     {'String','DEFAULTS'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', [0.8 0.2 0.2]});
% UI.Cntrls.DefBtnH = uicontrol(controlProps{:});

% show legend checkbox
currPos = [1-(btnWidth + btnSpacesW), btnSpacesH + (chkHight + btnSpacesH), btnWidth,chkHight];
controlProps =  cat(2,{'Style','check'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'LEGEND',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Hide Legend'},{'Tag',''},{'Visible','on'},{'Enable','on'},{'BackgroundColor', axsColor});
UI.Cntrls.legendCheckbH = uicontrol(controlProps{:});

% hide lines checkbox
currPos = [1-(btnWidth + btnSpacesW), btnSpacesH, btnWidth, chkHight];
controlProps =  cat(2,{'Style','check'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'HIDE LINES',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Hide Lines'},{'Tag',''},{'Visible','on'},{'Enable','on'},{'BackgroundColor', axsColor});
UI.Cntrls.hideLinesCheckbH = uicontrol(controlProps{:});

% hide subtext checkbox
currPos = [1-(btnWidth + btnSpacesW),  btnSpacesH + 2*(chkHight + btnSpacesH), btnWidth, chkHight];
controlProps =  cat(2,{'Style','check'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'HIDE SUBTEXT',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Hide SubText'},{'Tag',''},{'Visible','on'},{'Enable','on'},{'BackgroundColor', cValColor});
UI.Cntrls.hideSubtextCheckbH = uicontrol(controlProps{:});

% calc modes radioB
for iCalcMode = 1:size(graphDataStruct.CalculationModes,2)
    currCalcMode = graphDataStruct.CalculationModes{iCalcMode};
    currPos = [1-3*(btnWidth + btnSpacesW),0.8 - (btnSpacesH*0.1 + (iCalcMode - 1)*(btnSpacesH*0.1 + btnHight*0.6)), 2*btnWidth, btnHight*0.6];
    controlProps =  cat(2,{'Style','radio'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'TOGGLE CALC MODE',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
        {'String',currCalcMode},{'Tag',''},{'Visible','on'},{'Enable','on'},{'Value',iCalcMode == 1});%,{'Value',iCalcMode == 2});
    UI.Cntrls.CalcModeRadioBH(iCalcMode) = uicontrol(controlProps{:});
    if strcmpi('Full Dynamics',currCalcMode)
       set(UI.Cntrls.CalcModeRadioBH(iCalcMode), 'FontWeight', 'bold', 'ForegroundColor', [1 0 0]);
    end
end

% PRESETS POP
currPos = [btnSpacesW, btnHight + 2*btnSpacesH, btnWidth*2 + btnSpacesW, btnHight];
controlProps =  cat(2,{'Style','pop'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'CHOOSE PRESET',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','DEFAULTS'},{'Tag',''},{'Visible','on'},{'Enable','on'});
UI.Cntrls.PresetPopH = uicontrol(controlProps{:});


% ADD PRESET BUTTON
currPos = [btnSpacesW, btnSpacesH, btnWidth, btnHight];
controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'ADD PRESET',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','ADD PRESET'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', [0.2 0.7 0.2]});
UI.Cntrls.AddPresetBtnH = uicontrol(controlProps{:});

% REMOVE PRESETS BUTTON
currPos = [btnSpacesW*2 + btnWidth, btnSpacesH, btnWidth, btnHight];
controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'REMOVE PRESETS',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','REMOVE PRESETS'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', [0.8 0.3 0.3]});
UI.Cntrls.RemovePresetBtnH = uicontrol(controlProps{:});

% DESCRIPTION BUTTON
currPos = [btnSpacesW*3 + 2*btnWidth, 0.63 , btnWidth, btnHight];
controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'DESCRIPTION',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Cal. Values Eq'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', cValColor});
UI.Cntrls.HelpBtnH = uicontrol(controlProps{:});

% EQUATIONS BUTTON
currPos = [btnSpacesW*3 + 2*btnWidth, 0.33 , btnWidth, btnHight];
controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'EQUATIONS',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Takeover Eq'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', axsColor});
UI.Cntrls.HelpBtnH = uicontrol(controlProps{:});

% DYNAMICS EQUATIONS BUTTON
currPos = [btnSpacesW*3 + 2*btnWidth, 0.03 , btnWidth, btnHight];
controlProps =  cat(2,{'Style','push'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'DYNAMICS EQUATIONS',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Dynamics Eq'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', axsColor},{'FontWeight', 'bold'}, {'ForegroundColor', [1 0 0]});
UI.Cntrls.HelpBtnH = uicontrol(controlProps{:});

% PAUSE BUTTON
currPos = [btnSpacesW*5 + 4.5*btnWidth, 0.7 , 0.5*btnWidth, btnHight];
controlProps =  cat(2,{'Style','toggle'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'PAUSE',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','PAUSE'},{'Tag',''},{'Visible','on'},{'Enable','on'});
UI.Cntrls.PauseH = uicontrol(controlProps{:});

% ZOOM BUTTON
currPos = [btnSpacesW*5 + 4.5*btnWidth, 0.67 - btnHight , 0.5*btnWidth, btnHight];
controlProps =  cat(2,{'Style','toggle'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'ZOOM',  figH,[],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','ZOOM'},{'Tag',''},{'Visible','on'},{'Enable','on'});
UI.Cntrls.ZoomH = uicontrol(controlProps{:});

%SPEED EDIT Box
currPos = [btnSpacesW*5 + 4.5*btnWidth, 0.64 - 2*btnHight , 0.5*btnWidth, btnHight];
controlProps =  cat(2,{'Style','edit'}, {'Parent',UI.Cntrls.CntrlPanH},{'Callback', {@MTO_paramVariations_cb, 'SPEED',  figH, [],[]}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
    {'String','Speed x'},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', 'y'});
UI.SpeedEditH = uicontrol(controlProps{:});
%% VARIABLE PANALS
nPanelRows = (min((nPanels - nPanelsPerColoum),0) + nPanelsPerColoum);
[RowInd,ColInd] = meshgrid(1:nPanelRows,1:nPanelColoums);
RowInd = RowInd';
RowInd = RowInd(end:-1:1);
ColInd = ColInd';
for iPanel = 1:nPanels
    panelPosition = [...
        ((axPanelWidth + panelSpaces) + panelSpaces  + (ColInd(iPanel) - 1)*(pWidth + panelSpaces)),...
        (panelSpaces  + (RowInd(iPanel) - 1)*(pHight + panelSpaces)),...
        pWidth,...
        pHight];
    UI.VarPanH(iPanel) = uipanel('parent',UI.figH ,'units', 'normalized','position', panelPosition, 'Title', ParamVarStruct(iPanel).Title);
    if (ParamVarStruct(iPanel).ColorGroup) > 0 
        set(UI.VarPanH(iPanel) ,'backgroundcolor', paramGroupColors((ParamVarStruct(iPanel).ColorGroup) ,:));
    end
    UI.VarPan_textAXH(iPanel) = axes('parent',UI.VarPanH(iPanel),'units', 'normalized','position',[0 0 1 1],'Visible','off');
    %% FAKE AXES
    % TEXT NAME
    textPos = [0.04,0.7];
    currUnitText =  ParamVarStruct(iPanel).UnitText;
    UI.UnitText = text('parent',UI.VarPan_textAXH(iPanel), 'position',textPos, 'string',currUnitText);
    %% CONTROLS
    currDefVal = ParamVarStruct(iPanel).DefaultVal;
    
%     %TEXT BOX
%     currPos = [(1-editBoxW)/2, (editBoxSpaces + editBoxH)*2 + editBoxSpaces, editBoxW,editBoxH];
%     textProps =  cat(2,{'Style','edit'}, {'Parent',UI.VarPanH(iPanel)},{'Units','normalized'},{'Position',currPos},...
%         {'String',currDefVal},{'Enable','off'});
%     UI.textH = uicontrol(textProps{:});
    
    %EDIT Box
    currPos = [(1-editBoxW)/2, (editBoxSpaces + editBoxH)*1 + editBoxSpaces, editBoxW,editBoxH];
    controlProps =  cat(2,{'Style','edit'}, {'Parent',UI.VarPanH(iPanel)},{'Callback', {@MTO_paramVariations_cb, 'EDIT',  figH, ParamVarStruct(iPanel).Title,iPanel}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
        {'String',currDefVal},{'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', [1 1 1]});
    UI.dataEditH(iPanel) = uicontrol(controlProps{:});
    
    %lockCheckH
    currPos = [0.5 + editBoxW/2 + editBoxSpaces/2, (editBoxSpaces + editBoxH)*1 + editBoxSpaces, editBoxW,editBoxH];
    controlProps =  cat(2,{'Style','check'}, {'Parent',UI.VarPanH(iPanel)},{'Callback', {@MTO_paramVariations_cb, 'LOCK',  figH, ParamVarStruct(iPanel).Title,iPanel}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
        {'String','Lock'},{'Tag',''},{'Visible','on'},{'Enable','on'});
    UI.lockCheckH(iPanel) = uicontrol(controlProps{:});
    
    
    %SLIDER BAR & text
    defSliderVal = (currDefVal - ParamVarStruct(iPanel).MinMaxVal(1))/(ParamVarStruct(iPanel).MinMaxVal(2) - ParamVarStruct(iPanel).MinMaxVal(1));
    currPos = [(1-sliderW)/2, (editBoxSpaces + editBoxH)*0 + editBoxSpaces, sliderW, editBoxH];
    controlProps =  cat(2,{'Style','slider'}, {'Parent',UI.VarPanH(iPanel)},{'Callback', {@MTO_paramVariations_cb, 'SLIDER',  figH, ParamVarStruct(iPanel).Title,iPanel}},{'UserData',[]},{'Units','normalized'},{'Position',currPos},...
        {'Tag',''},{'Visible','on'},{'Enable','on'}, {'BackgroundColor', [1 1 1]},{'value',defSliderVal});
    UI.sliderH(iPanel) = uicontrol(controlProps{:});
    
    currPos = [(1-sliderW)/2 - textW - editBoxSpaces/3, (editBoxSpaces + editBoxH)*0 + editBoxSpaces,textW,editBoxH];
    textProps =  cat(2,{'Style','edit'}, {'Parent',UI.VarPanH(iPanel)},{'Units','normalized'},{'Position',currPos},...
        {'String',ParamVarStruct(iPanel).MinMaxVal(1)},{'Enable','off'});
    UI.textH = uicontrol(textProps{:});
    
    
    currPos = [(1-sliderW)/2 + sliderW + editBoxSpaces/3, (editBoxSpaces + editBoxH)*0 + editBoxSpaces,textW,editBoxH];
    textProps =  cat(2,{'Style','edit'}, {'Parent',UI.VarPanH(iPanel)},{'Units','normalized'},{'Position',currPos},...
        {'String',ParamVarStruct(iPanel).MinMaxVal(2)},{'Enable','off'});
    UI.textH = uicontrol(textProps{:});
    
    
end
%% HELP TEXT

%% SET UD
UD.UI = UI;
%zoom on;
% UD.graphData = cell(nLineTypes,nLineSubTypes);

set(figH, 'userdata', UD);
%% OUTPUT
if (nargout >= 1)
    varargout{1} = UD;
end
end