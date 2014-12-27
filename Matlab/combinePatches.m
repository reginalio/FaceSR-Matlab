function x = combinePatches(xHR, HR_OVERLAP)    
% reconstruct xHR full image from patches

        x = permute(xHR, [1 4 2 3]);
        width = size(xHR,1)*size(xHR,3);
        x = reshape(x, width, width);
        
        % average overlapping pixels
        start1 = size(xHR,1) - HR_OVERLAP + 1;
        start2 = start1+HR_OVERLAP;
        v = [];
        for i = 1:size(xHR,3)-1
            x(start1:start2-1, :) = 0.5*(x(start1:start2-1, :)+x(start2:start2+HR_OVERLAP-1, :));
            x(:, start1:start2-1) = 0.5*(x(:, start1:start2-1)+x(:, start2:start2+HR_OVERLAP-1));
            v = cat(1,v,start2:start2+HR_OVERLAP-1);
            start1 = start1 + size(xHR,1);
            start2 = start2 + size(xHR,1);
        end
        
       
%         start1 = size(xHR,1) - HR_OVERLAP/2;
%         endIndex = start1 + HR_OVERLAP;
%         v = [];
%         for i = 1:size(xHR, 3)-1
%             x(start1, :) = mean(x(start1:endIndex, :));
%             x(:, start1) = mean(x(:, start1:endIndex),2);
%             v = cat(1,v, start1+1:endIndex);
%             start1 = start1 + size(xHR,1);
%             endIndex = endIndex + size(xHR,1);
%         end
        
        % remove extra rows and columns
        x(v,:) = [];    
        x(:,v) = [];
end