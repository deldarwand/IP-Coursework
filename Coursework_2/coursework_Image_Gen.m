patchSizes = 1:1:10;
sigmas = (5/256):(5/256):(50/256)
decays = 0.1:0.1:1.0; %decay parameter
windowSizes = 8:1:18;
%TODO - Read an image (note that we provide you with smaller ones for
%debug in the subfolder 'debug' int the 'image' folder);
%Also unless you are feeling adventurous, stick with non-colour
%images for now.
%NOTE: for each image, please also read its CORRESPONDING 'clean' or
%reference image. We will need this later to do some analysis
%NOTE2: the noise level is different for each image (it is 20, 10, and 5 as
%indicated in the image file names)
cd(fileparts(mfilename('fullpath')))
imageNoisy = im2double(imread(['images/debug/','townNoisy_sigma5.png']));
imageNoisy = rgb2gray(imageNoisy);
figure;
imshow(imageNoisy);
imageReference = im2double(imread(['images/debug/','townReference.png']));
imageReference = rgb2gray(imageReference);

for index = 1 : 10
    sigma = sigmas(index);
    h = decays(index);
    patchSize = patchSizes(index);
    windowSize = windowSizes(index);
    filtered = nonLocalMeans(imageNoisy, sigma, h, patchSize, windowSize);
    figure('name', ['Window ', num2str(windowSize), ' Patch Size', num2str(patchSize), ' Decay:', num2str(h)...
        , ' Sigma', num2str(sigma)]);
    imshow(filtered);
end

% imageNoisy = zeros(200, 200);
figure;
tic;
%TODO - Implement the non-local means function
