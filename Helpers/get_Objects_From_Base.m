function out = get_Objects_From_Base(classname)
     baseVariables = evalin('base' , 'whos');
     out = cell(0);
     for i = 1:length(baseVariables)
         if (strcmpi(baseVariables(i).class , classname)) % compare classnames
             out{length(out) +1}  = baseVariables(i).name;
         end  
     end
end 