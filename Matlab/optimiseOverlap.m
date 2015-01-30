function optimiseOverlap
% find result quality for each overlap width to determine optimial overlap


    load('parameters.mat');
    
    overlap = [0,1,2];
%     parameters.LRPatch = 4;
%     parameters.HRPatch = 4*parameters.ratio;
    
    SSIMLcR = zeros(1, length(overlap));
    SSIMBI = zeros(1, length(overlap));
    
    pSNRLcR = zeros(1, length(overlap));
    pSNRBI = zeros(1, length(overlap));
    
    prepTime = zeros(1, length(overlap));
    runTime = zeros(1, length(overlap));
    runTimeBI = zeros(1, length(overlap));
    
    % get training and testing data
    if(exist('trainAndTestSetRandom.mat', 'file') == 0)
        data = readDataSet(922);    
        trainSize = 360;
        trainRange = [1, 1674];
        testSize = 40;
        testRange = [1675, 1846];

        trainSet.groundTruth = data(:, :, randperm(trainRange(2), trainSize));
        testSet.groundTruth = data(:,:,randperm(diff(testRange)+1, testSize)+trainRange(2));

        save('trainAndTestSetRandom.mat', 'trainSet', 'testSet');
    else
        load('trainAndTestSetRandom.mat');
    end
    
    % downsample to LR and HR
    trainSet.LR = imresize(trainSet.groundTruth, parameters.LRSize);
    trainSet.HR = imresize(trainSet.groundTruth, parameters.HRSize);

    testSet.LR = imresize(testSet.groundTruth, parameters.LRSize);
    testSet.HR = imresize(testSet.groundTruth, parameters.HRSize);
    
    % determine result quality for each overlap width
    for i = 1:length(overlap)
        disp(strcat('overlap:', num2str(overlap(i))));
        if(overlap(i)>= parameters.LRPatch)
            warning('patch overlap width is greater or equal to patch size');
        end
        
        parameters.LROverlap = overlap(i);
        parameters.HROverlap = overlap(i)*parameters.ratio;
        
        disp('getting patched train and test data...');
        %%% obtain patched version
        start = tic;
        [trainSet.LR_p, trainSet.HR_p] = divideToPatches2(trainSet.LR, trainSet.HR, parameters);
        [testSet.LR_p, testSet.HR_p] = divideToPatches2(testSet.LR, testSet.HR, parameters);
        now = toc(start);
        prepTime(i) = now;
        
        %%% reconstruction via LcR
        start = tic;
        resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters.tau, parameters.HROverlap);
        now = toc(start);
        runTime(i) = now;
        
        start = tic;
        resultBI = bicubicInterpolation(testSet.LR);
        now = toc(start);
        runTimeBI(i) = now;
        
        [widthBI, ~, N] = size(resultBI);
        testSet.HR_BI = imresize(testSet.HR, [widthBI, widthBI]);

        %%% measure output quality
        SSIMLcR(i) = averageSSIM(resultLcR, testSet.HR)
        SSIMBI(i) = averageSSIM(resultBI, testSet.HR_BI)

        pSNRLcR(i) = averagePSNR(resultLcR, testSet.HR)
        pSNRBI(i) = averagePSNR(resultBI, testSet.HR_BI)
        
        
    end
    
    fname = 'optOverlapResultP3.mat';
    save(fname, 'SSIMLcR', 'SSIMBI', 'pSNRLcR', 'pSNRBI', 'overlap', 'prepTime', 'runTime', 'runTimeBI');
    
    %%%%% plots %%%%%
     figure;
     hold on;
     plot(overlap, SSIMLcR, 'DisplayName', 'LcR');
     plot(overlap, SSIMBI, 'DisplayName', 'BI');
     legend('-DynamicLegend');
     xlabel('Overlap width');
     ylabel('Quality of output (SSIM)');
     title('Relationship between Overlap Width and Quality of output (SSIM)');
     
     totalLcRTime = prepTime + runTime;
     figure;
     hold on;
     plot(overlap, totalLcRTime, 'DisplayName', 'Total Time');
     plot(overlap, prepTime, 'DisplayName', 'Prep Time');
     plot(overlap, runTime, 'DisplayName', 'Run Time');
     legend('-DynamicLegend');
     title('How overlap width affects runtime for LcR');
     xlabel('Overlap width');
     ylabel('Time taken');
     
end

function [patchedLR, patchedHR] = divideToPatches2(LR, HR, params)
% divide dataHR/LR to patches -> yHR/LR
    
    % End patch index for each face image
    U = ceil((params.HRSize(1)-params.HROverlap)/(params.HRPatch-params.HROverlap));
    V = U;

    N = size(HR,3);
    stepHR = floor(params.HRSize(1)/U);
    stepLR = floor(params.LRSize(1)/U);

    patchedHR = zeros(params.HRPatch, params.HRPatch, U,V,N, 'uint8');
    patchedLR = zeros(params.LRPatch, params.LRPatch, U,V,N, 'uint8');

   
    for k = 1:N
        for i = 1:U
            for j = 1:V
                rectHR = [(1+(i-1)*stepHR) (1+(j-1)*stepHR) params.HRPatch-1 params.HRPatch-1];
                rectLR = [(1+(i-1)*stepLR) (1+(j-1)*stepLR) params.LRPatch-1 params.LRPatch-1];

                % check for last column and last row of patches
                if (rectHR(1)+rectHR(3)) > params.HRSize
                    rectHR(1) = params.HRSize(1) - params.HRPatch + 1;
                end
                if (rectHR(2)+rectHR(4)) > params.HRSize
                    rectHR(2) = params.HRSize(2) - params.HRPatch + 1;
                end
                
                if (rectLR(1)+rectLR(3)) > params.LRSize
                    rectLR(1) = params.LRSize(1) - params.LRPatch + 1;
                end
                if (rectLR(2)+rectLR(4)) > params.LRSize
                    rectLR(2) = params.LRSize(2) - params.LRPatch + 1;
                end
                
                patchedHR(:,:,i,j,k) = imcrop(HR(:,:,k), rectHR);
                patchedLR(:,:,i,j,k) = imcrop(LR(:,:,k), rectLR);
            end
        end
    end

end