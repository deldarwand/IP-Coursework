function [result] = computeWeighting(d, h, sigma, patchSize)
    
    maxParameter = max(d - 2*sigma*sigma, 0);
    exponentParameter = -maxParameter / (h*h);
    
    result = exp(exponentParameter);
end