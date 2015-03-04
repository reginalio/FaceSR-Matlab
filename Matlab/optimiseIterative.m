function optimiseIterative
% 
% --- assume same preptime as optimiseTau
    load('parameters.mat');
    
    maxIterations = 1000;
    iterations = 1;
    maxTime = 1000;
    
    SSIMLcR = [];
    pSNRLcR = [];
    
    runTime = [];
    x = [];
    
    %%% import database or load data from pre-saved files
    data = readDataSet(922);   
    [trainSet, testSet] = getTrainAndTestData(data);

    % determine result quality for each patchWidth
    while iterations <= maxIterations
        disp(strcat('max iterations=', num2str(iterations)));
        x = [x; iterations];
        
        %%% reconstruction via LcR iterative method
        start = tic;
        resultLcR = reconstructionIterative(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters, iterations);
        now = toc(start);
        runTime = [runTime; now];

        %%% measure output quality
        SSIMLcR = [SSIMLcR; averageSSIM(resultLcR, testSet.HR)];
        pSNRLcR = [pSNRLcR; averagePSNR(resultLcR, testSet.HR)];
        
        if(sum(runTime)>maxTime)
            break;
        end
        iterations = iterations*2;
    end
    
    
    fname = 'optIter.mat';
    save(fname, 'SSIMLcR', 'pSNRLcR', 'x', 'runTime');

    %%%%% plots %%%%%
     figure;
     hold on;
     plot(x, SSIMLcR, 'DisplayName', 'LcR');
     legend('-DynamicLegend');
     xlabel('Max Iterations');
     ylabel('Quality of output (SSIM)');
     title('Relationship between Number of Max Iterations and Quality of output (SSIM)');
     
     figure;
     hold on;
     plot(x, runTime, 'DisplayName', 'Run Time');
     legend('-DynamicLegend');
     title('How number of max iterations affects runtime for Iterative LcR');
     xlabel('Max Iterations');
     ylabel('Time taken');
end

