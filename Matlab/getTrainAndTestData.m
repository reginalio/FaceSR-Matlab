function [trainSet, testSet] = getTrainAndTestData(data)

    if(exist('trainAndTestData.mat', 'file')==0)
        disp('getting train and test data...');
        trainSize = 360;
        trainRange = [1, 1674];
        testSize = 40;
        testRange = [1675, 1846];
        
        trainSet.groundTruth = data(:, :, randperm(trainRange(2), trainSize));
        testSet.groundTruth = data(:,:,randperm(diff(testRange)+1, testSize)+trainRange(2));
        
        load('constants.mat', 'LR_SIZE', 'HR_SIZE');
        
        %%% downsample to LR and HR
        trainSet.LR = imresize(trainSet.groundTruth, LR_SIZE);
        trainSet.HR = imresize(trainSet.groundTruth, HR_SIZE);
        
        testSet.LR = imresize(testSet.groundTruth, LR_SIZE);
        testSet.HR = imresize(testSet.groundTruth, HR_SIZE);
        
        %%% obtain patched version
        [trainSet.LR_p, trainSet.HR_p] = divideToPatches(trainSet.LR, trainSet.HR);
        [testSet.LR_p, testSet.HR_p] = divideToPatches(testSet.LR, testSet.HR);
        
        save('trainAndTestData.mat', 'testSet', 'trainSet'); 
    else
        load('trainAndTestData.mat');
    end

end