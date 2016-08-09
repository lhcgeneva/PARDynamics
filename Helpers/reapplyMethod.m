%REAPPLYMETHOD script to apply same method on all objects of a certain name
%in workspace (default: list_Sigmas is applied to 'Experiment' instances)

vars = whos();
location = strcmp('Experiment', {vars.class});
names = {vars(location).name};
objects(length(names)) = eval(names{1});
for n = 1:length(names)
   objects(n) = eval(names{n});
   objects(n).list_Sigmas;
end
