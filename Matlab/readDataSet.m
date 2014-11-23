function [dataRandom, data] = readDataSet(N)
% Read full image data set
% INPUT: N - end index of the data set
    [x, y] = size(imread('../Full Size Database/Face000.pgm'));
    data = zeros(x,y, 2*(N+1),'uint8');
    
    for i = 0:N
        data(:,:,2*i+1) = imread(strcat('../Full Size Database/Face', num2str(i,'%3.3d'), '.pgm'));
        data(:,:,2*i+2) = imread(strcat('../Full Size Database/Face', num2str(i,'%3.3d'), 'M.pgm'));
    end        

    %randomise rows
    dataRandom = data(:, :, randperm(size(data,3)));
    
    save('groundTruth.mat');

end