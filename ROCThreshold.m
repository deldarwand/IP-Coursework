function ROCThreshold()

GirlfaceImage = imread('girlface.bmp');
GirlfaceGroundTruth = imread('girlfaceGT.bmp');
GirlfaceGroundTruth = NormaliseImage(GirlfaceGroundTruth);
[ImageWidth, ImageHeight] = size(GirlfaceImage);

ROCValues = zeros(2, 256);
TotalPositives = 0;
TotalNegatives = 0;
for ThresholdValue = 0:255
    ThresholdImage = Threshold(GirlfaceImage, ThresholdValue, false);
    TruePositives = 0;
    TrueNegatives = 0;
    FalsePositives = 0;
    FalseNegatives = 0;
    for Column = 1 : ImageWidth
        for Row = 1 : ImageHeight
            ThresholdImageSample = uint8(ThresholdImage(Column, Row));
            GirlfaceGroundTruthSample = GirlfaceGroundTruth(Column, Row);
            
            if(GirlfaceGroundTruthSample == 255 && ThresholdImageSample == 255)
                TruePositives = TruePositives + 1;
            elseif(GirlfaceGroundTruthSample == 0 && ThresholdImageSample == 0)
                TrueNegatives = TrueNegatives + 1;
            elseif(GirlfaceGroundTruthSample == 255 && ThresholdImageSample == 0)
                FalseNegatives = FalseNegatives + 1;
            elseif(GirlfaceGroundTruthSample == 0 && ThresholdImageSample == 255)
                FalsePositives = FalsePositives + 1;
            end
        end
    end
    TotalPositives = (TruePositives + FalseNegatives);
    TotalNegatives = (FalsePositives + TrueNegatives);
    YValue = TruePositives / (TruePositives + FalseNegatives);
    XValue = FalsePositives / (FalsePositives + TrueNegatives);
    
    if(TruePositives + FalseNegatives == 0)
        YValue = 0;
    elseif(FalsePositives + TrueNegatives == 0)
        XValue = 0;
    end
    
    ROCValues(1, ThresholdValue+1) = XValue;
    ROCValues(2, ThresholdValue+1) = YValue;

end

OperatingPoint = GetOperatingPointGradientForROC(TotalPositives, TotalNegatives, ROCValues);

subplot(2,2,1);
imshow(GirlfaceImage);
subplot(2,2,2);
imshow(GirlfaceGroundTruth);
subplot(2,2,3);
plot(ROCValues(1,:), ROCValues(2,:));


subplot(2,2,4);
Threshold(GirlfaceImage, OperatingPoint, true);
annotation('textbox',get(gca,'Position'),'String', sprintf('DOP \nis:%i.', OperatingPoint));
end


function NormalisedImage = NormaliseImage(GroundTruthImage)
[ImageWidth, ImageHeight] = size(GroundTruthImage);
NormalisedImage = uint8(GroundTruthImage);
for Column = 1 : ImageWidth
    for Row = 1 : ImageHeight
        if(NormalisedImage(Column, Row) == 0)
            NormalisedImage(Column, Row) = 0;
        elseif(NormalisedImage(Column, Row) == 1)
            NormalisedImage(Column, Row) = 255;
        end
    end
end
end

function ROCPointIndex = GetOperatingPointGradientForROC(TotalPositive, TotalNegative, ROCData)
ROCPointIndex = 1;

FalsePositiveCost = 1.0;
FalseNegativeCost = 1.0;

GradientToMatch = (TotalNegative / TotalPositive) * (FalsePositiveCost / FalseNegativeCost);

IndexClosestToGradient = -1;
[Dimensions, NumberOfMeasurements] = size(ROCData);

for Measurement = 1 : NumberOfMeasurements-1
    CurrentMeasurement = ROCData(:,Measurement);
    NextMeasurement = ROCData(:, Measurement+1);
    
    CurrentGradient = (NextMeasurement(2) - CurrentMeasurement(2)) / (NextMeasurement(1) - CurrentMeasurement(1));
    
    if(IndexClosestToGradient ~= -1)
        CurrentClosestGradientMeasurement = ROCData(:, IndexClosestToGradient);
        NextClosestGradientMeasurement = ROCData(:, IndexClosestToGradient+1);
        CurrentClosestGradient = (NextClosestGradientMeasurement(2) - CurrentClosestGradientMeasurement(2)) / (NextClosestGradientMeasurement(1) - CurrentClosestGradientMeasurement(1));
        
        if(abs(CurrentGradient - GradientToMatch) < abs(CurrentClosestGradient - GradientToMatch))
            IndexClosestToGradient = Measurement;
        end
    else
        IndexClosestToGradient = Measurement;
    end
    
end
ROCPointIndex = IndexClosestToGradient;
end
