function create_Fiji_Outline(  )
%CREATE_FIJI_OUTLINE creates Frames_Fiji.mat 
%   Takes ROI file and creates an outline readable for Peter's code, using 
%   the Bresenham algorithm
    ROI_file = dir('*.txt');

    for jj = 1 : length(ROI_file)  
        if ~strcmp(ROI_file(jj).name, 'poles_and_timing.txt')
            pos_arr = load(ROI_file(jj).name);
            xf = [];
            yf = [];
            for iii = 1:length(pos_arr(:,1))
                if iii < length(pos_arr(:,1))
                    [xi, yi] = bresenham(pos_arr(iii, 1), pos_arr(iii, 2), pos_arr(iii+1, 1), pos_arr(iii+1, 2));
                elseif iii == length(pos_arr(:,1))
                    [xi, yi] = bresenham(pos_arr(iii, 1), pos_arr(iii, 2), pos_arr(1, 1), pos_arr(1, 2));
                end
                xf = [xf; xi];
                yf = [yf; yi];
            end
            Frame(1,jj).Cell(:,2) = xf;
            Frame(1,jj).Cell(:,1) = yf;
            plot(Frame(1,jj).Cell(:,2),Frame(1,jj).Cell(:,1));
            save('Frames_Fiji.mat');
        end
    end

end

