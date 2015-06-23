function optimiseSortN
% find out how number of training images used in reconstruction affects
% quality of output
% --- assume same preptime as optimiseTau
    load('parameters.mat');
    
    maxN = 360;
    maxTime = 1000;
    
%     pw_o = [4,2;4,1];
    pw_o = [4,2;4,1;3,1;5,1;6,2;6,1;8,0];
    tau = [0.02,0.04,0.08,0.1,0.5];
%     colour = {'red', 'cyan', 'green', 'magenta', 'blue', 'yellow', 'black','black','black','black'};
    colourRGB = {[1 0 0],[0 1 1],[0 1 0],[1 0 1],[0 0 1],[1 1 0],[1 0.4 0.6],[0.4 0.4 0.4],[0.93 0.69 0.13],[0 0 0]};
    marker = {'+','x','o','^','h','p','d','v','s','*'};

    figure;
    hold on;
    
    for index = 1:size(pw_o,1)
    for tIndex = 1:length(tau)
    
        parameters.LRPatch = pw_o(index,1);
        parameters.HRPatch = parameters.LRPatch*parameters.ratio;
        
        SSIMLcR = [];
        SSIMerr = [];
        pSNRLcR = [];
        pSNRerr = [];

        runTime = [];
        x = [];
        N = 10;

        %%% import database or load data from pre-saved files
%         data = readDataSet(922);   
%         [trainSet, testSet] = getTrainAndTestData(data);
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

        parameters.LROverlap = pw_o(index,2);
        parameters.HROverlap = pw_o(index,2)*parameters.ratio;

        disp('getting patched train and test data...');
        %%% obtain patched version
        [trainSet.LR_p, trainSet.HR_p] = divideToPatches3(trainSet.LR, trainSet.HR, parameters);

        start = tic;
        [testSet.LR_p, testSet.HR_p] = divideToPatches3(testSet.LR, testSet.HR, parameters);
        now = toc(start);
        prepTime = now;
                
        % determine result quality for each patchWidth
        while N <= maxN
            disp(strcat('N=', num2str(N)));
            x = [x; N];

            %%% reconstruction via LcR
            start = tic;
            resultLcR = reconstructionWithSort(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                       tau(tIndex), parameters.HROverlap, parameters.HRSize(1), N);
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
            N = floor(N*3/2);
    %         N = N*2;
        end
        
    totalTime = runTime + repmat(prepTime, length(runTime),1);   
    speed = 40./totalTime;
    
    %%% plot stuff    
    label = strcat('patch width ',num2str(pw_o(index,1)),', overlap ',...
        num2str(pw_o(index,2)),' tau ',num2str(tau(tIndex)));
%     scatter(speed,SSIMLcR,colour{index},marker{tIndex},'DisplayName',label);
    s = scatter(speed,SSIMLcR,marker{tIndex},'DisplayName',label);
    set(s,'MarkerEdgeColor',colourRGB{pw_o(index,1)-1});
    end
    end
    
     legend('-DynamicLegend');
    xlabel('Number of test images processed per second');
%     xlabel('Number of test images processed per second');
    ylabel('Quality of Output (SSIM)');
    title('Quality against speed of LcR algorithm with sort');
    
%     fname = 'optSortN_new.mat';
%     save(fname, 'SSIMLcR', 'SSIMerr', 'pSNRLcR', 'pSNRerr', 'x', 'runTime');
% 
%     %%%%% plots %%%%%
%      figure;
%      hold on;
%      plot(x, SSIMLcR, 'DisplayName', 'LcR');
%      errorbar(x,SSIMLcR,SSIMerr,'.');
%      legend('-DynamicLegend');
%      xlabel('N');
%      ylabel('Quality of output (SSIM)');
%      title('Relationship between Number of Training Images used in Reconstruction and Quality of output (SSIM)');
%      
%      figure;
%      hold on;
%      plot(x, runTime, 'DisplayName', 'Run Time');
%      legend('-DynamicLegend');
%      title('How number of training images used in reconstruction affects runtime for LcR');
%      xlabel('Number of training faces used for reconstruction');
%      ylabel('Time taken');
end

