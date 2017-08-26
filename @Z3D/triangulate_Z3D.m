function triangulate_Z3D(this)
%TRIANGULATE_Z3D wraps parfor to do zTriangulation

if this.parallel
    if isempty(gcp('nocreate')); parpool(4, 'IdleTimeout', 600); end 
    parfor tPoint = 1 : this.numTPoints
        TriangulationCell_copy{tPoint} = this.zTriangulation(tPoint);
    end   
    this.TriangulationCell = TriangulationCell_copy;
else
    for tPoint = 1 : this.numTPoints
        this.TriangulationCell{tPoint} = this.zTriangulation(tPoint);
    end
end

end