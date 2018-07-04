function [newGraphData,newGraphExtraData, axisLabels,legendLabels] = MTO_graphDataCalculator(UD,paramValues,paramINDXs, overrideFlag)
% global alx xmax k1 k2 sd initR yld1 yld2
% global waitBarFlag
global mu1 mu2 k1 k2  yld1 yld2 mu2min

if ~exist('overrideFlag', 'var')
    overrideFlag = false;
end

speedX = str2num(get(UD.UI.SpeedEditH,'string'));
if isempty(speedX)
   speedX = 10; 
end
waitBarFlag = true;

lineTypesCell = UD.graphDataStruct.Symbol;
lineSubTypes = UD.graphDataStruct.lineSubTypes;
extraLinesCell = UD.graphDataStruct.ExtraLines;

nLineTypes = size(lineTypesCell,2);
nLineSubTypes = size(lineSubTypes,2);
nExtraLines = size(extraLinesCell,2);

newGraphData = cell(nLineTypes,nLineSubTypes);
newGraphExtraData = cell(nExtraLines,1);

radioModeVals = get(UD.UI.Cntrls.CalcModeRadioBH, 'value');
calcMode = UD.graphDataStruct.CalculationModes{[radioModeVals{:}] == 1};

extraTimeVec = -1;

legendLabels =  cell(nLineTypes + nExtraLines,1) ;
%%
for ii = 1:length(paramINDXs)
    currFctn = sprintf('%s  = paramValues(%i);',paramINDXs{ii},ii);
    eval(currFctn);
end

D; n_mut; sd; si; vt; X_init1; yld1; k1; mu1; vd; X_init2; yld2; k2; mu2; mu2min; %usableVars

%%
cValValues = [UD.calculatedVals.Values];
cValINDXs = {UD.calculatedVals(:).INDX};
for ii = 1:length(cValINDXs)
    currFctn = sprintf('%s  = cValValues(%i);',cValINDXs{ii},ii);
    eval(currFctn);
end

phi; muD1_t; muD2_t; muD2min_t; xmax;% S_0; %cvals

longRunFlag = true;



switch upper(calcMode)
    case {'TAKEOVER', 'SUGAR', 'GROWTH RATES', 'MONOD', 'FULL DYNAMICS'}
        %% setup
        Dvec = [0.0001:0.001:(mu1*0.9)];
        tauVec = (vd./Dvec)./vt;
        
        %% amount of sugar present
        betaVec = -log(phi)./tauVec;
        alphaBetaFactor = mu1./betaVec;
        temp1 = (sd./k1).*(alphaBetaFactor-1);
        temp2 = (1./(1-(phi.^(temp1))));
        SfinCalc = (sd.*(1-phi)./(phi)).*(temp2 - 1);
        SinitCalc = phi.*(SfinCalc) + ((1-phi).*sd);
        
        Smat = zeros(length(Dvec),11);
        
        for iD = 1:length(SinitCalc)
            currTimeFrame = (0:0.1:1).*tauVec(iD);
            currInitC(1) = xmax; %c1(0)
            currInitC(2) = 0; %c2(0)
            currInitC(3) = SinitCalc(iD); %S(0)
            [timeVec,X123] = ode45(@rigid2D,currTimeFrame,[currInitC]);
            Svec = X123(:,3);
            Smat(iD,:) = Svec;
        end
        
        
        %% specific growth rates
        FullGrowthRate1_mean = mu1.*(Smat./(k1 + Smat));
        FullGrowthRate2_mean = (mu2-mu2min).*(Smat./(k2 + Smat)) + mu2min;
        
        FullGrowthRate1_mean = mean(FullGrowthRate1_mean,2);
        FullGrowthRate2_mean = mean(FullGrowthRate2_mean,2);
        
        %% growth rate difference
        DeltaGrowthRate = (FullGrowthRate2_mean - FullGrowthRate1_mean);
        
        %% doublings needed
        OD_2 = X_init2./0.45;
        nCells_2 = OD_2.*(10^12).* vt;
        
        MUTinit = max(1,round(nCells_2)); %1 cell X_init2
        MUTfin = nCells*0.1;  % 10% * volume * 10^12 cells/L
        eta = log(MUTfin./MUTinit);
        
        
        %% takeover time
        TOtime = eta./DeltaGrowthRate;
        TOtime((DeltaGrowthRate(:) < 0)) = inf;
        TOtime = (TOtime./24);
        
        %% mutations time
        nGenerationTillMut = max((n_mut-2).*(30) + 20,0);
        %         mutTime = (nGenerationTillMut./(24*Dvec_small));
        mutTime = (nGenerationTillMut./(24*Dvec))';
        
        
        %% total time
        %                 totalTOtime = TOtime(Dind:end)' + mutTime;
        totalTOtime = TOtime + mutTime;
        
        %     case 'MONOD'
        %         if strcmpi(calcMode, 'MONOD')
        tempS = mean(Smat,2);
        [~,IndD] = min(abs(Dvec - D));
        
        %% monod curves
        %             FullSvec = [0.0001:0.0000001:0.01, 0.011:0.01:tempS(IndD)];
        FullSvec = [0:0.0000001:(2*tempS(IndD))];
        
        monod1 = mu1.*(FullSvec./(k1 + FullSvec));
        monod2 = (mu2 - mu2min).*(FullSvec./(k2 + FullSvec)) + mu2min;
        
        monodDiff= monod2 - monod1;
        tempInd = monodDiff(:) > 0;
        
        monodDiff = monodDiff(tempInd);
        FullSvecDiff = FullSvec(tempInd);
        
        %         plot(ax(3,1), FullSvec, monod1, 'color', WTclr, 'linewidth', 2.5),hold on
        %         plot(ax(3,1), FullSvec, monod2, 'color', MUTclr, 'linewidth', 2.5)
        %         end
