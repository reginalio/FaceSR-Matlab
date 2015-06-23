function targetHR = reconstructionWithSort(xLR,yLR, yHR, TAU, HR_OVERLAP, HRwidth, N)
% Reconstruct super-resolution image of target face xLR
% sorts distance between xLR and yLR and only select N training images 
% for reconstruction
% INPUT: testing data: xLR has dimension 3x3x7x7x40, 
%        training data: yLR has dimension 3x3x7x7x360, 
%                       yHR has dimension 12x12x7x7x360
% OUTPUT: targetHR is estimation of the HR target face 60x60x40

    disp('Reconstructing input LR faces...');
    xHR = zeros(size(yHR,1), size(yHR,2), size(yHR,3), size(yHR,4), size(xLR,5));
    targetHR = zeros(HRwidth, HRwidth, size(xLR,5));
    
    if nargin<6
        disp('N not specified, N default to all training images');
        N = size(yLR,5);
    end
    
    numPatches = size(yHR,3)*size(yHR,4);
    U = size(yHR,3);
    LRPatchWidth = size(xLR,1);
    HRPatchWidth = size(yHR,1);
    
    % for each xLR
    for k=1:size(xLR, 5)
        % Calculate the Euclidean distance between every xLR patch with every yLR patch
        d = calcDistance(xLR(:,:,:,:,k), yLR);
        
        % Sort yLR and yHR
        d = reshape(d, numPatches, 360);
        [d, order] = sort(d, 2);
        yLRSort = reshape(yLR, LRPatchWidth,LRPatchWidth,numPatches, 360);
        yHRSort = reshape(yHR, HRPatchWidth,HRPatchWidth,numPatches, 360);
        for p = 1:numPatches
            yLRSort(:,:,p,:) = yLRSort(:,:,p,order(p,:));
            yHRSort(:,:,p,:) = yHRSort(:,:,p,order(p,:));
        end
        yLRSort = reshape(yLRSort,LRPatchWidth,LRPatchWidth,U,U,360);
        yHRSort = reshape(yHRSort,HRPatchWidth,HRPatchWidth,U,U,360); 
        
        yLRSort = yLRSort(:,:,:,:,1:N);
        yHRSort = yHRSort(:,:,:,:,1:N);
        d = reshape(d, U,U, 360);
        d = d(:,:,1:N);

        % for each patch in xLR(k)
        for i=1:size(xLR,3)
            for j=1:size(xLR,4)
                % solution to objective function for finding optimal w
                C = repmat(xLR(:,:,i,j,k),1,1,N)...
                        -squeeze(yLRSort(:,:,i,j,:));
                C = reshape(C,[],size(C,3));
                G = C'*C;   % covariance matrix for X(i,j)
                Dmm = diag(squeeze(d(i,j,:)));  % diagonal matrix containing patch (i,j) for all Ym
                w = (G + TAU*(Dmm*Dmm))\ones(N, 1);
                w = w/sum(w);      % normalise w s.t. sum(w) = 1

                % convert w to 12x12x360
                w1 = permute(w, [2 3 1]);
                w1 = repmat(w1, size(yHRSort,1), size(yHRSort,2), 1);
                
                % construct HR patch
                xHR(:,:,i,j,k) = sum(squeeze(yHRSort(:,:,i,j,:)).*w1, 3);                
            end
        end
        
        % reconstruct xHR full image from patches
        disp(strcat('Combining patches for reconstructed HR face image...', num2str(k)));
        targetHR(:,:,k) = combinePatches(xHR(:,:,:,:,k), HR_OVERLAP, HRwidth);

    end
end