aa = imread('../Full Size Database/Face890.pgm');
aa1 = imadjust(aa, [0.125 0.875], []);
aa2 = aa + 15.1;
aa3 = imread('womanFace.jpeg');
h = fspecial('gaussian', size(aa), 3.6) ;
aa4 = imfilter(aa, h);
aa5 = imnoise(aa, 'salt & pepper', 0.0105);

figure;
subplot(2,3,1)
imshow(aa);
mse = findmse(aa, aa);
s = ssim(aa, aa);
title(strcat('(a) - MSE:', num2str(mse), ', SSIM:', num2str(s)))

subplot(2,3,2)
imshow(aa1);
mse = findmse(aa, aa1);
s = ssim(aa, aa1);
title(strcat('(b) - MSE:', num2str(mse), ', SSIM:', num2str(s)))

subplot(2,3,3)
imshow(aa2);
mse = findmse(aa, aa2);
s = ssim(aa, aa2);
title(strcat('(c) - MSE:', num2str(mse), ', SSIM:', num2str(s)))

subplot(2,3,4)
imshow(aa3);
mse = findmse(aa, aa3);
s = ssim(aa, aa3);
title(strcat('(d) - MSE:', num2str(mse), ', SSIM:', num2str(s)))

subplot(2,3,5)
imshow(aa4);
mse = findmse(aa, aa4);
s = ssim(aa, aa4);
title(strcat('(e) - MSE:', num2str(mse), ', SSIM:', num2str(s)))

subplot(2,3,6)
imshow(aa5);
mse = findmse(aa, aa5);
s = ssim(aa, aa5);
title(strcat('(f) - MSE:', num2str(mse), ', SSIM:', num2str(s)))
