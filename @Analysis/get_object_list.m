function property_list = get_object_list( Ana, property )
%get_property_list Collects queried property for all experiments
%   Detailed explanation goes here
    property_list{length(Ana.objects)} = [];
    for i = 1 : length(Ana.objects)
        property_list{i} = Ana.objects{i}.(property);
    end

end

