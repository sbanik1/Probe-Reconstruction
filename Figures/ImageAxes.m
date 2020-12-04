function [X,Y] = ImageAxes(Image, Data)
% =================================================================================
% Function to generate real axes for image
% Data is an object of class DataExp
% =================================================================================

% Check input type
if ~isa(Data,'DataExp')
    error('ImageAzes:: Input 2 needs to be an object of class DataExp!');
end

L = Data.pixAtom*size(Image); % [um]
PosX_Cam = linspace(-L(2)/2,L(2)/2,size(Image,2));
PosY_Cam = linspace(-L(1)/2,L(1)/2,size(Image,1));
[X,Y] = meshgrid(PosX_Cam,PosY_Cam); %[um]

end