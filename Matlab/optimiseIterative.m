function optimiseIterative
% 
    load('parameters.mat');
    colourRGB = {[1 0 0],[0 1 1],[0 1 0],[1 0 1],[0 0 1],[1 1 0],[1 0.4 0.6],[0.4 0.4 0.4],[0.93 0.69 0.13],[0 0 0]};
    marker = {'+','x','o','^','h','p','d','v','s','*'};
    
    maxIterations = 100;
    maxTime = 300;
    
    kNN = [0,1,2];
    pw_o = [4,2;4,1;3,1;5,1;6,2;6,1;8,0];
    index = 1;  % choose a pair of patchwidth+overlap
    
    for index = 1:7
    
    SSIMLcR = [];  pSNRLcR = [];  runTime = [];  numIterations = [];  totalTime = []; 
    
    parameters.LRPatch = pw_o(index,1);
    parameters.HRPatch = parameters.LRPatch*parameters.ratio;
        
    %%% import database or load data from pre-saved files
%     data = readDataSet(922);   
%     [trainSet, testSet] = getTrainAndTestData(data);
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
        
    % start doing actual work    
    for i = 1:length(kNN)
        disp(strcat('kNN=', num2str(kNN(i))));
        iterationNumber = 1;
        iterations = 1;
        % determine result quality for each patchWidth
        while iterations <= maxIterations
            disp(strcat('max iterations=', num2str(iterations)));
            numIterations(iterationNumber,i) = iterations;

            %%% reconstruction via LcR iterative method
            start = tic;
            resultLcR = reconstructionIterative(testSet.LR_p,trainSet.LR_p, trainSet.HR_p,...
                       parameters, iterations, kNN(i));
            now = toc(start);
            runTime(iterationNumber,i) = now;

            %%% measure output quality
            SSIMLcR(iterationNumber,i) = averageSSIM(resultLcR, testSet.HR);
            pSNRLcR(iterationNumber,i) = averagePSNR(resultLcR, testSet.HR);

            if(sum(runTime(:,i))>maxTime)
                break;
            end
            iterations = iterations*2;
            iterationNumber = iterationNumber+1;
        end
    end
    
    totalTime = runTime + repmat(prepTime, size(runTime,1),size(runTime,2));   
    speed = 40./totalTime;
    
    fname = strcat('optIter_gs_kNN_pw',num2str(parameters.LRPatch),'_o',...
        num2str(parameters.LROverlap),'.mat');
    save(fname, 'SSIMLcR', 'pSNRLcR', 'numIterations', 'runTime', 'kNN', 'totalTime');

    end % end index=1:7
    
    %%%%% plots %%%%%
    figure;
    hold on;
    for k = 1:size(numIterations,2)
        label = strcat('patch width ',num2str(pw_o(index,1)),', overlap ',...
            num2str(pw_o(index,2)),' kNN ',num2str(kNN(k)));
        s = scatter(speed(:,k),SSIMLcR(:,k),marker{k},'DisplayName',label);
        set(s,'MarkerEdgeColor',colourRGB{pw_o(index,1)-1});
    end
    legend('-DynamicLegend');
    xlabel('Number of test images processed per second');
    ylabel('Quality of Output (SSIM)');
    title('Quality against speed of iterative LcR algorithm (Gauss-Seidel, tau = 0.04)');
    
    %%%%%%%%%%%%%%%%%
     figure;
     hold on;
     plot(numIterations, SSIMLcR, 'DisplayName', 'LcR iterative');
     %legend('-DynamicLegend');
     pwo = strcat('PW',num2str(pw_o(index,1)),'O', num2str(pw_o(index,2)),',');
     legend(strcat(pwo,'kNN=0'),strcat(pwo,'kNN=1'),strcat(pwo,'kNN=2'));
     xlabel('Number of Iterations');
     ylabel('Quality of output (SSIM)');
     title({'Iterative LcR (Conjugate Gradient)';'Relationship between number of iterations and quality of output (SSIM), kNN=0,1,2'});
     
     figure;
     hold on;
     plot(numIterations, totalTime, 'DisplayName', 'Run Time');
     %legend('-DynamicLegend');
     legend(strcat(pwo,'kNN=0'),strcat(pwo,'kNN=1'),strcat(pwo,'kNN=2'));
     title('How number of iterations affects runtime for Iterative LcR');
     xlabel('Number of Iterations');
     ylabel('Time taken');
end

