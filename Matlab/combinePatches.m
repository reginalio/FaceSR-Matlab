function x = combinePatches(xHR, HR_OVERLAP)
        
        % reconstruct xHR full image from patches
        x = permute(xHR, [1 4 2 3]);
        width = size(xHR,1)*size(xHR,3);
        x = reshape(x, width, width);
        
        % average overlapping pixels
        startIndex = size(xHR,1) - HR_OVERLAP/2;
        endIndex = startIndex + HR_OVERLAP;
        v = [];
        for i = 1:size(xHR, 3)-1
            x(startIndex, :) = mean(x(startIndex:endIndex, :));
            x(:, startIndex) = mean(x(:, startIndex:endIndex),2);
            v = cat(1,v, startIndex+1:endIndex);
            startIndex = startIndex + size(xHR,1);
            endIndex = endIndex + size(xHR,1);
        end
        
        % remove extra rows and columns
        x(v,:) = [];    
        x(:,v) = [];
end