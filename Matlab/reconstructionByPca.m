function result = reconstructionByPca(trainSet, testSet)
% Form eigenFaces from LR training data
% Calculate weight vector for inputFace
% reconstruct inputFace

% TODO testSet contains multiple faces, this code only works on the first
% image
% TODO set K for number of eigenfaces, a possible parameter to optimise


    trainFacesLR = reshape(trainSet.LR, [225, 360]);
    trainFacesHR = reshape(trainSet.HR, [3600, 360]);
    inputFace = reshape(testSet.LR(:,:,1), [225, 1]);
    inputHR = testSet.HR(:,:,1);

    imshow(trainFacesLR)
    meanFaceLR = mean(trainFacesLR, 2);
    meanFaceHR = mean(trainFacesHR, 2);

    L = double(trainFacesLR) - repmat(meanFaceLR, 1, 360);
    H = double(trainFacesHR) - repmat(meanFaceHR, 1, 360);

    %get eigenvector and eigenvalue matrix, weight vector
    [v,d] = eig(L'*L);  
    E = L*v*sqrt(d);    
    w = E'*(double(inputFace) - meanFaceLR);

    %reconstruction LR input
    c = v*sqrt(d)*w;
    recInput = L*c + meanFaceLR;
    recInput1 = reshape(recInput,15,15);
    %recInput = uint8(reshape(recInput,15,15));

    %show input and recInput
    figure;
    subplot(1,2,1);
    imshow(reshape(inputFace,15,15));
    subplot(1,2,2);
    %imshow(recInput);
    imagesc(recInput1);
    
    %reconstruction to HR
    result = H*c + meanFaceHR;
    result1 = reshape(result, 60,60);
    result = uint8(reshape(result,60,60));

    %plot
    figure;
    subplot(1,2,1);
    title('input HR');
    imshow(inputHR);
    subplot(1,2,2);
    title('pca result');
    imagesc(result1);
    %imshow(result);
end