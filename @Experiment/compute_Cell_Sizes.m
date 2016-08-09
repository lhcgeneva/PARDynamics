function compute_Cell_Sizes( Exp )
%COMPUTE_CELL_SIZES Gets cellSize for all elements in ProfileArray

    cellSize = zeros(length(Exp.MovieArray), 1);
    for i = 1 : length(Exp.MovieArray)
        Exp.MovieArray(i).cellSize = Exp.MovieArray(i).get_circumference();
        cellSize(i) = Exp.MovieArray(i).cellSize;
    end
    
    Exp.cellSizeAv = mean(cellSize);
    Exp.cellSizeList = cellSize;
end

