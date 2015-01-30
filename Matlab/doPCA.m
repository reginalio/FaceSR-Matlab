function [w, w2] = doPCA(trainSet, testSet, k)
% Form eigenFaces from LR training data
% Calculate weight vector for inputFace
% reconstruct inputFace
% k is the number of eigenfaces used for reconstruction

% TODO testSet contains multiple faces, this code only works on the first
% image
% TODO set K for number of eigenfaces, a possible parameter to optimise

    [lh, lw, N] = size(trainSet.LR);
    [hh, hw, ~] = size(trainSet.HR);
    trainFacesLR = double(reshape(trainSet.LR, [lh*lw, N]));
    trainFacesHR = double(reshape(trainSet.HR, [hh*hw, N]));
    testFaceLR = double(reshape(testSet.LR(:,:,30), [lh*lw, 1]));
    testFaceLR2 = double(reshape(testSet.LR(:,:,12), [lh*lw, 1]));
    
    meanFaceLR = mean(trainFacesLR, 2);
    meanFaceHR = mean(trainFacesHR, 2);

    L1 = trainFacesLR - repmat(meanFaceLR, 1, N);

    s1 = (L1'*L1)./N;
    %get eigenvector and eigenvalue matrix, weight vector
    [v,d] = eig(s1); 
    [d1, order] = sort(diag(d), 'descend'); % sort eigenvalues in descending order
    d = d(:,order);
    eigval = diag(d);
    eigval = eigval(end:-1:1);
%       v = fliplr(v);
     v = v(:,order);
    L1 = L1*v;
    eig0 = reshape(meanFaceLR, [15, 15]);
    figure; subplot(5,5,1)
    imagesc(eig0);
    colormap gray;
    for i = 1:24 
        subplot(5,5,i+1) 
        imagesc(reshape(L1(:,i),15,15)) 
    end
    
    
    
    
    L = pca(trainFacesLR', 'Algorithm', 'eig');
    eig0 = reshape(meanFaceLR, [15, 15]);

    figure; subplot(5,5,1)
    imagesc(eig0);
    colormap gray;
    for i = 1:24 
        subplot(5,5,i+1) 
        imagesc(reshape(L(:,i),15,15)) 
    end
    
    L = L(:,1:k);
    w = L'*(testFaceLR - meanFaceLR);
    r = L*w + meanFaceLR;
    
    % show reconstructed LR face
    figure; subplot(1,2,1);
    imagesc(testSet.LR(:,:,30));
    colormap gray;
    subplot(1,2,2);
    imagesc(reshape(r, 15,15));

    % Find H
    H1 = trainFacesHR - repmat(meanFaceHR, 1, N);
    H = pca(trainFacesHR');
    H = [meanFaceHR H];
    for i = 1:25 
        subplot(5,5,i) 
        imagesc(reshape(H(:,i),60,60)) 
    end
    H = H(:,1:length(w));
    result = H*w + meanFaceHR;

    
    %plot
    figure;
    subplot(1,2,1);
    title('input HR');
    imshow(testSet.HR(:,:,30));
    subplot(1,2,2);
    title('pca result');
    imagesc(reshape(result,60,60));
    %imshow(result);
        
        
    w2 = L'*(testFaceLR2 - meanFaceLR);
    r2 = L*w2 + meanFaceLR;
    
    % show reconstructed LR face
    figure; subplot(1,2,1);
    imagesc(testSet.LR(:,:,12));
    colormap gray;
    subplot(1,2,2);
    imagesc(reshape(r2, 15,15));

    % Find H
    result2 = H*w2 + meanFaceHR;

    
        %plot
        figure;
        subplot(1,2,1);
        title('input HR');
        imshow(testSet.HR(:,:,12));
        subplot(1,2,2);
        title('pca result');
        imagesc(reshape(result2,60,60));
        %imshow(result);
end