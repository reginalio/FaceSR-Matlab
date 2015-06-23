function optimiseTau
% find result quality for each tau to determine optimial tau
% tau controls the weights of locality constraint

    load('parameters.mat');
    
    maxTau = 1e1;
    tau = 1e-8;
    maxTime = 1000;
    
    SSIMLcR = [];
    SSIMerr = [];
    pSNRLcR = [];
    pSNRerr = [];
    
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
        [avgSSIM, err] = averageSSIM(resultLcR, testSet.HR);
        SSIMLcR = [SSIMLcR; avgSSIM];
        SSIMerr = [SSIMerr, err];
        
        [avgPSNR, err] = averagePSNR(resultLcR, testSet.HR);
        pSNRLcR = [pSNRLcR; avgPSNR];
        pSNRerr = [pSNRerr; err];
        
        if(sum(runTime)>maxTime)
            break;
        end
    end
    
    


    %%%%% plots %%%%%
     figure;
     hold on;
     plot(xtau, SSIMLcR, 'DisplayName', 'LcR');
     errorbar(xtau,SSIMLcR,SSIMerr,'.');
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
     
     fname = 'optTau_new.mat';
     save(fname, 'SSIMLcR', 'SSIMerr', 'pSNRLcR', 'pSNRerr', 'xtau', 'prepTime', 'runTime');
end

