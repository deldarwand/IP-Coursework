function CourseworkHistogram()
CameramanImage = imread('cameraman.tif');
GirlfaceImage = imread('girlface.bmp');




GirlfaceHistogramData = GreyHistogram(GirlfaceImage);
CameramanHistogramData = GreyHistogram(CameramanImage);

subplot(2,2,1);
bar(GirlfaceHistogramData);
annotation('textbox',get(gca,'Position'),'String', 'My function''s Girlface Histogram');

subplot(2,2,3);
histogram(GirlfaceImage, 256);
annotation('textbox',get(gca,'Position'),'String', 'MATLAB''s Girlface Histogram');

subplot (2,2,2);
bar(CameramanHistogramData);
annotation('textbox',get(gca,'Position'),'String', 'My function''s Cameraman Histogram');

subplot(2,2,4);
histogram(CameramanImage, 256);
annotation('textbox',get(gca,'Position'),'String', 'MATLAB''s Cameraman Histogram');



end