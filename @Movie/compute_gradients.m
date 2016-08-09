function GradientDataArray = compute_gradients( Mo, sideNames )
%compute_gradients Computes all gradients given in folder of Movie

    GradientArray(length(sideNames)) = GradientData();
    for i = 1 : length(sideNames)
        GradientDataArray(i) = GradientData(sideNames{i}, Mo.segmentationMode, ...
                                    Mo.showGraphs, Mo.pixelSize);
    end
   
end

