function showReconstruction

    load('result.mat');

    limit = size(testset.LR,3);
    step = 5;
    result = resultLcR;
    
    for i = 1:step:limit
        figure(i);
        subplot(1,4,1);
        imshow(uint8(testset.LR(:,:,i)));
        title('Low resolution input');
        subplot(1,4,2);
        imshow(uint8(result(:,:,i)));
        title('Reconstructed face');
        subplot(1,4,3);
        imshow(uint8(testset.HR_ref(:,:,i)));
        title('Ground truth at HR');
        subplot(1,4,4);
        imshow(uint8(testset.groundTruth(:,:,i)));
        title('Ground truth');
    end


end