%plot QT new
resultFiles = {'optPW2wTAUwO.mat','optPW3wTAUwO.mat','optPW4wTAUwO.mat','optPW5wTAUwO.mat',...
    'optPW6wTAUwO.mat','optPW7wTAUwO.mat','optPW8wTAUwO.mat','optPW9wTAUwO.mat','optPW10wTAUwO.mat'};
%colour = {'red', 'cyan', 'green', 'magenta', 'blue', 'yellow', 'black','black','black','black'};
colour = {[1 0 0],[0 1 1],[0 1 0],[1 0 1],[0 0 1],[1 1 0],[1 0.4 0.6],[0.4 0.4 0.4],[0.93 0.69 0.13],[0 0 0]};
marker = {'+','x','o','^','h','p','d','v','s','*'};

figure;
hold on;

for i = 1: length(resultFiles)
    load(resultFiles{i});
    speed = 40./totalLcRTime;
    for j = 1:size(SSIMLcR,2)
        label = strcat('patch width ',num2str(i+1),', overlap ',num2str(j-1));
       % scatter(speed(:,j), SSIMLcR(:,j), colour{i}, marker{j},...
       %     'DisplayName', label);
       s = scatter(speed(:,j), SSIMLcR(:,j), marker{j},...
           'DisplayName', label);
       set(s,'MarkerEdgeColor',colour{i});
       %         errorbar(speed(:,j), SSIMLcR(:,j),SSIMerr(:,j),colour{i});
    end
    legend('-DynamicLegend');
%     xlabel('Total time taken for 40 test images (seconds)');
    xlabel('Number of test images processed per second');
    ylabel('Quality of Output (SSIM)');
    title('Quality against speed of LcR algorithm with varying patch size, overlap and tau');
    
end