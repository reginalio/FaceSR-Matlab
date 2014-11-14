function targetHR = reconstruction(xLR,yLR, yHR, TAU)
% Reconstruct super-resolution image of target face xLR
% INPUT: testing data: xLR has dimension 3x3x7x7x40, 
%        training data: yLR has dimension 3x3x7x7x360, 
%                       yHR has dimension 12x12x7x7x360
% OUTPUT: xHR is estimation of the HR target face

    xHR = zeros(size(yHR,1), size(yHR,2), size(yHR,3), size(yHR,4), size(xLR,5));
    
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
                
%                 tempXLR = reshape(xLR, [], size(xLR,3),size(xLR,4),size(xLR,5));
%                 tempYLR = reshape(yLR, [], size(yLR,3),size(yLR,4), size(yLR,5));
%                 weightedYLR = (double(squeeze(tempYLR(:,i,j,:)))).*repmat(w,1,9)';               
%                 reconstructionError = sum((double(tempXLR(:,i,j,k)) - sum(weightedYLR,2)).^2);
                
                %%%%% FIX THIS - optW should be a vector of minimised w for
                %%%%% 1:m
%                 optW = fminbnd(@(w) minimiseW(w, reconstructionError, TAU, d, i, j),0,1);
                % or use fminsearch?

                % convert w to 12x12x360
                w1 = permute(w, [2 3 1]);
                w1 = repmat(w1, size(yHR,1), size(yHR,2), 1);
                
                % construct HR patch
                xHR(:,:,i,j,k) = sum(squeeze(double(yHR(:,:,i,j,:))).*w1, 3);                
            end
        end
        
        %TODO reconstruct xHR full image from patches
        % use cat() or vercat() ?
        targetHR(k) = reshape(x)
        
    end


end