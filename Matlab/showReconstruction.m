function showReconstruction(lr, hr, real, limits, step)

    for i = limits(1):step:limits(2)
        figure(i);
        subplot(1,3,1);
        imshow(uint8(lr(:,:,i)));
        title('Low resolution input');
        subplot(1,3,2);
        imshow(uint8(hr(:,:,i)));
        title('Reconstructed face');
        subplot(1,3,3);
        imshow(uint8(real(:,:,i)));
        title('Ground truth');
    end


end