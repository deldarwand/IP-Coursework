function CourseworkMeanShift()

NumberOfWindowSizes = 5;
WindowSizes = [20,40,60,80,100];

GirlfaceImage = imread('girlface.bmp');
CameramanImage = imread('cameraman.tif');

figure;
for Window = 1 : NumberOfWindowSizes
    subplot(3,2,Window);
    MeanShift(WindowSizes(Window), GirlfaceImage, 50);
end

subplot(3,2,6);
imshow(GirlfaceImage);

figure;
for Window = 1 : NumberOfWindowSizes
    subplot(3,2,Window);
    MeanShift(WindowSizes(Window), CameramanImage, 50);
end
subplot(3,2,6);
imshow(CameramanImage);

end