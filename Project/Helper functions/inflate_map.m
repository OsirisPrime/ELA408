function inflated = inflate_map(originalMap, clearance)
    if clearance <= 0
        inflated = originalMap;
        return;
    end

    % Convolution to inflate the obstacles
    kernelSize = 2 * clearance + 1;
    kernel = ones(kernelSize, kernelSize);
    inflated = conv2(originalMap, kernel, 'same') > 0;
end