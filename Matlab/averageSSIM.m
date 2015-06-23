function [avgSSIM, err] = averageSSIM(testHR, ref)
% Measure structural similarity between all images in testHR and ref
% avgSSIM in [-1, 1]

%     sumSSIM = 0;
%     
%     for i = 1:size(testHR,3)
%         sumSSIM = sumSSIM + ssim(testHR(:,:,i), ref(:,:,i));
%     end
%     
%     avgSSIM = sumSSIM/size(testHR,3);

    SSIM = nan(1,size(testHR,3));
    
    for i = 1:size(testHR,3)
        SSIM(i) = ssim(testHR(:,:,i), ref(:,:,i));
    end
    
    avgSSIM = sum(SSIM)/size(testHR,3);
    err = std(SSIM);

end