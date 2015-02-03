function optimiseTau
% find result quality for each tau to determine optimial tau
% tau controls the weights of locality constraint

    load('parameters.mat');
    
    maxTau = 1e1;
    tau = 1e-5;
    maxTime = 1000;
    
    SSIMLcR = [];
    pSNRLcR = [];
    
    runTime = [];
    xtau = [];
    
    %%% import database or load data from pre-saved files
    data = readDataSet(922);   
    [trainSet, testSet] = getTrainAndTestData(data);
        
    %%% obtain patched version
    start = tic;
    [trainSet.LR_p, trainSet.HR_p] = divideToPatches3(trainSet.LR, trainSet.HR, parameters);
    [testSet.LR_p, testSet.HR_p] = divideToPatches3(testSet.LR, testSet.HR, parameters);
    now = toc(start);
    prepTime = now;
        
    % determine result quality for each patchWidth
    while tau <= maxTau
        tau = tau*2;
        parameters.tau = tau;
        xtau = [xtau; tau];
        
        %%% reconstruction via LcR
        start = tic;
        resultLcR = reconstruction(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters.tau, parameters.HROverlap, parameters.HRSize(1));
        now = toc(start);
        runTime = [runTime; now];

        %%% measure output quality
        SSIMLcR = [SSIMLcR; averageSSIM(resultLcR, testSet.HR)];
        pSNRLcR = [pSNRLcR; averagePSNR(resultLcR, testSet.HR)];
        
        if(sum(runTime)>maxTime)
            break;
        end
    end
    
    


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
     xlabel('tau');
     ylabel('Time taken');
     
     fname = 'optTau.mat';
     save(fname, 'SSIMLcR', 'pSNRLcR', 'xtau', 'prepTime', 'runTime');
end

