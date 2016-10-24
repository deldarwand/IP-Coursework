function histogramData = GreyHistogram(initialImage)

[imageWidth, imageHeight, imageDims] = size(initialImage);
greyImage = 0;
if(imageDims == 1)
    greyImage = initialImage;
else
    greyImage = rgb2grey(initialImage);
end

histogramData = uint32(zeros(1, 256));

for imageRow = 1 : imageHeight
    for imageColumn = 1 : imageWidth
        imageSample = greyImage(imageRow,imageColumn);
        histogramData(imageSample+1) = histogramData(imageSample+1)+1;
    end
end

bar(histogramData)