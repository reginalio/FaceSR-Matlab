function optimiseTau
% find result quality for each tau to determine optimial tau
% tau controls the weights of locality constraint

    load('parameters.mat');
    
    maxTau = 1e1;
    tau = 1e-5;
    maxTime = 10000;
    
    SSIMLcR = [];
    pSNRLcR = [];
    
    runTime = [];
    xtau = [];
    
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
    
        disp('getting train and test data...');
        %%% downsample to LR and HR
        trainSet.LR = imresize(trainSet.groundTruth, parameters.LRSize);
        trainSet.HR = imresize(trainSet.groundTruth, parameters.HRSize);
        
        testSet.LR = imresize(testSet.groundTruth, parameters.LRSize);
        testSet.HR = imresize(testSet.groundTruth, parameters.HRSize);
        
        %%% obtain patched version
        start = tic;
        [trainSet.LR_p, trainSet.HR_p] = divideToPatches2(trainSet.LR, trainSet.HR, parameters);
        [testSet.LR_p, testSet.HR_p] = divideToPatches2(testSet.LR, testSet.HR, parameters);
        now = toc(start);

    % determine result quality for each patchWidth
    while tau <= maxTau
        tau = tau*2;
        parameters.tau = tau;
        xtau = [xtau; tau];
        
        %%% reconstruction via LcR
        start = tic;
        resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters.tau, parameters.HROverlap);
        now = toc(start);
        runTime = [runTime; now];

        %%% measure output quality
        SSIMLcR = [SSIMLcR; averageSSIM(resultLcR, testSet.HR)];
        pSNRLcR = [pSNRLcR; averagePSNR(resultLcR, testSet.HR)];
        
        if(sum(runTime)>maxTime)
            break;
        end
    end
    
    
    fname = 'optTau.mat';
    save(fname, 'SSIMLcR', 'pSNRLcR', 'xtau', 'prepTime', 'runTime');

    %%%%% plots %%%%%
     figure;
     hold on;
     plot(xtau, SSIMLcR, 'DisplayName', 'LcR');
     legend('-DynamicLegend');
     xlabel('tau');
     ylabel('Quality of output (SSIM)');
     title('Relationship between tau and Quality of output (SSIM)');
     
     prepTime = repmat(now, length(xtau), 1);
     totalLcRTime = prepTime + runTime;
     figure;
     hold on;
     plot(xtau, totalLcRTime, 'DisplayName', 'Total Time');
     plot(xtau, prepTime, 'DisplayName', 'Prep Time');
     plot(xtau, runTime, 'DisplayName', 'Run Time');
     legend('-DynamicLegend');
     title('How tau affects runtime for LcR');
     xlabel('tau width');
     ylabel('Time taken');
end

