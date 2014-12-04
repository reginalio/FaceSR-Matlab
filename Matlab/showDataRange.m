function showDataRange(data, startIndex, endIndex)
% 
    figure;
    length = endIndex - startIndex +1;
    for i = startIndex:endIndex
        subplot(ceil(length/10), 10, i-(startIndex-1));
        imshow(data(:,:,i));
    end
end