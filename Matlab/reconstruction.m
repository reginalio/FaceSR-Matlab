function xHR = reconstruction(xLR,yLR, yHR)
% INPUT: testing data: xLR has dimension 2x2x7x7x40, 
%        training data yLR has dimension 2x2x7x7x360
% OUTPUT:

    d = zeros(size(xLR,3), size(xLR,4), size(yLR,5));

    % for each patch of xLR
    for i=1:size(xLR, 5)
        % Calculate the Euclidean distance between every xLR patch with every yLR patch
        d = calcDistance(xLR(:,:,:,:,i), yLR);
        
        C = xLR(:,:,:,:,i)
        optW = 
        
        
        
    end


end