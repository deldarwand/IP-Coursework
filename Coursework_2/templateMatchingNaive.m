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

[paddedImage, paddingSize] = padImage(image, searchWindowSize, patchSize);
paddingSize = paddingSize -1;
lowerYValue = lowerYValue + paddingSize;
lowerXValue = lowerXValue + paddingSize;
upperYValue = upperYValue + paddingSize;
upperXValue = upperXValue + paddingSize;
image = paddedImage;
offsetsRows = zeros(searchWindowSize*searchWindowSize,1);
offsetsCols = zeros(searchWindowSize*searchWindowSize,1);
distances = zeros(searchWindowSize*searchWindowSize,1);
%centrePatchSum = getSumOfPatch(image, row, col, patchSize);
[imageWidth, imageHeight, colours] = size(image);
counter = 1;
for x = lowerXValue : upperXValue
    for y = lowerYValue : upperYValue
        xOffset = x - col - paddingSize;
        yOffset = y - row - paddingSize;
        patchDistance = getSumOfPatch(image, x, y, patchSize, col + paddingSize, row + paddingSize);
        offsetsCols(counter) = xOffset;
        offsetsRows(counter) = yOffset;
        distances(counter) = patchDistance;
        counter = counter+1;
    end
end
end

function sumOfPatch = getSumOfPatch(image, xPosition, yPosition, patchSize, originalX, originalY)

isPatchSizeEven = mod(patchSize, 2);
[imageWidth, imageHeight, colours] = size(image);
lowerYValue = -1; lowerXValue = -1; upperYValue = -1; upperXValue = -1;
lowerOffset = 0; upperOffset = 0;
if(isPatchSizeEven == 0) %The patch size is even.
    lowerOffset = (patchSize - 2) / 2;
    upperOffset = patchSize / 2;
    
    lowerYValue = yPosition - lowerOffset;
    lowerXValue = xPosition - lowerOffset;
    upperYValue = yPosition + upperOffset;
    upperXValue = xPosition + upperOffset;
    
else %The search size is odd.
    offset = (patchSize - 1) / 2;
    lowerOffset = offset;
    upperOffset = offset;
    lowerYValue = yPosition - offset;
    lowerXValue = xPosition - offset;
    upperYValue = yPosition + offset;
    upperXValue = xPosition + offset;
    
end

newPatch = double(image(lowerXValue:upperXValue, lowerYValue:upperYValue));
oldPatch = double(image(originalX-lowerOffset:originalX+upperOffset, originalY-lowerOffset:originalY+upperOffset));

patchDifference = (newPatch - oldPatch).^2.0;
sumOfPatch = sum(patchDifference(:));
% for x = lowerXValue : upperXValue
%     for y = lowerYValue : upperYValue % x and y are pixels in the new patch.
%         newPatchSample = double(image(x,y));
%         
%         xOffset = x - originalX;
%         yOffset = y - originalY;
%         oldPatchSample = double(image(originalX + xOffset, originalY + yOffset));
%         
%         
%         sumOfPatch = sumOfPatch + (newPatchSample - oldPatchSample)^2.0;
%         
%     end
% end


end

function [paddedImage, paddingSize] = padImage(image, windowSize, patchSize)

paddingSize = (windowSize+patchSize)*2;
[imageWidth, imageHeight, colours] = size(image);
paddedImage = zeros(imageWidth+paddingSize, imageHeight+paddingSize, colours, 'uint8');

for x = 1 : imageWidth+paddingSize
    for y = 1 : imageHeight+paddingSize
        positionXInOriginal = abs(x - (paddingSize/2))+1;
        positionYInOriginal = abs(y - (paddingSize/2))+1;
        
        if(positionXInOriginal > imageWidth)
            positionXInOriginal = imageWidth - (positionXInOriginal - imageWidth)
        end
        if(positionYInOriginal > imageHeight)
            positionYInOriginal = imageHeight - (positionYInOriginal - imageHeight)
        end
        currentImageSample = image(positionXInOriginal, positionYInOriginal, :);
        paddedImage(x,y, :) = currentImageSample;
    end
end
paddingSize = paddingSize/2;
end

% If the patch centre is outside the image, ignore it.
% function shouldCheckPatch = isPatchValid(xPosition, yPosition, imageWidth, imageHeight, patchSize)
%     shouldCheckPatch = true;
%     lowerYValue = -1; lowerXValue = -1; upperYValue = -1; upperXValue = -1;
%     isPatchSizeEven = mod(patchSize, 2);
% if(isPatchSizeEven == 0) %The patch size is even.
%     lowerOffset = (patchSize - 2) / 2;
%     upperOffset = patchSize / 2;
%     
%     lowerYValue = yPosition - lowerOffset;
%     lowerXValue = xPosition - lowerOffset;
%     upperYValue = yPosition + upperOffset;
%     upperXValue = xPosition + upperOffset;
%     
% else %The search size is odd.
%     offset = (patchSize - 1) / 2;
%     
%     lowerYValue = yPosition - offset;
%     lowerXValue = xPosition - offset;
%     upperYValue = yPosition + offset;
%     upperXValue = xPosition + offset;
%     
% end
% 
%     if(lowerYValue < 1 || lowerXValue < 1)
%         shouldCheckPatch = false;
%     elseif(upperXValue > imageWidth || upperXValue > imageHeight)
%         shouldCheckPatch = false;
%     end
% end