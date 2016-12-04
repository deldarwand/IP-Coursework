function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(row,...
    col,patchSize, searchWindowSize, integralImage)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsX(1) = -1;
% offsetsY(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

% This time, use the integral image method!
% NOTE: Use the 'computeIntegralImage' function developed earlier to
% calculate your integral images
% NOTE: Use the 'evaluateIntegralImage' function to calculate patch sums

%REPLACE THIS
isSearchWindowSizeEven = mod(searchWindowSize, 2);

lowerYValue = -1; lowerXValue = -1; upperYValue = -1; upperXValue = -1;

lowerOffset = 0, upperOffset = 0;

if(isSearchWindowSizeEven == 0) %The search size is even.
    lowerOffset = (searchWindowSize - 2) / 2;
    upperOffset = searchWindowSize / 2;
    
    lowerYValue = row - lowerOffset;
    lowerXValue = col - lowerOffset;
    upperYValue = row + upperOffset;
    upperXValue = col + upperOffset;
    
else %The search size is odd.
    lowerOffset = (searchWindowSize - 1) / 2;
    upperOffset = (searchWindowSize - 1) / 2;
    lowerYValue = row - lowerOffset;
    lowerXValue = col - lowerOffset;
    upperYValue = row + upperOffset;
    upperXValue = col + upperOffset;
    
end



offsetsRows = zeros(searchWindowSize*searchWindowSize,1);
offsetsCols = zeros(searchWindowSize*searchWindowSize,1);
distances = zeros(searchWindowSize*searchWindowSize, 1);

centrePatchSum = getSumOfPatch(integralImage, lowerXValue, lowerYValue, upperXValue, upperYValue);
counter = 1;
for x = lowerXValue : upperXValue
    for y = lowerYValue : upperYValue
        
        loweryValue = y - lowerOffset;
        lowerxValue = x - lowerOffset;
        upperyValue = y + upperOffset;
        upperxValue = x + upperOffset;
        
        xOffset = x - col;
        yOffset = y - row;
        offsetsCols(counter) = xOffset;
        offsetsRows(counter) = yOffset;
        patchDistance = getSumOfPatch(integralImage, lowerxValue, loweryValue, upperxValue, upperyValue) - centrePatchSum;
        distances(counter) = patchDistance * patchDistance;
        counter = counter+1;
    end
end
end

function finalSample = getSumOfPatch(integralImage, xLower, yLower, xUpper, yUpper)

fullSample = double(0), sampleToDeleteA = double(0), sampleToDeleteB = double(0), sampleToAddBack = double(0);

fullSample = integralImage(xUpper, yUpper)
sampleToDeleteA = integralImage(xUpper, yLower-1)
sampleToDeleteB = integralImage(xLower-1, yUpper)
sampleToAddBack = integralImage(xLower-1, yLower-1)

finalSample = double(fullSample) - double(sampleToDeleteA) - double(sampleToDeleteB) + double(sampleToAddBack);


end