end
if strcmpi('FULL DYNAMICS',calcMode)
    %% calculate Competition
    timeVecComp = [];
    cVecComp1 = [];
    cVecComp2 = [];
    rVecComp = [];
    currInitC(1) = X_init1; %c1(0)
    currInitC(2) = X_init2; %c2(0)
    currInitC(3) = si; %S(0)
    %initR = si;
    td = speedX*tauVec(IndD);
    phi2 = 1- td*D;
    iter = ceil(1.5*24*totalTOtime(IndD)./td);
    if isinf(iter)
        errordlg('Takeover Does Not Occur');
        newGraphData = {[]}; newGraphExtraData = {[]}; axisLabels = {[]}; legendLabels = {[]};
        return
    end
    if longRunFlag
        timeVecComp = zeros(3*iter,1);
        cVecComp1   = zeros(3*iter,1);
        cVecComp2   = zeros(3*iter,1);
        rVecComp    = zeros(3*iter,1);
    end
    h = waitbar(0,'Please wait...',  'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    %end
    tt = tic;
    iIter = 1;
    waitBarFlag = true;
    takeoverFinished = false;
    for iIter = 1:iter
        if getappdata(h,'canceling')
            timeVecComp = [];
            cVecComp1   = [];
            cVecComp2   = [];
            rVecComp    = [];
            %             delete(h)
            break
        end
        if waitBarFlag & ~takeoverFinished
            currTimeFrame = [0 td] + td*(iIter-1);
            if longRunFlag
                ind123 = (iIter-1)*3 + 1;
                ind123 = ind123:(ind123+2);
                currTimeFrame = [0 0.5*td td] + td*(iIter-1);
                
                [t_TmpDyn,X_t_TmpDyn] = ode45(@rigid2D,currTimeFrame,[currInitC]);
                timeVecComp(ind123) = t_TmpDyn;
                cVecComp1(ind123)   = X_t_TmpDyn(:,1);
                cVecComp2(ind123)   = X_t_TmpDyn(:,2);
                rVecComp(ind123)    = X_t_TmpDyn(:,3);
                
                currInitC(1) = phi2.*X_t_TmpDyn(end,1); %c1(0)
                currInitC(2) = phi2.*X_t_TmpDyn(end,2); %c1(0)
                currInitC(3) = X_t_TmpDyn(end,3)*phi2 + sd*(1-phi2); %S(0)
                aa = toc(tt);
                waitbar((iIter)/ (iter),h, sprintf('%i seconds remaining', round(aa*(iter/iIter - 1))))
            else
                [t_TmpDyn,X_t_TmpDyn] = ode45(@rigid2D,currTimeFrame,[currInitC]);
                timeVecComp = cat(1,timeVecComp,t_TmpDyn);
                cVecComp1 = cat(1,cVecComp1,X_t_TmpDyn(:,1));
                cVecComp2 = cat(1,cVecComp2,X_t_TmpDyn(:,2));
                %currRvec = initR*phi + sd*(1-phi) - (1./yld).*(X_t_TmpDyn - currInitC) ;
                rVecComp = cat(1,rVecComp,X_t_TmpDyn(:,3));
                
                currInitC(1) = phi.*X_t_TmpDyn(end,1); %c1(0)
                currInitC(2) = phi.*X_t_TmpDyn(end,2); %c1(0)
                currInitC(3) = X_t_TmpDyn(end,3)*phi + sd*(1-phi); %S(0)
                %     currInitC = phi*X_t_TmpDyn(end);
                %     initR = currRvec(end);
                aa = toc(tt);
                waitbar((iIter)/ (iter))
            end
            
            if overrideFlag
                takeoverFinished =  currInitC(2) > currInitC(1)./10;
            end
        end
    end
    extraTimeVec = timeVecComp;
    timeVecComp = timeVecComp./24;
    delete(h)
end

%%
for iLineType = 1:nLineTypes
    currType = lineTypesCell{iLineType};
    for iLineSubType = 1:nLineSubTypes
        currSubType = lineSubTypes{iLineSubType};
        switch upper(calcMode)
            
            case 'MONOD'
                
                currXLabel = 'Sugar Concentration [g/L]';
                currYLabel = 'Growth Rate [1/h]';
                
                switch currType
                    %               switch [currType, ' - ', currSubType]
                    case 'GREEN'
                        currXData = FullSvec';
                        currYData = monod1';
                        currLegendLabel = 'ref strain';
                        
                    case 'BLUE'
                        currXData = FullSvec';
                        currYData = monod2'; %FIX!!!
                        currLegendLabel = 'Mutant';
                        
                    otherwise
                        currXData = nan';
                        currYData = nan';
                        currLegendLabel = ' ';
                        
                end
                
            case 'SUGAR'
                
                currXLabel = 'D [1/h]';
                currYLabel = 'Sugar concentration [g/L]';
                
                switch currType
                    %               switch [currType, ' - ', currSubType]
                    case 'RED'
                        currXData = Dvec';
                        currYData = mean(Smat,2);
                        currLegendLabel = 'sugar concentration';
                        
                    otherwise
                        currXData = nan';
                        currYData = nan';
                        currLegendLabel = ' ';
                        
                end
                
            case 'GROWTH RATES'
                
                currXLabel = 'D [1/h]';
                currYLabel = 'Growth Rates [1/h]';
                
                switch currType
                    %               switch [currType, ' - ', currSubType]
                    case 'GREEN'
                        currXData = Dvec';
                        currYData = FullGrowthRate1_mean;
                        currLegendLabel = 'ref strain';
                        
                    case 'BLUE'
                        currXData = Dvec';
                        currYData = FullGrowthRate2_mean; %FIX!!!
                        currLegendLabel = 'Mutant';
                        
                    otherwise
                        currXData = nan';
                        currYData = nan';
                        currLegendLabel = ' ';
                        
                end
                
            case 'TAKEOVER'
                
                currXLabel = 'D [1/h]';
                currYLabel = 'Takeover Time [days]';
                
                switch currType
                    %               switch [currType, ' - ', currSubType]
                    %                   case 'Takeover(D) - time'
                    case 'BLUE'
                        currXData = Dvec';
                        currYData = TOtime;
                        currLegendLabel = 'Takeover Time(D)';
                    case 'GREEN'
                        currXData = Dvec';
                        currYData = mutTime; %FIX!!!
                        currLegendLabel = 'Mutation Time(D)';
                        
                    case 'RED'
                        currXData = Dvec';
                        currYData = totalTOtime;
                        currLegendLabel = 'Total Time(D)';
                        
                    otherwise
                        currXData = nan';
                        currYData = nan';
                        currLegendLabel = ' ';
                        
                end
                
            case 'FULL DYNAMICS'
                
                currXLabel = 'Time [days]';
                currYLabel = 'Concentration [g/L]';
                
                switch currType
                    %               switch [currType, ' - ', currSubType]
                    case 'GREEN'
                        currXData = timeVecComp;
                        currYData = cVecComp1;
                        currLegendLabel = 'ref strain';
                        
                    case 'BLUE'
                        currXData = timeVecComp;
                        currYData = cVecComp2; %FIX!!!
                        currLegendLabel = 'Mutant';
                        
                    case 'RED'
                        currXData = timeVecComp;
                        currYData = rVecComp; %FIX!!!
                        currLegendLabel = 'Sugar';
                        
                    otherwise
                        currXData = nan';
                        currYData = nan';
                        currLegendLabel = ' ';
                        
                end
                
            otherwise
                currXData = nan';
                currYData = nan';
                currXLabel = 'no X';
                currYLabel = 'no Y';
                currLegendLabel = ' ';
        end
        
        newGraphData{iLineType,iLineSubType} = cat(2,currXData,currYData);
        legendLabels{iLineType} = currLegendLabel;
    end
end

axisLabels = {currXLabel,currYLabel};

for iExtraLine = 1:nExtraLines
    currExtraType = extraLinesCell{iExtraLine};
    switch upper(calcMode)
        case 'TAKEOVER'
            switch currExtraType
                case 'mumax1'
                    currXData = [mu1 mu1]';
                    currYData = [0 max(totalTOtime(~isinf(totalTOtime(:))))]';
                    currLegendLabel = '\mu1_{max}';
                case 'mumax2'
                    currXData = [mu2 mu2]';
                    currYData = [0 max(totalTOtime(~isinf(totalTOtime(:))))]';
                    currLegendLabel = '\mu2_{max}';
                case 'Ref. D'
                    currXData = [D,D]';
                    currYData = [0 max(totalTOtime(~isinf(totalTOtime(:))))]';
                    currLegendLabel = 'S at Ref. D';
                otherwise
                    currXData = [nan nan]';
                    currYData = [nan nan]';
                    currLegendLabel = ' ';
            end
        case 'MONOD'
            switch currExtraType
                case 'mumax1'
                    currXData = [0 max(FullSvec)]';
                    currYData = [mu1 mu1]';
                    currLegendLabel = '\mu1_{max}';
                case 'mumax2'
                    currXData = [0 max(FullSvec)]';
                    currYData = [mu2 mu2]';
                    currLegendLabel = '\mu2_{max}';
                    
                    currXData =   FullSvecDiff';
                    currYData = (monodDiff)';
                    currLegendLabel = 'monod diff';
                    
                case 'Ref. D'
                    currXData = [tempS(IndD),tempS(IndD)]';
                    currYData = [0, max(mu2,mu1)]';
                    currLegendLabel = 'S at Max. D';
                    
                    %                     currXData =   FullSvecDiff';
                    %                     currYData = (monodDiff)';
                    %                     currLegendLabel = '\monod diff';
                otherwise
                    currXData = [nan nan]';
                    currYData = [nan nan]';
                    currLegendLabel = ' ';
            end
        case 'SUGAR'
            switch currExtraType
                case 'Ref. D'
                    currXData = [0,D]';
                    currYData = [tempS(IndD),tempS(IndD)]';
                    currLegendLabel = 'S at Ref. D';
                    
                otherwise
                    currXData = [nan nan]';
                    currYData = [nan nan]';
                    currLegendLabel = ' ';
            end
        case 'FULL DYNAMICS'
            switch currExtraType
                case 'mumax1'
                    currXData = timeVecComp;
                    currYData = cVecComp1 + cVecComp2;
                    currLegendLabel = 'Total Biomass';
                otherwise
                    currXData = [nan nan]';
                    currYData = [nan nan]';
                    currLegendLabel = ' ';
            end
        case 'GROWTH RATES'
            switch currExtraType
                case 'Ref. D'
                    currXData = [D,D]';
                    currYData = [0, max(mu2,mu1)]';
                    currLegendLabel = 'S at Ref. D';
                otherwise
                    currXData = [nan nan]';
                    currYData = [nan nan]';
                    currLegendLabel = ' ';
            end
        otherwise
            currXData = [nan nan]';
            currYData = [nan nan]';
            currLegendLabel = ' ';
            
            
    end
    newGraphExtraData{iExtraLine} = cat(2,currXData,currYData);
    legendLabels{iExtraLine + nLineTypes} = currLegendLabel;
end


end


function dy = rigid(t,y)
global alx xmax k1 sd initR
% alx = 0.5;
% xmax = 7;
% k= 0.5;
% sd = 10;
dy = zeros(1);
dy(1) = alx*y(1)*((y(1)/xmax - 1)*((y(1)/xmax - (1+k1/sd)).^-1));
end




function waitBarFlagSwitch()
global waitBarFlag
waitBarFlag = false;
end


function dy = rigid2D(t,y)
global mu1 mu2 k1 k2  yld1 yld2 mu2min

dy = zeros(3,1);
dy(1) = y(1).*mu1.*(y(3)./(y(3) + k1)); %c1 dot
dy(2) = y(2).*((mu2-mu2min).*(y(3)./(y(3) + k2)) + mu2min); %c1 dot
dy(3) = ...
    -((1./yld1).*y(1).*mu1.*(y(3)./(y(3) + k1)))...
    -((1./yld2).*(y(2).*((mu2-mu2min).*(y(3)./(y(3) + k2)) + mu2min))); %r dot



% dy(3) = ...
%     -((1./yld1).*y(1).*mu1.*(y(3)./(y(3) + k1)))...
%     -((1./yld2).*y(2).*mu2); %r dot

% function dy = rigid2D(t,y)
% global alx k1 k2  yld1 yld2
%
% dy = zeros(3,1);
% dy(1) = y(1).*alx.*(y(3)./(y(3) + k1)); %c1 dot
% dy(2) = y(2).*alx.*(y(3)./(y(3) + k2)); %c2 dot
% dy(3) = ...
%     -((1./yld1).*y(1).*alx.*(y(3)./(y(3) + k1)))...
%     -((1./yld2).*y(2).*alx.*(y(3)./(y(3) + k2))); %r dot
%
%
% end


end
