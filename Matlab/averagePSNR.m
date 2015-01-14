function [avgPSNR, avgSNR] = averagePSNR(testHR, ref)
% Measure Peak Signal-to-Noise Ratio of all images in testHR with ref


    sumPSNR = 0;
    sumSNR = 0;
    
    for i = 1:size(testHR,3)
        [peaksnr, snr] = psnr(testHR(:,:,i), ref(:,:,i));
        sumPSNR = sumPSNR + peaksnr;
        sumSNR = sumSNR + snr;      
    end
    
    avgPSNR = sumPSNR/size(testHR,3);
    avgSNR = sumSNR/size(testHR,3);

end