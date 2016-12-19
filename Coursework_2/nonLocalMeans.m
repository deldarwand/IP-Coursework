function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

[paddedImage, paddingSize] = padImage(image, windowSize, patchSize);
%imshow(paddedImage);

[setOfOffsets, numberOfOffsets] = getSetOfOffsets(windowSize);
[lowerPatchOffset, upperPatchOffset] = getSetOfPatchOffsets(patchSize);

newImage = double(zeros(size(paddedImage)));
[paddedWidth,paddedHeight, ~] = size(paddedImage);
weightSumImage = double(zeros(paddedWidth,paddedHeight,1));

[imageWidth, imageHeight, ~] = size(image);
for windowXOffsetIndex = 1 : numberOfOffsets
    for windowYOffsetIndex = 1 : numberOfOffsets %Loops through window offsets.
        windowXOffset = setOfOffsets(windowXOffsetIndex);
        windowYOffset = setOfOffsets(windowYOffsetIndex);
        differenceImage = getDifferenceImage(paddedImage, windowXOffset, windowYOffset);
        integralImage = computeIntegralImage(differenceImage);
        disp(['Integral Image: ', num2str(windowYOffsetIndex + ((windowXOffsetIndex-1)*numberOfOffsets)), ' out of:',...
            num2str(numberOfOffsets*numberOfOffsets)]);
        for x = paddingSize-1 : imageWidth+paddingSize-1
            for y = paddingSize-1 : imageHeight+paddingSize-1 %Loops through every pixel in the image.
                patchLowerXPosition = x- lowerPatchOffset;
                patchLowerYPosition = y- lowerPatchOffset;
                patchUpperXPosition = x+ upperPatchOffset;
                patchUpperYPosition = y+ upperPatchOffset;
                
                patchDistance = getSumOfPatch(integralImage, patchLowerXPosition, patchLowerYPosition, patchUpperXPosition, patchUpperYPosition);

                pixelWeight = computeWeighting(patchDistance, h, sigma, patchSize);
                originalImageSample = paddedImage(x+windowXOffset,y+windowYOffset, :);
                weightedPixel = double(originalImageSample) * pixelWeight;
                newPixel = (newImage(x,y,:) + weightedPixel);
                newImage(x,y,:) = newPixel(:);
                weightSumImage(x,y) = weightSumImage(x,y) + pixelWeight;
            end
        end
    end
end
        
newImageInt = zeros(size(image), 'double');

for x = paddingSize : imageWidth+paddingSize-1
    for y = paddingSize : imageHeight+paddingSize-1
        currentNewImageSample = newImage(x,y,:);
        currentWeightSum = weightSumImage(x,y);
        currentNewImageSample = currentNewImageSample / currentWeightSum;
        newImageInt(x-paddingSize+1,y-paddingSize+1,:) = (currentNewImageSample(:));
    end
end
%imshow(newImage);
% imshow(newImageInt);
result = newImageInt;
end

function [lowerOffset, upperOffset] = getSetOfPatchOffsets(patchSize)
isPatchSizeEven = mod(patchSize, 2);

if(isPatchSizeEven == 0) %The search size is even.
    lowerOffset = (patchSize - 2) / 2;
    upperOffset = patchSize / 2;
    
else %The search size is odd.
    lowerOffset = (patchSize - 1) / 2;
    upperOffset = (patchSize - 1) / 2;
    
end

end

function [setOfOffsets, numberOfOffsets] = getSetOfOffsets(windowSize)

isSearchWindowSizeEven = mod(windowSize, 2);

%lowerOffset, upperOffset;

if(isSearchWindowSizeEven == 0) %The search size is even.
    lowerOffset = (windowSize - 2) / 2;
    upperOffset = windowSize / 2;
    
else %The search size is odd.
    lowerOffset = (windowSize - 1) / 2;
    upperOffset = (windowSize - 1) / 2;
    
end


setOfOffsets = -lowerOffset : upperOffset;
numberOfOffsets = lowerOffset+upperOffset + 1;


end

function [paddedImage, paddingSize] = padImage(image, windowSize, patchSize)

paddingSize = (windowSize+patchSize)*2;
[imageWidth, imageHeight, colours] = size(image);
paddedImage = zeros(imageWidth+paddingSize, imageHeight+paddingSize, colours, 'double');

for x = 1 : imageWidth+paddingSize
    for y = 1 : imageHeight+paddingSize
        positionXInOriginal = abs(x - (paddingSize/2))+1;
        positionYInOriginal = abs(y - (paddingSize/2))+1;
        
        if(positionXInOriginal > imageWidth)
            positionXInOriginal = imageWidth - (positionXInOriginal - imageWidth);
        end
        if(positionYInOriginal > imageHeight)
            positionYInOriginal = imageHeight - (positionYInOriginal - imageHeight);
        end
        currentImageSample = image(positionXInOriginal, positionYInOriginal, :);
        paddedImage(x,y, :) = currentImageSample;
    end
end
paddingSize = paddingSize/2;
end

function differenceImage = getDifferenceImage(image, offsetX, offsetY)

[imageWidth, imageHeight, ~] = size(image);
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
        oldImageSample = oldImageSample(1);
        newImageSample = newImageSample(1);
     
        sampleDifference = double(double(oldImageSample) - double(newImageSample));
        
        differenceImage(x,y,1) = sampleDifference*sampleDifference;
    end
end

end

function finalSample = getSumOfPatch(integralImage, xLower, yLower, xUpper, yUpper)

fullSample = integralImage(xUpper, yUpper);
sampleToDeleteA = integralImage(xUpper, yLower-1);
sampleToDeleteB = integralImage(xLower-1, yUpper);
sampleToAddBack = integralImage(xLower-1, yLower-1);

finalSample = double(fullSample) - double(sampleToDeleteA) - double(sampleToDeleteB) + double(sampleToAddBack);


end

