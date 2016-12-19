function CourseworkThreshold()
    GirlfaceImage = imread('girlface.bmp');
    [ImageWidth, ImageHeight] = size(GirlfaceImage);
    NumberOfImages = 16
    
    for ImageRepeat = NumberOfImages - 2 : -1 : 1 
        subplot(sqrt(NumberOfImages),sqrt(NumberOfImages),ImageRepeat);
        Threshold(GirlfaceImage, ImageRepeat * (255 / NumberOfImages), true);
    end
    subplot(sqrt(NumberOfImages),sqrt(NumberOfImages),NumberOfImages-1);
    Threshold(GirlfaceImage, 80, true);
    
    subplot(sqrt(NumberOfImages),sqrt(NumberOfImages),NumberOfImages);
    imshow(GirlfaceImage);
end