function S = retrieve_sigmas(Mo, retrievingRange)
%RETRIEVE_SIGMAS Takes array of indices, retrieves sigmas from Side1/2
%   Also gets length if available from folder (Segmentation location)
    try
        Mo.retrievingRange = retrievingRange;
        %Get Sigmas
        QueryFits1 = [Mo.Side1{[end-retrievingRange(1),...
                                    end-retrievingRange(2),...
                                    end-retrievingRange(3)]}];
        QueryFits2 = [Mo.Side2{[end-retrievingRange(1),...
                                    end-retrievingRange(2),...
                                    end-retrievingRange(3)]}];
        S = [QueryFits1.sigmaInMicrons; QueryFits2.sigmaInMicrons];
        Mo.retrievedSigmas = S;
        Mo.retrievedSigmasAv = nanmean(S(:));
        %Get Slopes
        Slopes = [QueryFits1.normSlope; QueryFits2.normSlope];
        Mo.retrievedSlopes = Slopes;
        Mo.retrievedSlopesAv = nanmean(Slopes(:));
        %Get Lengths
        QueryLengths = Mo.folder.Imr_s{1}([end-retrievingRange(1),...
                                            end-retrievingRange(2),...
                                            end-retrievingRange(3)]);
        if length(retrievingRange) ~= 3
            disp('Lengths not properly calculated in retrieve_sigams.m!');
        end
        sz = cellfun(@size, QueryLengths, 'UniformOutput', false);
        %Only use the sizes which actually had a sigma that's not nan!!!
        %Otherwise the length average is off in the end
        Lengths = cellfun(@(x) x(2), sz) * Mo.pixelSize;
        Mo.retrievedLengths = [Lengths; Lengths]; %Make the same size as retrievedSigmas
        
        Mo.retrievedLengths(isnan(Mo.retrievedSigmas)) = nan;
        Mo.retrievedLengthsAv = nanmean(Mo.retrievedLengths(:));
    catch
        disp('Movie does not exist or retrieving Range out of bounds.');
    end
end

