function [patchedLR, patchedHR] = divideToPatches3(LR, HR, params)
%divideToPatches3 - divide LR, HR to patches -> patchedHR, patchedLR
% Zero pad 
  
%     
%     % number of pixels to shift across for each patch
%     shift  = params.LRPatch - [params.LROverlap params.LROverlap];
%     % number of patches in x, y direction
%     numPatches = ceil((params.LRSize-params.LRPatch)/shift) + [1, 1];
%     newLRSize = (numPatches-[1,1])*shift + params.LRPatch;
%     newLR = zeros(newLRSize);
%     newLR(1:params.LRSize(1),1:params.LRSize(2)) = LR;
    
    
    % End patch index for each face image
    U = ceil((params.HRSize(1)-params.HROverlap)/(params.HRPatch-params.HROverlap));
    V = U;

    newHRSize = U*(params.HRPatch-params.HROverlap) + params.HROverlap;
    newLRSize = U*(params.LRPatch-params.LROverlap) + params.LROverlap;
    
    % number of images in HR and LR
    N = size(HR,3);
%     stepHR = floor(newHRSize/U);
%     stepLR = floor(newLRSize/U);
    stepHR = params.HRPatch - params.HROverlap;
    stepLR = params.LRPatch - params.LROverlap;

    % newHR and newLR are the zero-padded versions of HR and LR
    newHR = zeros(newHRSize, newHRSize, N);
    newHR(1:params.HRSize(1),1:params.HRSize(2), :) = HR;
    
    newLR = zeros(newLRSize, newLRSize, N);
    newLR(1:params.LRSize(1),1:params.LRSize(2), :) = LR; 
    


    patchedHR = zeros(params.HRPatch, params.HRPatch, U,V,N, 'double');
    patchedLR = zeros(params.LRPatch, params.LRPatch, U,V,N, 'double');

   
    for k = 1:N
        for i = 1:U
            rectHR = [(1+(i-1)*stepHR) 0 params.HRPatch-1 params.HRPatch-1];
            rectLR = [(1+(i-1)*stepLR) 0 params.LRPatch-1 params.LRPatch-1];
            for j = 1:V
                rectHR(2) = (1+(j-1)*stepHR);
                rectLR(2) = (1+(j-1)*stepLR);
                
                patchedHR(:,:,i,j,k) = imcrop(newHR(:,:,k), rectHR);
                patchedLR(:,:,i,j,k) = imcrop(newLR(:,:,k), rectLR);
            end
        end
    end

end