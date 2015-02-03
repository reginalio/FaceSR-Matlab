function optimiseSortN
% find out how number of training images used in reconstruction affects
% quality of output
% --- assume same preptime as optimiseTau
    load('parameters.mat');
    
    maxN = 360;
    N = 2;
    maxTime = 1000;
    
    SSIMLcR = [];
    pSNRLcR = [];
    
    runTime = [];
    x = [];
    
    %%% import database or load data from pre-saved files
    data = readDataSet(922);   
    [trainSet, testSet] = getTrainAndTestData(data);

    % determine result quality for each patchWidth
    while N <= maxN
        disp(strcat('N=', num2str(N)));
        x = [x; N];
        
        %%% reconstruction via LcR
        start = tic;
        resultLcR = reconstructionWithSort(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                   parameters.tau, parameters.HROverlap, parameters.HRSize(1), N);
        now = toc(start);
        runTime = [runTime; now];

        %%% measure output quality
        SSIMLcR = [SSIMLcR; averageSSIM(resultLcR, testSet.HR)];
        pSNRLcR = [pSNRLcR; averagePSNR(resultLcR, testSet.HR)];
        
        if(sum(runTime)>maxTime)
            break;
        end
        N = floor(N*3/2);
    end
    
    
    fname = 'optSortN.mat';
    save(fname, 'SSIMLcR', 'pSNRLcR', 'x', 'runTime');

    %%%%% plots %%%%%
     figure;
     hold on;
     plot(x, SSIMLcR, 'DisplayName', 'LcR');
     legend('-DynamicLegend');
     xlabel('N');
     ylabel('Quality of output (SSIM)');
     title('Relationship between Number of Training Images used in Reconstruction and Quality of output (SSIM)');
     
     figure;
     hold on;
     plot(x, runTime, 'DisplayName', 'Run Time');
     legend('-DynamicLegend');
     title('How number of training images used in reconstruction affects runtime for LcR');
     xlabel('Number of training faces used for reconstruction');
     ylabel('Time taken');
end

