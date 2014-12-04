function [data] = readDataSet(N)
% Read full image data set
% INPUT: N - end index of the data set

% 1-1674 as training set
% 1675 - 1846 as testing set

        if(exist('fullSizeData.mat','file') == 0)
            disp('reading full size face database...');
            [x, y] = size(imread('../Full Size Database/Face000.pgm'));
            data = zeros(x,y, 2*(N+1),'uint8');

            for i = 0:N
                data(:,:,2*i+1) = imread(strcat('../Full Size Database/Face', num2str(i,'%3.3d'), '.pgm'));
                data(:,:,2*i+2) = imread(strcat('../Full Size Database/Face', num2str(i,'%3.3d'), 'M.pgm'));
            end        
            
            save('fullSizeData.mat', 'data');
        else
            load('fullSizeData.mat');
        end

end