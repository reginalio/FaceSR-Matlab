function targetHR = reconstructionIterative(xLR, yLR, yHR, params, iterations, kNN)
% INPUT: testing data: xLR has dimension 3x3x7x7x40, 
%        training data: yLR has dimension 3x3x7x7x360, 
%                       yHR has dimension 12x12x7x7x360
% OUTPUT: targetHR is estimation of the HR target face 60x60x40

    if nargin<6
        disp('kNN not specified, kNN default to 1');
        kNN = 1;
    end
    
    disp('Reconstructing input LR faces by Gauss-Seidel method...');
    [LRPatchWidth, ~, U, ~, numTestImages] = size(xLR);
    numTrainImages = size(yLR,5);
    HRPatchWidth = LRPatchWidth*params.ratio;
    
    % reshape input/training LR patches to 1D structure
    xLR1d = reshape(xLR,LRPatchWidth*LRPatchWidth,U*U,numTestImages);
    yLR1d = reshape(yLR,LRPatchWidth*LRPatchWidth,U*U,numTrainImages);
    yHR1d = reshape(yHR,HRPatchWidth*HRPatchWidth,U*U,numTrainImages);
    
    % preallocate xHR
    xHR1d = zeros(HRPatchWidth*HRPatchWidth,U*U);
    targetHR = zeros(params.HRSize(1), params.HRSize(2), numTestImages);
    
    % loop through each test image to be reconstructed
    for k = 1:numTestImages
        % Calculate the Euclidean distance between every xLR patch with every yLR patch
        d = calcDistance(xLR(:,:,:,:,k), yLR);
        d = reshape(d,U*U,numTrainImages);
        
        % initial weight vector for each test image is uniform
        w = repmat(1.0/numTrainImages,numTrainImages,U*U);
        
        % loop through each patch in xLR(k)
        for p = 1:U*U
            
            % solution to objective function for finding optimal w
            C = repmat(xLR1d(:,p,k),1,numTrainImages) - squeeze(yLR1d(:,p,:));
            G = C'*C;   % covariance matrix for X(i,j)
            D = diag(squeeze(d(p,:)));  % diagonal matrix containing patch (i,j) for all Ym
            
            % matrix A for linear system
            A = (G+params.tau*(D*D));            
            tol = 0.1; % tolerance for converence
            
            if (p~=1 && kNN ~= 0)
                w = getInitialWeight(p, U, kNN, w);
            end
            [w(:,p), iter] = GaussSeidel(A, ones(numTrainImages,1), w(:,p), iterations, tol);
            %w(:,p) = conjgrad(A, ones(numTrainImages,1), w(:,p), iterations);
            w(:,p) = w(:,p)/sum(w(:,p));
%             disp(strcat('patch ', num2str(p), ', iterations = ', num2str(iter)));

            w1 = repmat(w(:,p)',HRPatchWidth*HRPatchWidth,1);
            
            % construct HR patch
            xHR1d(:,p) = sum(squeeze(yHR1d(:,p,:)).*w1, 2); 

        end  
            
        % reconstruct xHR full image from patches
        disp(strcat('Combining patches for reconstructed HR face image...', num2str(k)));
        targetHR(:,:,k) = combinePatches(reshape(xHR1d,HRPatchWidth,HRPatchWidth,U,U), ...
            params.HROverlap, params.HRSize(1));   
        
    end

end
