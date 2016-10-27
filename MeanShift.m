function MeanShift()

WindowSize = 50;
NumberOfWindows = fix(255/WindowSize);
DivisionRemainder = rem(255, WindowSize);

if(DivisionRemainder > 0)
    NumberOfWindows = NumberOfWindows + 1;
end

GirlfaceImage = imread('girlface.bmp');
[ImageWidth, ImageHeight] = size(GirlfaceImage);

OutputImage = imread('girlface.bmp');
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

for Repeat = 1 : 1000
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
            CurrentSample = GirlfaceImage(Column, Row);
            if(CurrentSample >= LowerThreshold && CurrentSample < UpperThreshold)
                PixelsValueTotal = PixelsValueTotal + double(CurrentSample);
                PixelsInWindowCount = PixelsInWindowCount + 1;
                OutputImage(Column, Row) = Window;
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

for Window = 1 : NumberOfWindows
    WindowMiddleGround = WindowCentres(Window);
    for Column = 1 : ImageWidth
        for Row = 1 : ImageHeight
            CurrentSample = OutputImage(Column, Row);
            if(CurrentSample == Window)
                OutputImage(Column, Row) = WindowMiddleGround;
            end
        end
    end
end
imshow(OutputImage)
end