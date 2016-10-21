function greyscaleImage = Greyscale_Kmeans(image, numberOfCentroids)

greyscaleImage = double(image);
imageSize = size(image); %triple number width, height and dimensions

stongestIntensity = 0;
for iRow = 1 : imageSize(1)
    for iColumn = 1 : imageSize(2)
        sampleIntensity = greyscaleImage(iRow,iColumn);
        if(sampleIntensity > stongestIntensity)
            stongestIntensity = sampleIntensity;
        end
    end
end

centroids = zeros(1, numberOfCentroids, 'double');
%centroids = rand(1,numberOfCentroids);
for i = 1 : numberOfCentroids
    centroids(i) = stongestIntensity/i;%centroids(i) * 255;
end

centroidsTotal = zeros(1, numberOfCentroids, 'uint8');
centroidsCount = zeros(1, numberOfCentroids, 'uint8');

for repeat = 1 : 30
for iRow = 1 : imageSize(1)
    for iColumn = 1 : imageSize(2)
        sampleIntensity = greyscaleImage(iRow,iColumn);
        closestCentroid = 1;
        for iCentroid = 1 : numberOfCentroids
            distanceToCentroid = (sampleIntensity - (centroids(iCentroid)));
            distanceToCurrentClosestCentroid = abs(sampleIntensity - centroids(closestCentroid));
            if(distanceToCentroid < distanceToCurrentClosestCentroid)
                closestCentroid = iCentroid;
            end
        end
        centroidsTotal(closestCentroid) = centroidsTotal(closestCentroid) + sampleIntensity;
        centroidsCount(closestCentroid) = centroidsCount(closestCentroid) + 1;
        %newCentroidIntensity = (centroids(closestCentroid) + sampleIntensity) / 2;
        %centroids(iCentroid) = newCentroidIntensity;
        %greyscaleImage(iRow, iColumn) = centroids(closestCentroid);
        %centroids(closestCentroid);
    end
end
    newCentroidIntensity = centroidsTotal(closestCentroid) / centroidsCount(closestCentroid);
    centroids(iCentroid) = newCentroidIntensity;
        centroidsTotal = zeros(1, numberOfCentroids, 'uint8');
        centroidsCount = zeros(1, numberOfCentroids, 'uint8');
end

newNumberOfCentroids = numberOfCentroids -1;
newCentroids = zeros(1, newNumberOfCentroids);
for i = 1 : newNumberOfCentroids
    newCentroidNumber = (centroids(i) + centroids(i+1)) / 2.0;
    newCentroids(i) = newCentroidNumber;
end

for iRow = 1 : imageSize(1)
    for iColumn = 1 : imageSize(2)
        sampleIntensity = greyscaleImage(iRow,iColumn);
        closestCentroid = 1;
        for iCentroid = 1 : newNumberOfCentroids
            distanceToCentroid = (sampleIntensity - (newCentroids(iCentroid)));
            distanceToCurrentClosestCentroid = abs(sampleIntensity - newCentroids(closestCentroid));
            if(distanceToCentroid < distanceToCurrentClosestCentroid)
                closestCentroid = iCentroid;
            end
        end
        greyscaleImage(iRow, iColumn) = newCentroids(closestCentroid);
        newCentroids(closestCentroid);
    end
end

greyscaleImage = uint8(greyscaleImage);
