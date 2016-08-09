function list_Sigmas( Exp )
%CALC_SIGMAS Lists sigmas from all movies
%   After sigmas have been found statistics are calculated, cell arrays are
%   then converted to arrays.

%%  Read out fitted sigma for each slice, ordered by movie in cell array
%   Also gets cellSize (circumference)
    cellSizeArray{length(Exp.MovieArray)} = [];
    for i = 1:length(Exp.MovieArray)
        Exp.sigmaList{i}    = cell2mat(cellfun(@(x) x.curve.s, ...
            {Exp.MovieArray(i).Side1(:).Grad_Fit}, 'UniformOutput', false));
        Exp.sigmaListNate{i}    = cell2mat(cellfun(@(x) x.curve_Nate.m, ...
            {Exp.MovieArray(i).Side1(:).Grad_Fit}, 'UniformOutput', false));
        cellSizeArray{i} = Exp.MovieArray(i).cellSize;
        if ~isempty(Exp.MovieArray(i).side2Name)
            Exp.sigmaList{length(Exp.MovieArray) + i}    = cell2mat(cellfun(@(x) x.curve.s, ...
                {Exp.MovieArray(i).Side2(:).Grad_Fit}, 'UniformOutput', false));
            Exp.sigmaListNate{length(Exp.MovieArray) + i}    = cell2mat(cellfun(@(x) x.curve_Nate.m, ...
                {Exp.MovieArray(i).Side2(:).Grad_Fit}, 'UniformOutput', false));
            cellSizeArray{length(Exp.MovieArray) + i} = [Exp.MovieArray(i).cellSize];
        end
    end
    Exp.sigmaList       = cellfun(@(x) abs(x) * Exp.pixelSize, Exp.sigmaList, ...
                        'UniformOutput', false);
    Exp.sigmaListNate   = cellfun(@(x) sqrt(2)./abs(x), Exp.sigmaListNate, ...
                        'UniformOutput', false);
%   Converting to arrays
    Exp.cellSizeList    = [cellSizeArray{:}];
    Exp.sigmaAll        = [Exp.sigmaList{:}];
    Exp.sigmaAllNate    = [Exp.sigmaListNate{:}];
    
%%  Calculate statistics                   
    Exp.sigmaAv     = cellfun(@(x) mean(x), Exp.sigmaList, ...
                        'UniformOutput', false);
    Exp.sigmaAv     = [Exp.sigmaAv{:}];   
    
    Exp.sigmaAvNate     = cellfun(@(x) mean(x), Exp.sigmaListNate, ...
                        'UniformOutput', false);
    Exp.sigmaAvNate     = [Exp.sigmaAvNate{:}];
    
    Exp.sigmaStd    = cellfun(@(x) std(x), Exp.sigmaListNate, ...
                        'UniformOutput', false);
    Exp.sigmaStd    = [Exp.sigmaStd{:}];
    
    Exp.sigmaStdErr = cellfun(@(x) std(x)/sqrt(length(x)), Exp.sigmaList, ...
                        'UniformOutput', false);         
    Exp.sigmaStdErr = [Exp.sigmaStdErr{:}];  
    
    [Exp.lambda, Exp.lambda_conf_int] = poissfit(Exp.sigmaAll); 
    [Exp.lambdaNate, Exp.lambda_conf_int_Nate] = poissfit(Exp.sigmaAllNate); 
    
    Exp.lambdaStd       = std(Exp.sigmaAv);
    Exp.lambdaStdNate   = std(Exp.sigmaAvNate);
    
    Exp.lambdaStdErr= Exp.lambdaStd/sqrt(length(Exp.sigmaAv));
    
%% Filter statistics (remove outliers further than 2 std from mean)
    Exp.sigmaListFiltered   = cellfun(@(x) x(x>mean(x)-2*std(x)&x<mean(x)+2*std(x)), ...
                                Exp.sigmaList, 'UniformOutput', false);
    
    Exp.sigmaAvFiltered     = cellfun(@(x) mean(x), Exp.sigmaListFiltered, ...
                                'UniformOutput', false);
    Exp.sigmaAvFiltered     = [Exp.sigmaAvFiltered{:}];
    
    Exp.sigmaStdFiltered    = cellfun(@(x) std(x), Exp.sigmaListFiltered, ...
                                'UniformOutput', false);
    Exp.sigmaStdFiltered    = [Exp.sigmaStdFiltered{:}];
    
    Exp.sigmaStdErrFiltered = cellfun(@(x) std(x)/sqrt(length(x)), ...
                                Exp.sigmaListFiltered, 'UniformOutput', false);         
    Exp.sigmaStdErrFiltered = [Exp.sigmaStdErrFiltered{:}]; 
    
    Exp.cellSizeAv          = nanmean([Exp.MovieArray.cellSize]);
end

