% plots all patches in a as subplot

figure;

for i=1:7
    for j = 1:7
        subplot(7,7,j+(i-1)*7);
        imshow(uint8(a(:,:,j,i)));
    end
end