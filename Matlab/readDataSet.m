function data = readDataSet(N)
% INPUT: N - end index of the data set
    [x, y] = size(imread('Face000.pgm'));
    data = zeros(x,y, 2*(N+1),'uint8');
    
    for i = 0:N
        data(:,:,2*i+1) = imread(strcat('Face', num2str(i,'%3.3d'), '.pgm'));
        data(:,:,2*i+2) = imread(strcat('Face', num2str(i,'%3.3d'), 'M.pgm'));
    end        

    %randomise rows

end