function targetHR = reconstruction(xLR,yLR, yHR, TAU, HR_OVERLAP)
% Reconstruct super-resolution image of target face xLR
% INPUT: testing data: xLR has dimension 3x3x7x7x40, 
%        training data: yLR has dimension 3x3x7x7x360, 
%                       yHR has dimension 12x12x7x7x360
% OUTPUT: targetHR is estimation of the HR target face 60x60x40

    % preallocation for speed - TODO make 60 a constant
    xHR = zeros(size(yHR,1), size(yHR,2), size(yHR,3), size(yHR,4), size(xLR,5));
    targetHR = zeros(60, 60, size(xLR,5));
    
    % for each patch of xLR
    for k=1:size(xLR, 5)
        % Calculate the Euclidean distance between every xLR patch with every yLR patch
        d = calcDistance(xLR(:,:,:,:,k), yLR);
        
        % for each patch in xLR(k)
        for i=1:size(xLR,3)
            for j=1:size(xLR,4)
                % solution to objective function for finding optimal w
                C = repmat(double(xLR(:,:,i,j,k)),1,1,size(yLR,5))...
                        -double(squeeze(yLR(:,:,i,j,:)));
                C = reshape(C,[],size(C,3));
                G = C'*C;   % covariance matrix for X(i,j)
                Dmm = diag(squeeze(d(i,j,:)));  % diagonal matrix containing patch (i,j) for all Ym
                w = (G + TAU*(Dmm*Dmm))\ones(size(yLR,5), 1);
                w = w/sum(w);      % normalise w s.t. sum(w) = 1

                % convert w to 12x12x360
                w1 = permute(w, [2 3 1]);
                w1 = repmat(w1, size(yHR,1), size(yHR,2), 1);
                
                % construct HR patch
                xHR(:,:,i,j,k) = sum(squeeze(double(yHR(:,:,i,j,:))).*w1, 3);                
            end
        end
        
        % reconstruct xHR full image from patches
        xk = permute(xHR(:,:,:,:,k), [1 4 2 3]);
        width = size(xHR,1)*size(xHR,3);
        xk = reshape(xk, width, width);
        
        % average overlapping pixels
        startIndex = size(xHR,1) - HR_OVERLAP/2;
        endIndex = startIndex + HR_OVERLAP;
        v = [];
        for i = 1:size(xHR, 3)-1
            xk(startIndex, :) = mean(xk(startIndex:endIndex, :));
            xk(:, startIndex) = mean(xk(:, startIndex:endIndex),2);
            v = cat(1,v, startIndex+1:endIndex);
            startIndex = startIndex + size(xHR,1);
            endIndex = endIndex + size(xHR,1);
        end
        
        % remove extra rows and columns
        xk(v,:) = [];    
        xk(:,v) = [];
        
        targetHR(:,:,k) = xk;
    end
end