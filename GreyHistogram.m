function imageHistogram = createHistogramFromImage(initialImage)

[imageWidth, imageHeight, imageDims] = size(initialImage);
greyImage = 0;
if(imageDims == 1)
    greyImage = initialImage;
else
    greyImage = rgb2grey(initialImage);
end

for imageRow = 1 : imageHeight
    for imageColumn = 1 : imageWidth
        
    end
end

imageHistogram = 0