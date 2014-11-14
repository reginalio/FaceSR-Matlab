% divide dataHR/LR to patches -> yHR/LR

% End patch index for each face image
U = ceil((HR_SIZE(1)-HR_OVERLAP)/(HR_PATCH_SIZE-HR_OVERLAP));
V = ceil((HR_SIZE(2)-HR_OVERLAP)/(HR_PATCH_SIZE-HR_OVERLAP));

N = size(dataHR,3);
stepHR = floor(HR_SIZE(1)/U);
stepLR = floor(LR_SIZE(1)/U);

yHR = zeros(HR_PATCH_SIZE, HR_PATCH_SIZE, U,V,N, 'uint8');
yLR = zeros(LR_PATCH_SIZE, LR_PATCH_SIZE, U,V,N, 'uint8');

for k = 1:N
    for i = 1:U
        for j = 1:V
            yHR(:,:,i,j,k) = imcrop(dataHR(:,:,k), [(1+(i-1)*stepHR) (1+(j-1)*stepHR) HR_PATCH_SIZE-1 HR_PATCH_SIZE-1]);
            yLR(:,:,i,j,k) = imcrop(dataLR(:,:,k), [1+(i-1)*stepLR 1+(j-1)*stepLR LR_PATCH_SIZE-1 LR_PATCH_SIZE-1]);
        end
    end
end