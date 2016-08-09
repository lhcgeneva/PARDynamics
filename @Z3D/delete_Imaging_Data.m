function delete_Imaging_Data(this)
%DELETE_IMAGING_DATA deletes imaging data structures to save space

    if strcmp(this.saveImagingData, 'off')
        this.stackCell = {};
        for i = 1:this.numTPoints
            this.SegmentationCell{i}.delete_Data();
        end
    end

end

