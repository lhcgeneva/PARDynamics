function plot_all( Ana, property1, property2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    x = get_property_list( Ana, property1 );
    x = [x{:}];
    y = get_property_list( Ana, property2 );
    y = [y{:}];
    plot(x, y, '.', 'MarkerSize', 20);
    xlabel(property1, 'FontSize', 14);
    ylabel(property2, 'FontSize', 14);
    
end

