function resultFace = reconstructionByPca(trainSet, testSet, k)
% Form eigenFaces from LR training data
% Calculate weight vector for inputFace
% reconstruct inputFace
% k is the number of eigenfaces used for reconstruction

% TODO testSet contains multiple faces, this code only works on the first
% image
% TODO set K for number of eigenfaces, a possible parameter to optimise

    trainFacesLR = reshape(trainSet.LR, [225, 360]);
    trainFacesHR = reshape(trainSet.HR, [3600, 360]);
    inputFaceLR = reshape(testSet.LR(:,:,30), [225, 1]);
    N = size(trainFacesLR,2);

%     inputFaceLR = reshape(testSet.LR, [225,40]);
%     inputFaceHR = testSet.HR;

%     imagesc(trainFacesLR);
    meanFaceLR = mean(trainFacesLR, 2);
    meanFaceHR = mean(trainFacesHR, 2);

    L = double(trainFacesLR) - repmat(meanFaceLR, 1, N);
    H = double(trainFacesHR) - repmat(meanFaceHR, 1, N);

    s = cov(L');
    s1 = (L'*L)./N;
    %get eigenvector and eigenvalue matrix, weight vector
    [v,d] = eig(s1); 
    [d1, order] = sort(diag(d), 'descend'); % sort eigenvalues in descending order
    d = d(:,order);
    eigval = diag(d);
    eigval = eigval(end:-1:1);
%     v = fliplr(v);
    v = v(:,order);
    v = normc(v);
    
     E = L*v*sqrt(d);
%     E = normc(E);
    
    eig0 = reshape(meanFaceLR, [15, 15]);
    figure; subplot(4,4,1)
    imagesc(eig0);
    colormap gray;
    for i = 1:15 
        subplot(4,4,i+1) 
        imagesc(reshape(E(:,i),15,15)) 
    end

    


     w = E'*(double(inputFaceLR) - meanFaceLR);
%     w = E'*(double(inputFaceLR) - repmat(meanFaceLR, 1, 40));
    
    %reconstruction LR input
    c = v*sqrt(d)*w;
%     recInput = L*c + repmat(meanFaceLR, 1, 40);
%     recInput1 = reshape(recInput,15, 15, 40);
    recInput = L*c + meanFaceLR;
    recInput1 = reshape(recInput,15, 15);
    %recInput = uint8(reshape(recInput,15,15));

    %reconstruction to HR
%     resultFace = H*c + repmat(meanFaceHR, 1, 40);
%     result1 = reshape(resultFace, 60, 60, 40);
%     resultFace = uint8(reshape(resultFace, 60, 60, 40));
    resultFace = H*c + meanFaceHR;
    result1 = reshape(resultFace, 60, 60);
    resultFace = uint8(reshape(resultFace, 60, 60));    
    
%     %show input and recInput
%     for i = 3:5:25
%         figure;
%         subplot(1,2,1);
%         imshow(testSet.LR(:,:,i));
%         subplot(1,2,2);
%         %imshow(recInput);
%         imagesc(recInput1(:,:,i));
% 
%         %plot
%         figure;
%         subplot(1,2,1);
%         title('input HR');
%         imshow(inputFaceHR(:,:,i));
%         subplot(1,2,2);
%         title('pca result');
%         imagesc(result1(:,:,i));
%         %imshow(result);
%     end

        figure;
        subplot(1,2,1);
        imshow(testSet.LR(:,:,30));
        subplot(1,2,2);
        %imshow(recInput);
        imagesc(recInput1);

        %plot
        figure;
        subplot(1,2,1);
        title('input HR');
        imshow(testSet.HR(:,:,30));
        subplot(1,2,2);
        title('pca result');
        imagesc(result1);
        %imshow(result);
end