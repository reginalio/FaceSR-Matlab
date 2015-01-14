function showReconstruction

    load('resultSort.mat');

    limit = size(testSet.LR,3);
    step = 5;
    result = resultLcR;
    
    for i = 1:step:limit
        figure(i);
        subplot(1,4,1);
        imshow(testSet.LR(:,:,i));
        title('Low resolution input');
        subplot(1,4,2);
        imshow(result(:,:,i));
        title('Reconstructed face');
        subplot(1,4,3);
        imshow(testSet.HR(:,:,i));
        title('Ground truth at HR');
        subplot(1,4,4);
        imshow(testSet.groundTruth(:,:,i));
        title('Ground truth');
    end


end