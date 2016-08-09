classdef Analysis
    %Analysis Class that combines and unifies different experiments
    %   Detailed explanation goes here
    
    properties
        objects;
    end
    
    methods 
        function Ana = Analysis( tagList )
            allVars = evalin('base', 'who');
            log     = cellfun(@(x) isa(evalin('base', x), 'Experiment'), allVars);
            allObj  = cellfun(@(x) evalin('base', x),  allVars(log), 'UniformOutput', false);
            
            for i = 1 : length( tagList )
                try
                    log     = cellfun(@(x) strcmp(x.(tagList{i}{1}), tagList{i}{2}), allObj);
                    allObj  = allObj(log);
                    log     = log(log==1);
                catch
                    disp([tagList{i}{1}, ': ', tagList{i}{2}, ': ', 'No such property']);
                end
            end
            Ana.objects = allObj;
        end
    end
    
    methods (Access = public)
        property_list = get_object_list(Ana, property)
        attributeTable = create_attribute_table( Ana )
        
        %Plotting
        plot_all(Ana, property1, property2)
    end
end

