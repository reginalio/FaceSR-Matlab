function [SSIMLcR, pSNRLcR, prepTime, runTime] = optimiseOverlapTAU(tau)
% find result quality for each overlap width to determine optimial overlap
% optimise tau on the way


    load('parameters.mat');
    
    if nargin<1
        tau = parameters.tau;
    end

    overlap = [0,1,2];
    parameters.LRPatch = 3;
    parameters.HRPatch = parameters.LRPatch*parameters.ratio;
    
    SSIMLcR = zeros(length(tau), length(overlap));
%     SSIMBI = zeros(length(tau), length(overlap));
    
    pSNRLcR = zeros(length(tau), length(overlap));
%     pSNRBI = zeros(length(tau), length(overlap));
    
    prepTime = zeros(length(tau), length(overlap));
    runTime = zeros(length(tau), length(overlap));
%     runTimeBI = zeros(1, length(overlap));
    
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
    
    tIndex = 1;
    % determine result quality for each overlap width
    for t = tau
        disp(strcat('tau:', num2str(tau(tIndex))));
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
            [trainSet.LR_p, trainSet.HR_p] = divideToPatches3(trainSet.LR, trainSet.HR, parameters);
            [testSet.LR_p, testSet.HR_p] = divideToPatches3(testSet.LR, testSet.HR, parameters);
            now = toc(start);
            prepTime(i) = now;

            %%% reconstruction via LcR
            start = tic;
            resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                       t, parameters.HROverlap, parameters.HRSize(1));
            now = toc(start);
            runTime(i) = now;

%             start = tic;
%             resultBI = bicubicInterpolation(testSet.LR);
%             now = toc(start);
%             runTimeBI(i) = now;
% 
%             [widthBI, ~, N] = size(resultBI);
%             testSet.HR_BI = imresize(testSet.HR, [widthBI, widthBI]);

            %%% measure output quality
            SSIMLcR(tIndex, i) = averageSSIM(resultLcR, testSet.HR)
%             SSIMBI(tIndex, i) = averageSSIM(resultBI, testSet.HR_BI)

            pSNRLcR(tIndex, i) = averagePSNR(resultLcR, testSet.HR)
%             pSNRBI(tIndex, i) = averagePSNR(resultBI, testSet.HR_BI)


        end
        tIndex = tIndex + 1;
    end
    
    
    %%%%% debug
    figure;
    subplot(1,5,1);
    imshow(resultLcR(:,:,1));
    subplot(1,5,2);
    imshow(resultLcR(:,:,10));
    subplot(1,5,3);
    imshow(resultLcR(:,:,15));
    subplot(1,5,4);
    imshow(resultLcR(:,:,20));
    subplot(1,5,5);
    imshow(resultLcR(:,:,30));
    %%%%%
%     fname = strcat('optOverlapResultP',num2str(length(overlap)),'.mat');
%     save(fname, 'SSIMLcR', 'SSIMBI', 'pSNRLcR', 'pSNRBI', 'overlap', 'prepTime', 'runTime', 'runTimeBI');
%     
%     %%%%% plots %%%%%
%      figure;
%      hold on;
%      plot(overlap, SSIMLcR, 'DisplayName', 'LcR');
%      plot(overlap, SSIMBI, 'DisplayName', 'BI');
%      legend('-DynamicLegend');
%      xlabel('Overlap width');
%      ylabel('Quality of output (SSIM)');
%      title('Relationship between Overlap Width and Quality of output (SSIM)');
%      
%      totalLcRTime = prepTime + runTime;
%      figure;
%      hold on;
%      plot(overlap, totalLcRTime, 'DisplayName', 'Total Time');
%      plot(overlap, prepTime, 'DisplayName', 'Prep Time');
%      plot(overlap, runTime, 'DisplayName', 'Run Time');
%      legend('-DynamicLegend');
%      title('How overlap width affects runtime for LcR');
%      xlabel('Overlap width');
%      ylabel('Time taken');
     
end
