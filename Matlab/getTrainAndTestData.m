function [trainSet, testSet] = getTrainAndTestData(data)

    if(exist('trainAndTestDataFP.mat', 'file')==0)
        load('parameters.mat');

        disp('getting train and test data...');
        trainSize = 360;
        trainRange = [1, 1674];
        testSize = 40;
        testRange = [1675, 1846];
        
        trainSet.groundTruth = data(:, :, randperm(trainRange(2), trainSize));
        testSet.groundTruth = data(:,:,randperm(diff(testRange)+1, testSize)+trainRange(2));
        
        trainSet.groundTruth = double(trainSet.groundTruth)/255;
        testSet.groundTruth = double(testSet.groundTruth)/255;

        %%% downsample to LR and HR
        trainSet.LR = imresize(trainSet.groundTruth, parameters.LRSize);
        trainSet.HR = imresize(trainSet.groundTruth, parameters.HRSize);
        
        testSet.LR = imresize(testSet.groundTruth, parameters.LRSize);
        testSet.HR = imresize(testSet.groundTruth, parameters.HRSize);
        
        %%% obtain patched version
        [trainSet.LR_p, trainSet.HR_p] = divideToPatches2(trainSet.LR, trainSet.HR, parameters);
        [testSet.LR_p, testSet.HR_p] = divideToPatches2(testSet.LR, testSet.HR, parameters);
        
        save('trainAndTestDataFP.mat', 'testSet', 'trainSet'); 
    else
        load('trainAndTestDataFP.mat');
    end

end