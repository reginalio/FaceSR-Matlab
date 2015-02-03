resultFiles = {'optPatchResultO1.mat', 'optOverlapResultP3.mat', ...
    'optOverlapResultP4.mat', 'optSortN.mat', 'optTau.mat'};
colour = {'red', 'cyan', 'green', 'magenta', 'blue'};
figure;
hold on;

for i = 1: length(resultFiles)
    load(resultFiles{i})
    % check if these variables exist
    patchParam = exist('patchWidth', 'var');
    overlapParam = exist('overlap', 'var');
    tauParam = exist('xtau', 'var');
    sortNParam = exist('x', 'var');
    
    if patchParam
        parameter = patchWidth;
        clearvars patchWidth;
    elseif overlapParam
        parameter = overlap;
        clearvars overlap;
    elseif tauParam
        parameter = xtau;
        clearvars xtau;
    elseif sortNParam
        parameter = x;
        clearvars x;
    else
       disp('wrong name')
       disp(i)
    end
    
    if exist('prepTime', 'var')
        timeTaken = prepTime + runTime;
        clearvars prepTime;
    else
        timeTaken = runTime;
    end
    
    c = colour{i};
    scatter(timeTaken, SSIMLcR, c, 'x',...
        'DisplayName', resultFiles{i});
    legend('-DynamicLegend');
    xlabel('Time taken / s');
    ylabel('Quality of Output / SSIM');
    
end
