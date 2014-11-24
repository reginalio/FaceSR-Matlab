function main

    load('constants.mat', 'TAU', 'HR_OVERLAP');
    
    %%% import database or load data from pre-saved files
    dataRandom = readDataSet(922);    
    [trainset, testset] = getTrainAndTestData(dataRandom);
    
    %%% reconstruct testLR 
    % (1) Face hallucination via LcR
    % (2) Bicubic Interpolation
    % (3) PCA-based method
    resultLcR = reconstruction(testset.LR_p,trainset.LR_p, trainset.HR_p, TAU, HR_OVERLAP);
    resultBI = bicubicInterpolation(testset.LR);
    
    [widthBI, ~, N] = size(resultBI);
    testset.HR_ref_BI = imresize(dataRandom(:,:,1:N), [widthBI, widthBI]);
    
    %%% measure output quality
    SSIMLcR = averageSSIM(resultLcR, testset.HR_ref)
    SSIMBI = averageSSIM(resultBI, testset.HR_ref_BI)
    
    pSNRLcR = averagePSNR(resultLcR, testset.HR_ref)
    pSNRBI = averagePSNR(resultBI, testset.HR_ref_BI)
        

end
