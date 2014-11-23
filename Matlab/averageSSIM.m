function avgSSIM = averageSSIM(testHR, ref)
% Measure structural similarity between all images in testHR and ref
% avgSSIM in [-1, 1]

    sumSSIM = 0;
    
    for i = 1:size(testHR,3)
        sumSSIM = sumSSIM + ssim(uint8(testHR(:,:,i)), ref(:,:,i));
    end
    
    avgSSIM = sumSSIM/size(testHR,3);

end