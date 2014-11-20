function [avgPSNR, avgSNR] = averagePSNR(testHR, ref)
% Measure Peak Signal-to-Noise Ratio of between all images in testHR and ref


    sumPSNR = 0;
    sumSNR = 0;
    
    for i = 1:size(testHR,3)
        [peaksnr, snr] = psnr(uint8(testHR(:,:,i)), ref(:,:,i));
        sumPSNR = sumPSNR + peaksnr;
        sumSNR = sumSNR + snr;      
    end
    
    avgPSNR = sumPSNR/size(testHR,3);
    avgSNR = sumSNR/size(testHR,3);

end