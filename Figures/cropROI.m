function [xCrop,yCrop,imgCrop] = cropROI(xFull, yFull, imgFull,roiCol,roiRow)
% ===================================================================================
% Function to crop an image (imgFull) and its coordinate axes (xFull,yFull)
% imgFull, xFull and yFull are matrices of the same size
% The region of interest is defined by the vectors roiCol and roiRow
% roiCol and roiRow are 1x2 vectors indicating start and end of roi columns/rows
% ===================================================================================

if size(roiCol,1)>1, roiCol = roiCol'; end
if size(roiRow,1)>1, roiRow = roiRow'; end
if (size(roiCol,2)~=2 || roiCol(1)<1 || roiCol(1)>size(imgFull,2))
    error('croproi: roiCol parameter invalid!'); 
elseif (size(roiRow,2)~=2 || roiRow(1)<1 || roiRow(1)>size(imgFull,1))
    error('croproi: roiRow parameter invalid!'); 
end

imgCrop = imgFull(roiRow(1):roiRow(2), roiCol(1):roiCol(2));
xCrop = xFull(roiRow(1):roiRow(2), roiCol(1):roiCol(2));
yCrop = yFull(roiRow(1):roiRow(2), roiCol(1):roiCol(2));

end
