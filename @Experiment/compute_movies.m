function compute_movies( Exp )
%COMPUTE_PROFILES generates all Profiles possible from the parent folder
%   Wraps the generation of all individual Profiles in Phase, creates a
%   Profile object for each embryo
    
    if strcmp(Exp.segmentationMode, 'FIJI') || strcmp(Exp.segmentationMode, 'SIMU')
        ProfileArray(length(Exp.subfolders)) = Movie;
        %If only one subfolder exists or parallel computing is switched off
        if length(Exp.subfolders) == 1 || strcmp(Exp.parallel, 'off')
            if ~strcmp(Exp.segmentationMode, 'SIMU')
                for i = 1 : length(Exp.subfolders)
                    ProfileArray(i) = Movie(Exp.subfolders{i}, Exp.segmentationMode, ...
                                            Exp.showGraphs, Exp.pixelSize);
                end
            elseif strcmp(Exp.segmentationMode, 'SIMU')
                for i = 1 : length(Exp.SimulationArray{1})
                    ProfileArray(i) = Movie({Exp.SimulationArray{1}(i), Exp.SimulationArray{2}(i)}, Exp.segmentationMode, ...
                                            Exp.showGraphs, Exp.pixelSize);
                end
            end            
        %If parallel computing is on
        elseif strcmp(Exp.parallel, 'on')
            segmentationMode    = Exp.segmentationMode;
            showGraphs          = Exp.showGraphs;
            subfolders          = Exp.subfolders;
            
            %Start parpool, only necessary number of cores
            %If parpool exists, check whether reusing makes sense
            if isempty(gcp('nocreate'))
                if length(subfolders) == 1    
                    disp('Only one subfolder, parpool probably not appropriate');
                elseif length(subfolders) < Exp.poolSize
                    parpool('local', length(subfolders));
                else
                    parpool('local', Exp.poolSize);
                end

                parfor i = 1 : length(Exp.subfolders)
                    disp(subfolders{i});
                    ProfileArray(i) = Movie(subfolders{i}, segmentationMode, ...
                                            showGraphs, Exp.pixelSize);
                end
            elseif ~isempty(gcp('nocreate'))
                tempPool = gcp;
                if tempPool.NumWorkers < min([length(Exp.subfolders), Exp.poolSize])
                    delete(gcp)
                    if length(subfolders) < Exp.poolSize
                        parpool('local', length(subfolders));
                    else
                        parpool('local', Exp.poolSize);
                    end
                end
                parfor i = 1 : length(Exp.subfolders)
                    disp(subfolders{i});
                    ProfileArray(i) = Movie(subfolders{i}, segmentationMode, ...
                                            showGraphs, Exp.pixelSize);
                end
            end
            %Shut down parpool, commented out, to reuse parpool if running
            %several analyses
%             delete(gcp); 
        else
            disp('No such parallel computing option, see "Phase" properties for more info');
        end
                
    elseif strcmp(Exp.segmentationMode, 'MAT')
        ProfileArray(length(Exp.subfolders)) = Profile;
        for i = 1 : length(Exp.subfolders)
            ProfileArray(i) = Profile(Exp.subfolders(i), Exp.segmentationMode);
        end
    else
        disp('No segmentation mode provided, not computing movies');
    end
    Exp.MovieArray = ProfileArray;
end

