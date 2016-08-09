function set_geometry( Seg, mode )
%SET_GEOMETRY Wraps define_geometry and associated definitions
%   Because figures are not stored with instance of class g is given back
%   as a temporary variable, as figures only exist during execution.
if numel(Seg.sz_all) == 2
    Seg.sz_all(3) = 1;
end

Seg.midpoint{Seg.sz_all(3)}     = [];
Seg.minorRadius{Seg.sz_all(3)}  = [];
Seg.majorRadius{Seg.sz_all(3)}  = [];
Seg.MergeBuff{Seg.sz_all(3)}    = [];
zProj                           = mean(Seg.Merge(:, :, :), 3);
    
if Seg.sz_all(1) < Seg.sz_all(2)
    for i = 1 : Seg.sz_all(3)
        Seg.MergeBuff{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                Seg.Merge(:, :, i); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
        Seg.channels{1}{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                Seg.channels{1}{i}(:, :); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
        if length(Seg.filename) == 2
            Seg.channels{2}{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                Seg.channels{2}{i}(:, :); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
        end
    end
    zProj = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                zProj; zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
    disp('Image padded with zeros to make square.');
elseif Seg.sz_all(1) > Seg.sz_all(2)
    for i = 1 : Seg.sz_all(3)
        Seg.MergeBuff{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                        Seg.sz_all(2))/2)), Seg.Merge(:, :, i), zeros(Seg.sz_all(1), ...
                        ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
        Seg.channels{1}{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                        Seg.sz_all(2))/2)), Seg.channels{1}{i}(:, :), zeros(Seg.sz_all(1), ...
                        ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
        if length(Seg.filename) == 2
            Seg.channels{2}{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                        Seg.sz_all(2))/2)), Seg.channels{2}{i}(:, :), zeros(Seg.sz_all(1), ...
                        ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
        end
    end
    zProj = [   zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)), ...
                zProj, zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
    disp('Image padded with zeros to make square.');
else 
    for i = 1 : Seg.sz_all(3)
        Seg.MergeBuff{i} = Seg.Merge(:, :, i);
    end
    disp('Image is square');
end

if nargin == 1
    for jj = 1 : Seg.sz_all(3)
        [ Seg.midpoint{jj}, Seg.minorRadius{jj}, Seg.majorRadius{jj}, ...
            Seg.MergeBuff{jj} ] = Seg.define_geometry( Seg.MergeBuff{jj}(:, :), 0 );
    end
elseif nargin == 2
    if strcmp(mode, 'PROJECT')
        [ Seg.midpoint{1}, Seg.minorRadius{1}, Seg.majorRadius{1}, ...
            ~ ] = Seg.define_geometry( zProj, 0 );
        Seg.midpoint(:)     = Seg.midpoint(1);   
        Seg.minorRadius(:)  = Seg.minorRadius(1);
        Seg.majorRadius(:)  = Seg.majorRadius(1);
        disp('Stack projected.');
    else disp([mode, ' is not a known mode for set_geometry().']);
    end
end
close all;
end

