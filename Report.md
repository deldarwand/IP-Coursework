<style>
h1, h2, h3, h4, h5 { text-align: center; }
img { display: block; margin: auto; }
</style>
# Image Segmentation Coursework
### By Daniel Eldar

## Core Section
### Task 1 - Histograms
The histogram task can be found in the **'CourseworkHistogram.m'** file and will take the **'girlface.bmp'** image and **'cameraman.tif'** in the folder, and use the function in **'GreyHistogram.m'** count the various intensities and return the histogram data for each image.
Afterward the histograms are shown as well as the histograms from MATLAB's histogram function.

![Girlface and Cameraman Histograms](Images/CourseworkHistogram.png)

 Camera Man Image | Girlface Image
:---------------------------------: | :--------------------------------:
![Cameraman](Images/Cameraman.png) | ![Girlface](Images/Girlface.png)

As we can see from the histograms, the distribution across the greyscale of both images is quite different throughout the intensities.

### Task 2 - Thresholding
The thresholding task can be found in the **'CourseworkThreshold.m'** file, it will take the **'girlface.bmp'** image file and will run a loop with how many values we want and run it through the `Threshold` function found in **'Threshold.m'** with a calculated threshold from the loop index variable and store the subplot the image. The function call looks like so:

`Threshold(GirlfaceImage, ImageRepeat * (255 / NumberOfImages), true);`

Where the image is passed as `GirlfaceImage`, the threshold as `ImageRepeat * (255 / NumberOfImages)` and then the final parameter is whether `imshow` should be called on the results of the function (true means that it will be called therefore imshow doesn't need to be called in the **'CourseworkThreshold.m'** file).

After the loop the `Threshold` function is called again with the value I chose after running some tests and then the original image is shown on the figure.

The results of the file when it is run are:
![Girlface Thresholding Results](Images/ThresholdsRepresentation.png)

The main problem with an algorithm like this is that it has a set threshold for whether the pixel is in the Region of Interest or not which means that as is the case with this image, if the Region of Interest Contains intensities that are also present somewhere else in the image, those are going to show up as the Region of Interest, there is not much that can be done about it in this algorithm.

Through the different values for the threshold in the image above it can be seen how it is quite difficult to separate the skin correctly using this method.

### Task 3 - Thresholding ROC Curve
The creation of a Receiver Operating Characteristic Curve can be found in the **'ROCThreshold.m'** file, it will read the **'girlface.bmp'** image file and will run the thresholding algorithm on it with the thresholding values between 0 and 255. It will then calculate the true positive fraction (sensitivity) and the false positive fraction (1 - specificity) by comparing the image returned with the ground truth constructed and stores them in an array. Once everything is calculated, the desired operating point is calculated in a separate function which is given all of the data and then the ROC curve is plotted using MATLAB's plot function.

The results of the code look like so:
![Girlface Thresholding ROC Curve](Images/ThresholdingROCCurve.png)

As can be seen, the performance of the thresholding algorithm is reasonable, separating most of the skin in the image after the desired operating point is calculated, however, it still includes most of the background and even some of the hair in the Region of Interest which isn't really the best performance compared to what we want as can be seen in the ground truth.

The following is a comparison of the threshold from the trial and error approach which settles at 80 and the threshold from the calculation of the desired operating point which came out to 53:

![Girlface Trial and Error vs. DOP Calculation](Images/GirlfaceThresholdComparison.png)

As you can see the one with the calculated threshold got almost all of the skin, however, it got all of the background as well and quite a lot from the hair and clothing, while the trial and error, while getting a lot less of the skin, got much less of the background and other unwanted features.


## Advanced Section
### Task 1 - Region Growing
The region algorithm can be easily run through the **'CourseworkRegionGrowing.m'** file, which will run the algorithm with several seed locations and the neighbourhood that is set. The implementation of the algorithm can be found in the **'RegionGrowing.m'** file in the `RegionGrowing` function which can work with either a 4 neighnbourhood scheme or an 8 neighnbourhood scheme. Originally, for **'CourseworkRegionGrowing.m'**, the threshold values used for testing were the values from the previous thresholding algorithms to see the effect of the different seed locations on the Region of Interest. As can be seen in the images below, there isn't much difference between the difference positions as long as they are not in some very dark regions of the image:

| Neighbourhood Size  \ <br>Threshold | 53  |  80|
|:-------------------------------:|:---:|:--:|
|   4 Neighbourhood  | ![T53,4N](Images/Girlface4Neighbourhood53Threshold.png)        |  ![T80,4N](Images/Girlface4Neighbourhood80Threshold.png)    |
|   8 Neighbourhood  |  ![T53,8N](Images/Girlface8Neighbourhood53Threshold.png)      |  ![T53,8N](Images/Girlface8Neighbourhood80Threshold.png)    |

After those tests, the point `[256, 256]` was chosen to be the seed for the ROC curve calculations as it was a good point across all of the tests above which gave a reasonable region from it.

The following ROC curve was obtained by running the thresholds from 0 to 255 (inclusive) on the region growing algorithm with the seed `[256, 256]` (`ROCRegionGrowing.m` can be run to obtain that result) :

![Girlface Region Growing ROC Curve](Images/RegionGrowingROCCurve.png)

Along with the ROC curve you can see the region obtained from the suggested desired operating point calculated from the ROC curve. This one is quite different from the previous techniques as this one excludes a large amount of the background while getting most of the skin. However, it still missed quite a bit of it.

### Task 2 - Mean Shift
