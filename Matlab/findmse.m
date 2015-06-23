function mse = findmse(ref, noisyImage)
    [rows columns] = size(ref);
    squaredErrorImage = (double(ref) - double(noisyImage)) .^ 2;
    mse = sum(sum(squaredErrorImage)) / (rows * columns);


end