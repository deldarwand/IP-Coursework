function GreyImage = Threshold(Image, Threshold, showImage)

[Width, Height, Dimension] = size(Image);

GreyImage = 0;
if(Dimension == 1)
    GreyImage = Image;
else
    GreyImage = rgb2grey(Image);
end

for Column = 1 : Width
    for Row = 1 : Height
    	GreyImage(Column, Row) = (Image(Column, Row) >= Threshold) * 255;
    end
end
if(showImage == true)
    imshow(GreyImage);
end
end
