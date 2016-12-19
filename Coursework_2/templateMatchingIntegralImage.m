function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(row,...
    col,patchSize, searchWindowSize, image)
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
    
    lowerOffset = (patchSize - 2) / 2;
    upperOffset = patchSize / 2;
    
else %The search size is odd.
    lowerOffset = (searchWindowSize - 1) / 2;
    upperOffset = (searchWindowSize - 1) / 2;
    lowerYValue = row - lowerOffset;
    lowerXValue = col - lowerOffset;
    upperYValue = row + upperOffset;
    upperXValue = col + upperOffset;
    
    lowerOffset = (patchSize - 1) / 2;
    upperOffset = (patchSize - 1) / 2;
    
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
distances = zeros(searchWindowSize*searchWindowSize, 1);
%centrePatchSum = getSumOfPatch(integralImage, lowerXValue, lowerYValue, upperXValue, upperYValue);
counter = 1;
for x = lowerXValue : upperXValue
    for y = lowerYValue : upperYValue
        
        loweryValue = y - lowerOffset;
        lowerxValue = x - lowerOffset;
        upperyValue = y + upperOffset;
        upperxValue = x + upperOffset;
        
        xOffset = x - col - paddingSize;
        yOffset = y - row - paddingSize;
        
        differenceImage = getDifferenceImage(image, xOffset, yOffset);
        integralImage = computeIntegralImage(differenceImage);
        
        offsetsCols(counter) = xOffset;
        offsetsRows(counter) = yOffset;
        patchDistance = getSumOfPatch(integralImage, col-lowerOffset+paddingSize, row-lowerOffset+paddingSize, col+upperOffset+paddingSize, row+upperOffset+paddingSize);
        distances(counter) = patchDistance;
        counter = counter+1;
    end
end
end

function finalSample = getSumOfPatch(integralImage, xLower, yLower, xUpper, yUpper)

[imageWidth, imageHeight, colours] = size(integralImage);

if(xUpper > imageWidth)
    xUpper = imageWidth;
end
if(xLower > imageWidth)
    xLower = imageWidth;
end
if(yUpper > imageHeight)
    yUpper = imageHeight;
end
if(yLower > imageHeight)
    yLower = imageHeight;
end
fullSample = integralImage(xUpper, yUpper);
sampleToDeleteA = integralImage(xUpper, yLower-1);
sampleToDeleteB = integralImage(xLower-1, yUpper);
sampleToAddBack = integralImage(xLower-1, yLower-1);

finalSample = double(fullSample) - double(sampleToDeleteA) - double(sampleToDeleteB) + double(sampleToAddBack);


end

function differenceImage = getDifferenceImage(image, offsetX, offsetY)

[imageWidth, imageHeight, colours] = size(image);
differenceImage = double(zeros(imageWidth, imageHeight, 1));


for x = 1 : imageWidth
    for y = 1 : imageHeight
        newImageSample = [0,0,0];
        if(x+offsetX > 0 && y+offsetY > 0)
            newImageSample = image(min(x+offsetX, imageWidth), min(y+offsetY, imageHeight), :);
        elseif(x+offsetX < 1 && y+offsetY < 1)
            newImageSample = image(1,1,:);
        elseif(y+offsetY < 1)
            newImageSample = image(min(x+offsetX, imageWidth), 1, :);
        elseif(x+offsetX < 1)
            newImageSample = image(1, min(y+offsetY, imageHeight), :);
        end
        oldImageSample = image(x,y, :);
        redOldImageSample = oldImageSample(1);
        redNewImageSample = newImageSample(1);
        
%         greenOldImageSample = oldImageSample(2);
%         greenNewImageSample = newImageSample(2);
%         
%         blueOldImageSample = oldImageSample(3);
%         blueNewImageSample = newImageSample(3);
        
        redDifference = double(double(redOldImageSample) - double(redNewImageSample));
%         greenDifference = double(double(greenOldImageSample) - double(greenNewImageSample));
%         blueDifference = double(double(blueOldImageSample) - double(blueNewImageSample));
        
%         differenceAverage = double((redDifference + greenDifference + blueDifference)/3.0);
        
        differenceImage(x,y,1) = redDifference*redDifference;%differenceAverage*differenceAverage;%double((double(redOldImageSample) - double(redNewImageSample))*(double(redOldImageSample) - double(redNewImageSample)));
    end
end

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
