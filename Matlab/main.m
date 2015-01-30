function main

    load('constants.mat', 'TAU', 'HR_OVERLAP');
    
    %%% import database or load data from pre-saved files
    data = readDataSet(922);   
    [trainSet, testSet] = getTrainAndTestData(data);
    
    %%% reconstruct testLR 
    % (1) Face hallucination via LcR
    % (2) Bicubic Interpolation
    % (3) PCA-based method
%     resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
%                    TAU, HR_OVERLAP);
    resultLcR = reconstructionWithSort(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   TAU, HR_OVERLAP, 200);
               
    resultBI = bicubicInterpolation(testSet.LR);
    
    [widthBI, ~, N] = size(resultBI);
    testSet.HR_BI = imresize(testSet.groundTruth(:,:,1:N), [widthBI, widthBI]);
    
    %%% measure output quality
    SSIMLcR = averageSSIM(resultLcR, testSet.HR)
    SSIMBI = averageSSIM(resultBI, testSet.HR_BI)
    
    pSNRLcR = averagePSNR(resultLcR, testSet.HR)
    pSNRBI = averagePSNR(resultBI, testSet.HR_BI)
    
    clearvars 'data'
    save('resultSort.mat');
end
