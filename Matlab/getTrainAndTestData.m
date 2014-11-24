function [trainset, testset] = getTrainAndTestData(dataRandom)

    if(exist('trainAndTestData.mat', 'file')==0)
        trainSize = 360;
        testSize = 40;
        dataRandom = dataRandom(:,:,1:(trainSize+testSize));
        load('constants.mat', 'LR_SIZE', 'HR_SIZE');
        
        %%% downsample to LR and HR
        dataLR = imresize(dataRandom, LR_SIZE);
        dataHR = imresize(dataRandom, HR_SIZE);

        %%% obtain patched version of dataLR and dataHR
        [patchedLR, patchedHR] = divideToPatches(dataLR, dataHR);

        %%% choose training set and testing set
        testset.LR = dataLR(:, :, trainSize+1:end);
        testset.HR_ref = dataHR(:, :, trainSize+1:end);

        trainset.LR_p = patchedLR(:, :, :, :, 1:trainSize);
        trainset.HR_p = patchedHR(:, :, :, :, 1:trainSize);
        testset.LR_p = patchedLR(:, :, :, :, trainSize+1:end);

        save('trainAndTestData.mat', 'testset', 'trainset'); 
    else
        load('trainAndTestData.mat');
    end

end