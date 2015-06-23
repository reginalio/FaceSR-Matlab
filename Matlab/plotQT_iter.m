% plot QT for iterative methods

% resultFiles = {'optIter_gs_kNN_pw3_o1.mat','optIter_gs_kNN_pw4_o1.mat','optIter_gs_kNN_pw4_o2.mat',...
%     'optIter_gs_kNN_pw5_o1.mat','optIter_gs_kNN_pw6_o1.mat','optIter_gs_kNN_pw6_o2.mat','optIter_gs_kNN_pw8_o0.mat',...
    resultFiles = { 'optIter_cg_kNN_pw3_o1.mat','optIter_cg_kNN_pw4_o1.mat','optIter_cg_kNN_pw4_o2.mat',...
    'optIter_cg_kNN_pw5_o1.mat','optIter_cg_kNN_pw6_o1.mat','optIter_cg_kNN_pw6_o2.mat','optIter_cg_kNN_pw8_o0.mat'};
colour = {[1 0 0],[0 1 1],[0 1 0],[1 0 1],[0 0 1],[1 1 0],[1 0.4 0.6],[0.4 0.4 0.4],[0.93 0.69 0.13],[0 0 0]};
marker = {'+','x','o','^','h','p','d','v','s','*'};
kNN = [0,1,2];
pw_o = [3,1;4,1;4,2;5,1;6,1;6,2;8,0];
    
figure;
hold on;

for i = 1:length(resultFiles)
    load(resultFiles{i});
    speed = 40./totalTime;
%     if (i < 8)  method = 'GS'; cc=1; mm=i;
% else
    method = 'CG'; cc=2; mm=i; %end
    
    for k = 1:size(numIterations,2)
        label = strcat(method,'-PW',num2str(pw_o(mm,1)),'O',...
            num2str(pw_o(mm,2)),',kNN ',num2str(kNN(k)));
        s = scatter(speed(:,k),SSIMLcR(:,k),marker{k},'DisplayName',label);
        set(s,'MarkerEdgeColor',colour{pw_o(mm,1)-1});
    end
end
    legend('-DynamicLegend');
    xlabel('Number of test images processed per second');
    ylabel('Quality of Output (SSIM)');
    title('Quality against speed of iterative LcR algorithm (tau = 0.04)');