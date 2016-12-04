function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(row, col,...
    patchSize, searchWindowSize, image)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

%REPLACE THIS
isSearchWindowSizeEven = mod(searchWindowSize, 2);

lowerYValue = -1; lowerXValue = -1; upperYValue = -1; upperXValue = -1;

if(isSearchWindowSizeEven == 0) %The search size is even.
    lowerOffset = (searchWindowSize - 2) / 2;
    upperOffset = searchWindowSize / 2;
    
    lowerYValue = row - lowerOffset;
    lowerXValue = col - lowerOffset;
    upperYValue = row + upperOffset;
    upperXValue = col + upperOffset;
    
else %The search size is odd.
    offset = (searchWindowSize - 1) / 2;
    
    lowerYValue = row - offset;
    lowerXValue = col - offset;
    upperYValue = row + offset;
    upperXValue = col + offset;
    
end

offsetsRows = zeros(searchWindowSize*searchWindowSize,1);
offsetsCols = zeros(searchWindowSize*searchWindowSize,1);
distances = zeros(searchWindowSize*searchWindowSize,1);

centrePatchSum = getSumOfPatch(image, row, col, patchSize);
counter = 1;
for x = lowerXValue : upperXValue
    for y = lowerYValue : upperYValue
        patchDistance = getSumOfPatch(image, x, y, patchSize) - centrePatchSum;
        xOffset = x - col;
        yOffset = y - row;
        offsetsCols(counter) = xOffset;
        offsetsRows(counter) = yOffset;
        distances(counter) = patchDistance * patchDistance;
        counter = counter+1;
    end
end
end

function sumOfPatch = getSumOfPatch(image, xPosition, yPosition, patchSize)

isPatchSizeEven = mod(patchSize, 2);

lowerYValue = -1; lowerXValue = -1; upperYValue = -1; upperXValue = -1;

if(isPatchSizeEven == 0) %The patch size is even.
    lowerOffset = (patchSize - 2) / 2;
    upperOffset = patchSize / 2;
    
    lowerYValue = yPosition - lowerOffset;
    lowerXValue = xPosition - lowerOffset;
    upperYValue = yPosition + upperOffset;
    upperXValue = xPosition + upperOffset;
    
else %The search size is odd.
    offset = (patchSize - 1) / 2;
    
    lowerYValue = yPosition - offset;
    lowerXValue = xPosition - offset;
    upperYValue = yPosition + offset;
    upperXValue = xPosition + offset;
    
end

sumOfPatch = double(0);

for x = lowerXValue : upperXValue
    for y = lowerYValue : upperYValue
        sumOfPatch = double(sumOfPatch) + double(image(x, y));
    end
end


end