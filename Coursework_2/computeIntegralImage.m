function [ii] = computeIntegralImage(image)

%REPLACE THIS
ii = zeros(size(image), 'double');

[width, height] = size(image);
ii(1,1) = image(1,1);

for x = 1 : width
    for y = 1 : height
        if(x == 1 && y == 1)
            %don't do anything
        else
            imageSample = image(x,y);
            verticalSample =0; horizontalSample = 0; sampleToRemove = 0;
            if(y-1 >= 1)
                verticalSample = ii(x,y-1);
            else
                verticalSample = 0;
            end
            if(x-1 >= 1)
                horizontalSample = ii(x-1,y);
            else
                horizontalSample = 0;
            end
            if(y-1 >= 1 && x-1 >= 1)
                sampleToRemove = ii(x-1,y-1);
            else
                sampleToRemove = 0;
            end
            
            finalSample = double(imageSample) + double(horizontalSample) + double(verticalSample) - double(sampleToRemove);
            ii(x,y) = finalSample;
        end
    end
end
end