% =================================================================================
% Function to crop an image and its X,Y axes
% =================================================================================

function [X,Y,Image] = CropImage(X, Y, Image,CropX,CropY)

    if size(CropX,1)>1, CropX = CropX'; end
    if size(CropY,1)>1, CropY = CropY'; end
    if (size(CropX,2)~=2 || CropX(1)<1 || CropX(2)>size(Image,2))
        error('CropImage: CropX parameter invalid!'); 
    elseif (size(CropY,2)~=2 || CropY(1)<1 || CropY(2)>size(Image,1))
        error('CropImage: CropY parameter invalid!'); 
    end

    Image = Image(CropY(1):CropY(2), CropX(1):CropX(2));
    X = X(CropY(1):CropY(2), CropX(1):CropX(2));
    Y = Y(CropY(1):CropY(2), CropX(1):CropX(2));
end
