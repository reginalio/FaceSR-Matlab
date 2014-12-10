function showReconstruction

    load('result.mat');

    limit = size(testSet.LR,3);
    step = 5;
    result = resultLcR;
    
    for i = 1:step:limit
        figure(i);
        subplot(1,4,1);
        imshow(uint8(testSet.LR(:,:,i)));
        title('Low resolution input');
        subplot(1,4,2);
        imshow(uint8(result(:,:,i)));
        title('Reconstructed face');
        subplot(1,4,3);
        imshow(uint8(testSet.HR(:,:,i)));
        title('Ground truth at HR');
        subplot(1,4,4);
        imshow(uint8(testSet.groundTruth(:,:,i)));
        title('Ground truth');
    end


end