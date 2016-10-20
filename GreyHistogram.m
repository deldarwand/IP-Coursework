function imageHistogram = GreyHistogram(initialImage)

[imageWidth, imageHeight, imageDims] = size(initialImage);
greyImage = 0;
if(imageDims == 1)
    greyImage = initialImage;
else
    greyImage = rgb2grey(initialImage);
end

histogramData = uint8(zeros(size(initialImage)));
histogramDataCounter = 1;

for imageRow = 1 : imageHeight
    for imageColumn = 1 : imageWidth
        imageSample = greyImage(imageRow,imageColumn);
        histogramData(histogramDataCounter) = imageSample;
        histogramDataCounter = histogramDataCounter+1 ;
    end
end

histogram(histogramData)
imageHistogram = 1;