function showDataX(x)
% helper function that shows original, low res and high res version of
% image x
    figure;
    subplot(1,3,1);
    imshow(data(:,:,x));
    subplot(1,3,2);
    imshow(dataLR(:,:,x));
    subplot(1,3,3);
    imshow(dataHR(:,:,x));
end