function targetHR = bicubicInterpolation(testLR2d)
% Bicubic interpolation of (non-patched) a set of LR images

    width = size(interp2(single(testLR2d(:,:,1)), 2, 'cubic'), 1);
    targetHR = zeros(width, width, size(testLR2d,3));
    
    for i = 1:size(testLR2d,3)
        targetHR(:,:,i) = interp2(single(testLR2d(:,:,i)), 2, 'cubic');
    end      

end