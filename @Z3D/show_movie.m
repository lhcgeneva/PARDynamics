function show_movie( this, pauseTime, export )
%SHOW_MOVIE(this, pauseTime Plots time course of Segmentations
%   Detailed explanation goes here
if nargin == 1; pauseTime = 0.3; end
axis tight;
if export == 1
    for i = 1 : this.numTPoints
        this.plot_triangulation(i, 'raw', 0);
        F(i) = getframe();
        close(gcf);
    end
    v = VideoWriter('exportedMovie.avi');
    v.FrameRate = round(1/pauseTime);
    open(v);
    writeVideo(v,F);
    close(v);
else
    for i = 1 : this.numTPoints
        this.plot_triangulation(i, 'raw', 0);
        pause(pauseTime);
    end
end
end

