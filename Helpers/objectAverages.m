function [ sigmaAvList, sigmaListStd, lengthAvList, lengthListStd ] = objectAverages( name_root )
%OBJECTAVERAGES Finds average for all objects beginning with name_root
%   Uses whos to find all objects whose names start with name_root, then
%   compiles one list entry for each objects mean sigma, mean length and
%   the respective STDs
    w = evalin('base', 'whos');
    nameArray = {w.name};
    log = cellfun(@(x) strfind( x, name_root), nameArray, ...
                    'UniformOutput', false);
    names = nameArray(cellfun(@(x) ~isempty(x), log));
    disp(names);
    %Preallocate arrays
    sigmaAvList     = zeros(1, length(names));
    sigmaListStd    = zeros(1, length(names));
    lengthAvList    = zeros(1, length(names));
    lengthListStd   = zeros(1, length(names));
    
    for i = 1 : length(names)
        temp_obj        = evalin('base', names{i});
        sigmaAvList(i)  = mean(temp_obj.sigmaAll);
        sigmaListStd(i) = std(temp_obj.sigmaAll);
        lengthAvList(i) = temp_obj.cellSizeAv;
    end

        
end

