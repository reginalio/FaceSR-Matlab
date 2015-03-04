function main

    load('constants.mat', 'TAU', 'HR_OVERLAP');
    load('parameters.mat');
    %%% import database or load data from pre-saved files
    data = readDataSet(922);   
    [trainSet, testSet] = getTrainAndTestData(data);
    
    
%     % get training and testing data
%     if(exist('trainAndTestSetRandom.mat', 'file') == 0)
%         data = readDataSet(922);    
%         trainSize = 360;
%         trainRange = [1, 1674];
%         testSize = 40;
%         testRange = [1675, 1846];
% 
%         trainSet.groundTruth = data(:, :, randperm(trainRange(2), trainSize));
%         testSet.groundTruth = data(:,:,randperm(diff(testRange)+1, testSize)+trainRange(2));
% 
%         save('trainAndTestSetRandom.mat', 'trainSet', 'testSet');
%     else
%         load('trainAndTestSetRandom.mat');
%     end
%     
%     % downsample to LR and HR
%     trainSet.LR = imresize(trainSet.groundTruth, parameters.LRSize);
%     trainSet.HR = imresize(trainSet.groundTruth, parameters.HRSize);
% 
%     testSet.LR = imresize(testSet.groundTruth, parameters.LRSize);
%     testSet.HR = imresize(testSet.groundTruth, parameters.HRSize);
%     
%     %%% obtain patched version
%     start = tic;
%     [trainSet.LR_p, trainSet.HR_p] = divideToPatches3(trainSet.LR, trainSet.HR, parameters);
%     [testSet.LR_p, testSet.HR_p] = divideToPatches3(testSet.LR, testSet.HR, parameters);
%     now = toc(start);
%     prepTime = now;
    
    %%% reconstruct testLR 
    % (1) Face hallucination via LcR
    % (2) Bicubic Interpolation
    % (3) PCA-based method
    resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters.tau, parameters.HROverlap, parameters.HRSize(1));
%     resultLcR = reconstructionWithSort(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
%                    TAU, HR_OVERLAP, 200);
    
    resultLcRIter = reconstructionIterative(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters, 10);
               
    resultBI = bicubicInterpolation(testSet.LR);
    
    [widthBI, ~, N] = size(resultBI);
    testSet.HR_BI = imresize(testSet.groundTruth(:,:,1:N), [widthBI, widthBI]);
    
    %%% measure output quality
    SSIMLcR = averageSSIM(resultLcR, testSet.HR)
    SSIMLcRIter = averageSSIM(resultLcRIter,testSet.HR)
    SSIMBI = averageSSIM(resultBI, testSet.HR_BI)
    
    pSNRLcR = averagePSNR(resultLcR, testSet.HR)
    pSNRBI = averagePSNR(resultBI, testSet.HR_BI)
    
    clearvars 'data'
    save('resultSort.mat');
end
