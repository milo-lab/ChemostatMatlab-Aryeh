function varargout = MTO_paramVariations_cb(hObj, events, action, figH, dataTypeTitle,iPanel, varargin)
%{
INPUT:
OUTPUT:
%}
varargout = cell(nargout,1);
%
%% INPUT
if (~exist('action', 'var') || isempty(action))
    action = 'DEFAULT';
end
if (~exist('figH', 'var') || isempty(figH))
    figTag = 'ParameterVariationsGUI';
    figList = findobj('type','figure');
    figH = (figList(strcmp(get(figList, 'tag'),figTag)));
end
UD = get(figH, 'userdata');
%% PARAMS
OnOff = {'on','off'};
paramValues = str2num(strvcat(get(UD.UI.dataEditH(:), 'string')));
paramINDXs = {UD.ParamVarStruct(:).INDX};
limitParamMinMaxFlag = false;

pausedFlag = get(UD.UI.Cntrls.PauseH, 'value');
%% ACTION

switch upper(action)
    case 'SPEED'
        inpDataValue = str2num(get(UD.UI.SpeedEditH,'string'));
        if isempty(inpDataValue)
            set(UD.UI.SpeedEditH,'string','Speed x');
            return
        end
    case 'EDIT'
        inpDataValue = str2num(get(UD.UI.dataEditH(iPanel),'string'));
        currMinMaxVal = sort(UD.ParamVarStruct(iPanel).MinMaxVal);
        set(UD.UI.dataEditH(iPanel),'BackgroundColor',[1 1 1]);
        if isempty(inpDataValue)
            set(UD.UI.dataEditH(iPanel),'BackgroundColor',[1 0 0]);
            return
        end
        
        if limitParamMinMaxFlag
            newParamVal = max(min(inpDataValue,currMinMaxVal(2)),currMinMaxVal(1));
        else
            newParamVal = inpDataValue;
        end
        newSliderVal = (newParamVal - currMinMaxVal(1))/(abs(diff(currMinMaxVal)));
        set(UD.UI.sliderH(iPanel),'value',newSliderVal);
        set(UD.UI.dataEditH(iPanel), 'string', newParamVal);
        
        if ~pausedFlag
            MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
            MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        end
    case 'SLIDER'
        currMinMaxVal = UD.ParamVarStruct(iPanel).MinMaxVal;
        newSliderVal = get(UD.UI.sliderH(iPanel),'value');
        newParamVal = newSliderVal*(abs(diff(currMinMaxVal))) + min(currMinMaxVal);
        set(UD.UI.dataEditH(iPanel), 'string', newParamVal);
        
        if ~pausedFlag
            MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
            MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        end
    case 'LOCK'
        currLockFlag = get(UD.UI.lockCheckH(iPanel),'value');
        set(UD.UI.dataEditH(iPanel), 'enable', OnOff{currLockFlag+1});
        set(UD.UI.sliderH(iPanel), 'enable', OnOff{currLockFlag+1});
        
    case 'SET CVALS'
        UD.calculatedVals = MTO_cValCalculator(UD.calculatedVals,paramValues,paramINDXs);
        bkgdColor = [0.8 0.8 0.8];
        for iCval = 1:length(UD.calculatedVals)
            currCval = UD.calculatedVals(iCval).Values;
            currTextStr = sprintf('%s = %0.2g', UD.calculatedVals(iCval).Symbol,currCval);
            txtColor = [0 0 0];
            
            if currCval < min(UD.calculatedVals(iCval).Range) || currCval > max(UD.calculatedVals(iCval).Range)
                txtColor = [1 0 0];
                bkgdColor = [0.8 0.3 0.3];
            end
            set(UD.UI.cValTxtH(iCval),'string',currTextStr, 'color', txtColor);
        end
        set(UD.UI.figH, 'color', bkgdColor);
        set(UD.UI.figH, 'userdata', UD);  %REMEMBER!!
        
        %     case 'RESET DEFAULTS'
        %         for iPanel = 1:length(UD.UI.dataEditH)
        %             isLockedFlag = get(UD.UI.lockCheckH(iPanel),'value');
        %             if ~isLockedFlag
        %                 currDefVal = UD.ParamVarStruct(iPanel).DefaultVal;
        %                 currDefSliderVal = (currDefVal - UD.ParamVarStruct(iPanel).MinMaxVal(1))/(UD.ParamVarStruct(iPanel).MinMaxVal(2) - UD.ParamVarStruct(iPanel).MinMaxVal(1));
        %                 set(UD.UI.dataEditH(iPanel), 'string', currDefVal);
        %                 set(UD.UI.sliderH(iPanel),'value',currDefSliderVal);
        %             end
        %         end
        %         MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
        %         MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        
    case 'CHOOSE PRESET'
        currPreset = get(UD.UI.Cntrls.PresetPopH,'value');
        currPresetVals = UD.PresetStruct(currPreset).Values;
        for iPanel = 1:length(UD.UI.dataEditH)
            isLockedFlag = get(UD.UI.lockCheckH(iPanel),'value');
            if ~isLockedFlag
                try
                    currDefVal = currPresetVals(iPanel);
                catch
                    currDefVal = 0;
                end
                
                currDefSliderVal = (currDefVal - UD.ParamVarStruct(iPanel).MinMaxVal(1))/(UD.ParamVarStruct(iPanel).MinMaxVal(2) - UD.ParamVarStruct(iPanel).MinMaxVal(1));
                set(UD.UI.dataEditH(iPanel), 'string', currDefVal);
                set(UD.UI.sliderH(iPanel),'value',currDefSliderVal);
            end
        end
        if ~pausedFlag
            MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
            MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        end
    case 'ADD PRESET'
        newName = inputdlg('Preset Name');
        if isempty(newName)
            return
        end
        ind = length(UD.PresetStruct) + 1;
        UD.PresetStruct(ind).Name = newName{:};
        UD.PresetStruct(ind).Values = str2num(str2mat(get(UD.UI.dataEditH,'string')));
        
        PresetStruct = UD.PresetStruct;
        save('PRESETS','PresetStruct');
        set(UD.UI.Cntrls.PresetPopH,'string',{UD.PresetStruct.Name},'value',ind);
        
        set(UD.UI.figH, 'userdata', UD);  %REMEMBER!!
        
        
    case 'REMOVE PRESETS'
        strList = {UD.PresetStruct.Name};
        [s,okFlag] = listdlg('PromptString','Select Presets to Remove','SelectionMode','multiple','ListString',strList);
        if okFlag
            remainInd = 1:length(strList);
            remainInd = setdiff(remainInd,s);
            PresetStruct = UD.PresetStruct(remainInd);
            
            if size(PresetStruct,1) == 0
                PresetStruct = struct();
                PresetStruct(1).Name = 'Defaults';
                PresetStruct(1).Values = [UD.ParamVarStruct.DefaultVal];
                save('PRESETS','PresetStruct');
            end
            save('PRESETS','PresetStruct');
            UD.PresetStruct = PresetStruct;
            
            set(UD.UI.Cntrls.PresetPopH,'string',{UD.PresetStruct.Name},'value',1);
            
            set(UD.UI.figH, 'userdata', UD);  %REMEMBER!!
            
        end
    case 'SET GRAPHS'
        [newGraphData,newGraphExtraData,axisLabels, legendLabels] = MTO_graphDataCalculator(UD,paramValues,paramINDXs);
        if ~isempty(newGraphData{1}) && ~isempty(newGraphExtraData{1})
            for iLineType = 1:size(newGraphData,1)
                for iLineSubType = 1:size(newGraphData,2)
                    set(UD.UI.AxPan.LineH(iLineType,iLineSubType),...
                        'xData',newGraphData{iLineType,iLineSubType}(:,1),...
                        'yData',newGraphData{iLineType,iLineSubType}(:,2));
                    
                    %legend
                    set(UD.UI.AxPan.legendH, 'string', legendLabels)
                end
            end
            for iExtraLine = 1:size(newGraphExtraData,1)
                set(UD.UI.AxPan.ExtraLineH(iExtraLine),...
                    'xData',newGraphExtraData{iExtraLine}(:,1),...
                    'yData',newGraphExtraData{iExtraLine}(:,2));
            end
            
            % axis labels
            set(get(UD.UI.AxPan.mainAxesH,'xlabel'),'string',axisLabels{1});
            set(get(UD.UI.AxPan.mainAxesH,'ylabel'),'string',axisLabels{2});
            
            UD.graphData = newGraphData;
            set(UD.UI.figH, 'userdata', UD);  %REMEMBER!!
        end
        
        
        
    case 'LEGEND'
        
        legendFlag = get(UD.UI.Cntrls.legendCheckbH, 'value');
        set(UD.UI.AxPan.legendH, 'Visible', OnOff{legendFlag+1});
        
    case 'HIDE LINES'
        HLcheckFlag = get(UD.UI.Cntrls.hideLinesCheckbH, 'value') == 1;
        for iLineType = 1:size(UD.graphDataStruct.Title,2)
            for iLineSubType = 1:size(UD.graphDataStruct.lineSubTypes,2)
                hideLineFlag = UD.graphDataStruct.lineSubToHide(iLineSubType) & HLcheckFlag;
                set(UD.UI.AxPan.LineH(iLineType,iLineSubType),'Visible', OnOff{hideLineFlag+1});
            end
        end
        for iExtraLine = 1:size(UD.graphDataStruct.ExtraLines,2)
            hideLineFlag = UD.graphDataStruct.ExtraLinesToHide(iExtraLine) & HLcheckFlag;
            set(UD.UI.AxPan.ExtraLineH(iExtraLine),'Visible', OnOff{hideLineFlag+1});
        end
    case 'HIDE SUBTEXT'
        HSTcheckFlag = get(UD.UI.Cntrls.hideSubtextCheckbH, 'value') == 1;
        set(UD.UI.cValExplainTxtH(:),'Visible', OnOff{HSTcheckFlag+1});
        
    case 'ZOOM'
        ZoomFlag = get(UD.UI.Cntrls.ZoomH, 'value');
        if ZoomFlag
            set(UD.UI.Cntrls.ZoomH, 'backgroundcolor', [0.7 0.7 0.7]);
            zoom on
        else
            set(UD.UI.Cntrls.ZoomH, 'backgroundcolor', [0.94 0.94 0.94]);
            zoom off
        end
        
    case 'TOGGLE CALC MODE'
        chosenModeVec = UD.UI.Cntrls.CalcModeRadioBH == hObj;
        newModeVal = get(UD.UI.Cntrls.CalcModeRadioBH(chosenModeVec), 'value');
        newModeName = get(UD.UI.Cntrls.CalcModeRadioBH(chosenModeVec), 'string');
        
        if newModeVal
            set(UD.UI.Cntrls.CalcModeRadioBH(~chosenModeVec), 'value',0);
        else
            set(UD.UI.Cntrls.CalcModeRadioBH(chosenModeVec), 'value',1);
        end
        if ~pausedFlag
            MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
            MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        end
        %% SERIOUS BREACH OF PROTOCOL!!!
        switch upper(newModeName)
            case 'COMPETITION'
                set(UD.UI.VarPanH(:), 'visible', 'on');
            case 'FULL DYNAMICS'
                %                 set(UD.UI.VarPanH(:), 'visible', 'on');
                %                 set(UD.UI.VarPanH([UD.ParamVarStruct.ColorGroup] == 2), 'visible', 'off');
            case 'STEADY STATE'
                set(UD.UI.VarPanH(:), 'visible', 'on');
                set(UD.UI.VarPanH([UD.ParamVarStruct.ColorGroup] == 2), 'visible', 'off');
        end
        
    case 'DESCRIPTION'
        temp.Interpreter = 'tex';
        temp.WindowStyle = 'non-modal';
        hh  = msgbox({UD.calculatedVals.Description},'Calculated Values explained','help',temp);
        % helpdlg({UD.calculatedVals.Symbol},'','tex');
        
        ch = get( hh, 'Children' );
        chh = get( ch(2), 'Children' );
        set( chh, 'FontSize', 12 );
        set(hh, 'unit', 'normalized', 'position', [0.2 0.3 0.33 0.45])
        
        
    case 'EQUATIONS'
        temp.Interpreter = 'latex';
        temp.WindowStyle = 'non-modal';
        temp.Resize='on';
        
        %         equationStr = {...
        %             '\rightarrow   \partialc_1(t)/\partialt = c_1(t)\bullet\alpha_{max}\bullet[{r(t)}/{(r(t)+k_1)}]';...
        %             '';...
        %             '\rightarrow   \partialc_2(t)/\partialt = c_2(t)\bullet\alpha_{max}\bullet[{r(t)}/{(r(t)+k_2)}]';...
        %             '';...
        %             '\rightarrow   r(t) = R_d  -[yld_1 \bullet c_1(t)] -[yld_2 \bullet c_2(t)]'}; %update!!
        %         (mu2-mu2min).*(Smat./(k2 + Smat)) + mu2min
        
        equationStr = {...
            %             '$$S(D) = S_d * \frac{(1-\phi)}{1-\phi^{f(\mu_{max},S_d,K_{m1},D)}}$$';...
            '$$\underline{\bf{Sugar:}}$$';...
            '$$S(D) = S_d * \frac{(1-\phi)}{1-\phi^A}$$';...
            '$$[A = -\frac{S_d}{K_m}*(\frac{\mu_{max1}(1-\phi)}{D*ln\phi} + 1)]$$';...
            '';...
            '';...
            '$$\underline{\bf{Monod, Growth Rates:}}$$';...
            '';...
            '$$\mu_1 = \mu1_{max}*(\frac{S(D)}{S(D) + Km_1})$$';...
            '';...
            '$$\mu_2 = (\mu2_{max} - \mu2_{min})*(\frac{S(D)}{S(D)+Km_2})+ \mu2_{min}$$';...
            '';...
            '$$\underline{\bf{Takeover Time:}}$$';...
            '$$ T_{takeover} = \frac{ln(nCells)}{\mu_2 - \mu_1}$$'
            };
        
        %         '$\displaylstyle\frac{A-A(-1)}{Y}$',;
        hh  = msgbox(equationStr,'Underlying equations','help',temp);%,'interpreter','latex');
        set(hh, 'unit', 'normalized', 'position', [0.2 0.2 0.5 0.75])
        
        ch = get( hh, 'Children' );
        chh = get( ch(2), 'Children' );
        set( chh, 'FontSize', 20 );
        
        %         helpdlg(equationStr,'','latex');
    case 'DYNAMICS EQUATIONS'
        temp.Interpreter = 'latex';
        temp.WindowStyle = 'non-modal';
        temp.Resize='on';
        
        equationStr = {...
            %             '$$S(D) = S_d * \frac{(1-\phi)}{1-\phi^{f(\mu_{max},S_d,K_{m1},D)}}$$';...
%             '$$\frac{\delta S(t)}{\delta t} =-\frac{\mu_1}{yld_1}-\frac{\mu_2}{yld_2}$$';...
            '$$\dot S(t) =-\frac{\mu_1}{yld_1}-\frac{\mu_2}{yld_2}$$';...
            '';...
            '$$\mu_1(t) = \mu1_{max}*(\frac{S(t)}{S(t) + Km_1})$$';...
            '$$\mu_2= (\mu2_{max} - \mu2_{min})*(\frac{S(t)}{S(t)+Km_2})+ \mu2_{min}$$';...
            '$$\mu_i(t) = \frac{\dot X_i(t)}{X_i(t)}$$';...
            '';...
            '';...
            '$$S(_{t=0}) = S_{init}; X_1(_{t=0}) = X_{1 init}; X_2(_{t=0}) = X_{2 init}$$';...
            '';...
            '$$\underline{every-dilution-step (t = n\bullet\tau_d):}$$';...
            '';...
            '$$X(t) = \phi X(t-\epsilon)$$';...
            '$$S(t) = \phi S(t-\epsilon) + (1-\phi)S_d$$';...

            };
%                     '$$X_{new} = \phi X_{old}; S_{new} = \phi S_{old} + (1-\phi)S_d$$';...

        
        hh  = msgbox(equationStr,'Dynamics Underlying Equations','help',temp);%,'interpreter','latex');
        set(hh, 'unit', 'normalized', 'position', [0.2 0.2 0.5 0.75])
        
        ch = get( hh, 'Children' );
        chh = get( ch(2), 'Children' );
        set( chh, 'FontSize', 20 );
        
    case 'PAUSE'
        if pausedFlag
            set(UD.UI.Cntrls.PauseH, 'backgroundcolor', [0.9 0.1 0.1], 'string', 'PAUSED');
        else
            set(UD.UI.Cntrls.PauseH, 'backgroundcolor',  [0.94 0.94 0.94], 'string', 'PAUSE');
            MTO_paramVariations_cb([], [], 'SET CVALS', figH, [],[]);
            MTO_paramVariations_cb([], [], 'SET GRAPHS', figH, [],[]);
        end
    otherwise
end


%% OUTPUT
if (nargout >= 1)
    varargout{1} = [];
end
end
