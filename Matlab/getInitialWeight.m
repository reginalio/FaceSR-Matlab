function wNew = getInitialWeight(patchNumber, U, k, w)

    wNew = w;
    
    % top row
    if(patchNumber < U+1)
        wNew(:,patchNumber) = w(:,patchNumber-1);
    % left column
    elseif (mod(patchNumber, U) == 1)
        wNew(:,patchNumber) = w(:,patchNumber-U);
    elseif (k == 1)
        % take average of left and top patches
        wNew(:,patchNumber) = (w(:,patchNumber-1)+w(:,patchNumber-U))/2;
    else
        % k > 1; take average of surrounding patches
        wNew(:,patchNumber) = (w(:,patchNumber-1)+w(:,patchNumber-U)+w(:,patchNumber-U-1)+w(:,patchNumber-U+1))/4;
    end

end