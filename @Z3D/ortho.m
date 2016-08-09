function ortho(this, color, frame)
%ORTHO(color, frame) Wraps orthogonalslicer (Laszlo Balkay) for class Z3D
%   color can be 1 (green) or 2 (red), frame any number between 1 and the
%   number of frames in the stack.
orthogonalslicer(this.stackCell{color}(:, :, :, frame), [this.resolution.x, ...
                                         this.resolution.y, ...
                                         this.resolution.z])

end

