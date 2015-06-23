dir = '../C_stuff/result/serial/';
mm = {'10x', '30x', '90x', '180x', '300x'};
n = {'9o1_', '16o1_', '25o1_', '36o2_', '64o0_'};

sumSSIM = zeros(5,5);
for q = 1:length(n)
    for p = 1:length(mm)
        filepath = strcat(dir, mm{p}, n{q});
        for i = 1:40
            a = imread(strcat(filepath, int2str(i),'.pgm'));
            ref = imread(strcat('../C_stuff/dataset/testHR/Face',int2str(i),'.pgm'));
            sumSSIM(p,q) = sumSSIM(p,q) + ssim(a,ref);
        end
        
    end
end

% for q = 1:length(n) 
%     filepath = strcat(dir, mm{5}, n{q});
%     for i = 1:10
%         a = imread(strcat(filepath, int2str(i),'.pgm'));
%         ref = imread(strcat('../C_stuff/dataset/testHR/Face',int2str(i),'.pgm'));
%         sumSSIM(5,q) = sumSSIM(5,q) + ssim(a,ref);
%     end
%     
% end
sumSSIM = sumSSIM./40;
% sumSSIM(5,:) = sumSSIM(5,:).*4;

    