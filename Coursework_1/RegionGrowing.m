function RegionGrowingImage = RegionGrowing(Image, Seed, Threshold, NeighbourhoodSize, ShowImage)

[ImageWidth, ImageHeight] = size(Image);

BoundaryQueue = zeros(2, ImageWidth*ImageHeight, 'int32');
BoundaryQueueHead = 1;
BoundaryQueue(:, BoundaryQueueHead) = Seed;

VisitedPixels = zeros(ImageWidth, ImageHeight, 'uint8');
VisitedPixels(Seed) = 1;

while(BoundaryQueueHead ~= 0)
    CurrentPosition = BoundaryQueue(:, BoundaryQueueHead);
    BoundaryQueueHead = BoundaryQueueHead - 1;
    CurrentSample = Image(CurrentPosition(1), CurrentPosition(2));
    ShouldIncludePixel = ShouldInclude(CurrentSample, Threshold);
    if( ShouldIncludePixel == 1 )
        VisitedPixels(CurrentPosition) = 2;
        PixelNeighbourhood = GetPixelNeighbourhood(CurrentPosition(1), CurrentPosition(2), NeighbourhoodSize);
        for NeighbourPixel = 1 : NeighbourhoodSize
            NeighbourPosition = PixelNeighbourhood(NeighbourPixel, :);
            NeighbourXPosition = NeighbourPosition(1);
            NeighbourYPosition = NeighbourPosition(2);
            IsPixelPositionOK = true;
            if(NeighbourXPosition < 1 || NeighbourXPosition > ImageWidth)
                IsPixelPositionOK = false;
            end
            if(NeighbourYPosition < 1 || NeighbourYPosition > ImageHeight)
                IsPixelPositionOK = false;
            end
            
            if(IsPixelPositionOK == true)
                if(VisitedPixels(NeighbourXPosition, NeighbourYPosition) == 0)
                BoundaryQueueHead = BoundaryQueueHead + 1;
                BoundaryQueue(1, BoundaryQueueHead) = NeighbourXPosition;
                BoundaryQueue(2, BoundaryQueueHead) = NeighbourYPosition;
                VisitedPixels(NeighbourXPosition, NeighbourYPosition) = 1;
                end
            end
        end
    end
end
if (ShowImage == true)
    imshow(VisitedPixels >= 1);
    hold on;
    plot(Seed(1),Seed(2),'r.','MarkerSize',20);
end
RegionGrowingImage = VisitedPixels >= 1;
end

%Gets the pixels neighbourhood.
%Only supports NeighbourhoodSize 4 or 8.
function PixelNeighbourhood = GetPixelNeighbourhood(XPosition, YPosition, NeighbourhoodSize)

PixelNeighbourhood = zeros(2, NeighbourhoodSize, 'int32');

if (NeighbourhoodSize == 4)
    PixelNeighbourhood = [XPosition, YPosition - 1;...
                          XPosition + 1, YPosition;...
                          XPosition, YPosition + 1;...
                          XPosition - 1, YPosition];
elseif(NeighbourhoodSize == 8)
    PixelNeighbourhood = [XPosition, YPosition - 1;...
                          XPosition + 1, YPosition - 1;...
                          XPosition + 1, YPosition;...
                          XPosition + 1, YPosition + 1;...
                          XPosition, YPosition + 1;...
                          XPosition - 1, YPosition + 1;...
                          XPosition - 1, YPosition;...
                          XPosition - 1, YPosition - 1;
                          ];
end

end

function ShouldIncludePixel = ShouldInclude(ImageSample, Threshold)
ShouldIncludePixel = (ImageSample >= Threshold);
end