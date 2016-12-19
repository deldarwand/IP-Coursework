function CourseworkRegionGrowing()

NumberOfSubdivisions = 2;
NumberOfLines = 2 ^ NumberOfSubdivisions;
NumberOfPoints = NumberOfLines + 1;
GirlfaceImage = imread('girlface.bmp');
[ImageWidth, ImageHeight] = size(GirlfaceImage);

WidthInterval = ImageWidth / NumberOfPoints;
HeightInterval = ImageHeight / NumberOfPoints;


NeighbourhoodSize = 8;
CourseworkThresholds = [53, 80];
for CourseworkThreshold = 1 : 2
figure;
for Column = 0 : NumberOfPoints-1
    for Row = 0 : NumberOfPoints-1
        CurrentXPosition = int32(WidthInterval * Column + 1);
        CurrentYPosition = int32(HeightInterval * Row + 1);
        
        subplot(NumberOfPoints, NumberOfPoints, Column*NumberOfPoints + Row + 1);
        RegionGrowing(GirlfaceImage, [CurrentXPosition, CurrentYPosition], CourseworkThresholds(CourseworkThreshold), NeighbourhoodSize, true);
        sprintf('Finished number %i out of %i', (Column*NumberOfPoints + Row + 1) + (NumberOfPoints^2 * (CourseworkThreshold-1)), 2*NumberOfPoints^2)
    end
end
end

end