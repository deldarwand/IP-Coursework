function OutputImage = MeanShift(WindowSize, InitialImage, NumberOfRepeats)

NumberOfWindows = fix(255/WindowSize);
DivisionRemainder = rem(255, WindowSize);

if(DivisionRemainder > 0)
    NumberOfWindows = NumberOfWindows + 1;
end

[ImageWidth, ImageHeight] = size(InitialImage);
WindowCentres = zeros(NumberOfWindows, 1);

%Sets initial middle ground for all of the windows.
for Window = 1 : NumberOfWindows
    LowerThreshold = (Window - 1) * WindowSize;
    UpperThreshold = Window * WindowSize;
    if(Window == NumberOfWindows)
        UpperThreshold = 256;
    end
    MiddleGround = double(LowerThreshold + UpperThreshold) / 2.0;
    WindowCentres(Window) = MiddleGround;
end

for Repeat = 1 : NumberOfRepeats
    for Window = 1 : NumberOfWindows
        WindowMiddleGround = WindowCentres(Window);
        LowerThreshold = WindowMiddleGround - (double(WindowSize) / 2.0);
        UpperThreshold = WindowMiddleGround + (double(WindowSize) / 2.0);
        if(UpperThreshold > 256)
            UpperThreshold = 256;
        end
        if(LowerThreshold < 0)
            LowerThreshold = 0;
        end
        PixelsInWindowCount = 0;
        PixelsValueTotal = double(0.0);
        for Column = 1 : ImageWidth
            for Row = 1 : ImageHeight
                CurrentSample = InitialImage(Column, Row);
                if(CurrentSample >= LowerThreshold && CurrentSample < UpperThreshold)
                    PixelsValueTotal = PixelsValueTotal + double(CurrentSample);
                    PixelsInWindowCount = PixelsInWindowCount + 1;

                end
            end
        end

        NewMiddleGround = double(PixelsValueTotal) / double(PixelsInWindowCount);
        if(PixelsInWindowCount == 0)
            NewMiddleGround = double(LowerThreshold + UpperThreshold) / 2.0;
        end
        WindowCentres(Window) = NewMiddleGround;
    end
end

WindowLabels = zeros(NumberOfWindows, 1, 'uint8');
WindowLabelsIntensities = zeros(NumberOfWindows, 1, 'uint8');
for Label = 0 : NumberOfWindows - 1
    WindowLabelsIntensities(Label+1) = Label * (255 / NumberOfWindows);
    WindowLabels(Label+1) = Label+1;
end


OutputImage = zeros(ImageWidth, ImageHeight, 'uint8');

for Window = 1 : NumberOfWindows
    sprintf('Ran number %i out of %i', Window, NumberOfWindows)
    WindowMiddleGround = WindowCentres(Window);
    LabelToUse = GetLabelToUse(WindowLabels(Window), InitialImage, OutputImage, WindowMiddleGround, WindowSize);
    WindowMiddleGround = WindowCentres(Window);
    LowerThreshold = WindowMiddleGround - (double(WindowSize) / 2.0);
    UpperThreshold = WindowMiddleGround + (double(WindowSize) / 2.0);
    if(UpperThreshold > 256)
        UpperThreshold = 256;
    end
    if(LowerThreshold < 0)
        LowerThreshold = 0;
    end
    
    for Column = 1 : ImageWidth
        for Row = 1 : ImageHeight
            CurrentSample = InitialImage(Column, Row);
            if(CurrentSample >= LowerThreshold && CurrentSample < UpperThreshold)
                OutputImage(Column, Row) = LabelToUse;
            end
        end
    end
end
OutputImage = ConvertLabelsToIntensities(ImageWidth, ImageHeight, OutputImage,WindowLabelsIntensities);
end

function OutputImage = ConvertLabelsToIntensities(ImageWidth, ImageHeight, LabelledImage, LabelIntensity)
for Column = 1 : ImageWidth
    for Row = 1 : ImageHeight
        if(LabelledImage(Column, Row) ~= 0)
            LabelledImage(Column, Row) = LabelIntensity(LabelledImage(Column, Row));
        end
    end
end
imshow(LabelledImage)
OutputImage = LabelledImage;
end

function LabelToUse = GetLabelToUse(CurrentWindowLabel, OriginalImage, CurrentImage, WindowCentre, WindowSize)
[ImageWidth, ImageHeight] = size(CurrentImage);
LabelToUse = CurrentWindowLabel;
LowerThreshold = WindowCentre - (double(WindowSize) / 2.0);
UpperThreshold = WindowCentre + (double(WindowSize) / 2.0);
if(UpperThreshold > 256)
    UpperThreshold = 256;
end
if(LowerThreshold < 0)
    LowerThreshold = 0;
end

for Column = 1 : ImageWidth
    for Row = 1 : ImageHeight
        CurrentOriginalSample = OriginalImage(Column, Row);
        CurrentSample = CurrentImage(Column, Row);
        if(CurrentOriginalSample >= LowerThreshold && CurrentOriginalSample < UpperThreshold)
            if(CurrentSample ~= 0)
                LabelToUse = CurrentSample;
            end
        end
    end
end
end
