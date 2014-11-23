function main

    load('constants.mat', 'LR_SIZE', 'HR_SIZE', 'TAU');
    %%% import database
    % dataRandom = readDataSet(922);
    load('groundTruth.mat', 'dataRandom');
    
    trainSize = 360;
    testSize = 40;
    dataRandom = dataRandom(:,:,1:(trainSize+testSize));
    
    %%% downsample to LR and HR
    dataLR = imresize(dataRandom, LR_SIZE);
    dataHR = imresize(dataRandom, HR_SIZE);

    %%% choose training set and testing set
    trainLR = dataLR(:, :, 1:trainSize);
    trainHR = dataHR(:, :, 1:trainSize);
    testLR = dataLR(:,:,trainSize+1:end);
    testHR = dataHR(:,:,trainSize+1:end);
    
    
    
    
    
end
