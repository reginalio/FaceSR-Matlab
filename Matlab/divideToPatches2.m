function [patchedLR, patchedHR] = divideToPatches2(LR, HR, params)
% divide dataHR/LR to patches -> yHR/LR
    
    % End patch index for each face image
    U = ceil((params.HRSize(1)-params.HROverlap)/(params.HRPatch-params.HROverlap));
    V = U;

    N = size(HR,3);
    stepHR = floor(params.HRSize(1)/U);
    stepLR = floor(params.LRSize(1)/U);

    patchedHR = zeros(params.HRPatch, params.HRPatch, U,V,N, 'double');
    patchedLR = zeros(params.LRPatch, params.LRPatch, U,V,N, 'double');

   
    for k = 1:N
        for i = 1:U
            for j = 1:V
                rectHR = [(1+(i-1)*stepHR) (1+(j-1)*stepHR) params.HRPatch-1 params.HRPatch-1];
                rectLR = [(1+(i-1)*stepLR) (1+(j-1)*stepLR) params.LRPatch-1 params.LRPatch-1];

                % check for last column and last row of patches
                if (rectHR(1)+rectHR(3)) > params.HRSize
                    rectHR(1) = params.HRSize(1) - params.HRPatch + 1;
                end
                if (rectHR(2)+rectHR(4)) > params.HRSize
                    rectHR(2) = params.HRSize(2) - params.HRPatch + 1;
                end
                
                if (rectLR(1)+rectLR(3)) > params.LRSize
                    rectLR(1) = params.LRSize(1) - params.LRPatch + 1;
                end
                if (rectLR(2)+rectLR(4)) > params.LRSize
                    rectLR(2) = params.LRSize(2) - params.LRPatch + 1;
                end
                
                patchedHR(:,:,i,j,k) = imcrop(HR(:,:,k), rectHR);
                patchedLR(:,:,i,j,k) = imcrop(LR(:,:,k), rectLR);
            end
        end
    end

end