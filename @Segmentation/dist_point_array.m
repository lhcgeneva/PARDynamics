function dist = dist_point_array(point, array )
%DIST_POINT_ARRAY Computes vector of distances between point and array
%   TO DO: Generalize?

p = repmat(point, size(array, 1), 1);
diff = p-array;
dist = sqrt(diff(:,1).^2+(diff(:,2).^2));

end

