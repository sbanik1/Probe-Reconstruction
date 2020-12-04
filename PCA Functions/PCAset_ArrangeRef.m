% =================================================================================
% Arrange the probe images in matrix form to perform PCA

function [INPUT_data] = PCAset_ArrangeRef(Data, CropX, CropY, varargin) 
    % ================================================================================
    % Check input type
    if ~isa(Data,'DataExp')
        error('PCAset_ArrangeRef: Input 1 needs to be an object of class DataExp');
    end  
    % ================================================================================= 
    % Workspace setup
    set(0,'DefaultFigureWindowStyle','docked')
    if exist(Data.basepath, 'dir') == 0
        error('PCAset_ArrangeRef: Basepath does not exist, check with cd ');
    end
    % =================================================================================
    % Initialize
    Nx = CropX(2)-CropX(1)+1;
    Ny = CropY(2)-CropY(1)+1;
    run_tot = max(size(Data.runNos)); % total number of runs in sequence
    INPUT_data = zeros( Ny*Nx, run_tot );
        

    %% Start loop
    for loop_idx = 1:1:run_tot
   
        %% Load and read images
        % =================================================================================
        % Read images
        clear prb backg
        [~, prb, backg] = ExtractImages(Data,loop_idx);

        % Crop Images
        [PosX_Cam,PosY_Cam] = ImageAxes(prb,Data);
        [~,~,prb] = CropImage(PosX_Cam,PosY_Cam, prb,CropX,CropY);
        [~,~,backg] = CropImage(PosX_Cam,PosY_Cam, backg,CropX,CropY);
        prb = prb - backg;
        
        % Reshape and place data
        INPUT_data(:,loop_idx) = double(reshape(prb,[size(prb,1)*size(prb,2),1]));
 
    end
end

% =================================================================================
% Local Functions
% =================================================================================
function [atm, prb, bck] = ExtractImages(Data,idxImage)
   
    clear bck atm prb
    if idxImage > max(size(Data.runNos))
        error('PCAset_ArrangeRef::ExtractImages: Run index exceeds total number of runs!');
    end
    if Data.camera == "Andor"
        bck(:,:) = imread(char(Data.backg(idxImage)));
        atm(:,:) = imread(char(Data.atoms(idxImage)));
        prb(:,:) = imread(char(Data.probe(idxImage)));
    elseif Data.camera == "FleaH1"
        bck(:,:) = double(load(Data.backg(idxImage)));
        atm(:,:) = double(load(Data.atoms(idxImage)));
        prb(:,:) = double(load(Data.probe(idxImage)));
    else
        error('PCAset_ArrangeRef::ExtractImages: Camera type invalid!');
    end

    atm = double(atm);
    prb = double(prb);
    bck = double(bck);

    % Check if pixels are saturated
    if max(max(prb))>=Data.satCam
        warning('PCAset_ArrangeRef::ExtractImages: Run #%.0f: Pixels are saturated.',run_number);
    end

end

