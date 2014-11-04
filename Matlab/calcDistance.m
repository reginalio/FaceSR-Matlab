function dist = calcDistance(x, y)
% x has dimension 2x2x7x7, y has dimension 2x2x7x7x360
% we want euclidean distance between the x patch with every y patch
% output dist dimension 7x7x360

    dist = zeros(size(x,3), size(x,4), size(y,5));

    for j=1:size(y,5)
        dist(:,:,j) = sqrt(sum(sum((double(x(:,:,:,:))-double(y(:,:,:,:,j))).^2)));
    end

end