function calculatedVals = MTO_cValCalculator(calculatedVals,paramValues,paramINDXs)

cValNames = {calculatedVals.Names};
nCVals = size(cValNames,2);
finalValues = [calculatedVals.Values];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for ii = 1:length(paramINDXs)
   currFctn = sprintf('%s  = paramValues(%i);',paramINDXs{ii},ii);
   eval(currFctn);
end
%    'D' 'n_mut' 'sd' 'si' 'vt' 'X_init1' 'yld1' 'k1' 'mu1' 'vd' 'X_init2'
%    'yld2' 'k2' 'mu2' 'mu2min' %usableVars

%     'phi'    'muD1_t'    'muD2_t'    'muD2min_t'    'xmax'    'S_0'  %needed



%%   
phi = 1 - vd/vt;

muD1_t = log(2)/mu1;
muD2_t = log(2)/mu2;
mu2min = log(2)/mu2min;

xmax = sd.*yld1;

OD = xmax./0.45;
nCells = OD.*(10^12).* vt;


%%
for iCVal = 1:nCVals
    currName = cValNames{iCVal};
        switch currName
            case 'phi'
                calculatedVals(iCVal).Values = phi;
            case  'Max Doubling Time'
                calculatedVals(iCVal).Values = muD1_t;
            case 'Max Cells'
                calculatedVals(iCVal).Values = xmax;
            case 'OD'
                calculatedVals(iCVal).Values = OD;
            case 'nCells'
                calculatedVals(iCVal).Values = nCells;
                
            case 'S(0)'
                calculatedVals(iCVal).Values = -1;
            case  'Max Doubling Time 2'
                calculatedVals(iCVal).Values = muD2_t;
            case  'Min Doubling Time 2'
                calculatedVals(iCVal).Values = mu2min;
            otherwise
                calculatedVals(iCVal).Values = -98;
        end
end

%[calculatedVals(:).Values] = deal(finalValues(:));

end