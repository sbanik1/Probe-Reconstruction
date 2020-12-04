function [OD, atm, prb] = ExtractOD(DataExp,idxImage,varargin)
% =================================================================================
% Function to extract OD
% Inputs:
% - DataExp: object defined by DataExp(date, runNos, camera, basepath)
% - idxImage: image index within data set (1 if single run)
% - intFlcCorr: apply intensity correction 1=Yes, 0=No(default)
% - I_sat: correct for high intensity imaging. Default is Inf (no correction)
% - PCA: True if probe reconstruction via PCA is desired. [logical]
% - PCAsetValue: The PCAset object to perform PCA. This is needed if Probe reconstruction
%       desiered.
% - CropX, CropY, Mask: Either CropX and CropY or a mask needs to be provided to perform
%       PCA
% Returns:
% - atm, prb: Post processed atom and probe images
% - OD: Cloud OD
% =================================================================================

    %% Parse the optional arguments ==================================================
    p = inputParser;
    addParameter(p,'PCA',false,@islogical);
    addParameter(p,'intFlcCorr',0,@isnumeric);
    addParameter(p,'I_sat',Inf,@isnumeric);
    addParameter(p,'PCAsetValue',[],@(x) isa(x,'PCAset'));
    addParameter(p,'CropX',[],@isnumeric);
    addParameter(p,'CropY',[],@isnumeric);
    addParameter(p,'Mask',[],@isnumeric);
    addParameter(p,'N_ev',15,@isnumeric);
    p.addParameter('ScaleProbe',true,@(x)islogical(x));
    parse(p,varargin{:});
    PCA = p.Results.PCA;
    intFlcCorr = p.Results.intFlcCorr;
    I_sat = p.Results.I_sat;
    PCAsetValue = p.Results.PCAsetValue;
    CropX = p.Results.CropX;
    CropY = p.Results.CropY;
    N_ev = p.Results.N_ev;
    mask = p.Results.Mask;

    %% Check if all required inputs are provided
    if PCA
        if isempty(PCAsetValue)
            error('ExtractOD: PCAset object needs to be provided.'); 
        end
        if (isempty(mask) && (isempty(CropX) || isempty(CropY)))
            error('ExtractOD:: Either Mask or CropX and CropY needs to be provided.');
        end
    end
    
    if idxImage > max(size(DataExp.runNos))
        error('ExtractOD: Run index exceeds total number of runs!');
    end
    
    %% Determine Camera and Initialize ==============================================
    clear bck atm prb
    CAM = DataExp.camera(1:5);
    if strcmp(CAM,'Andor')==1
        bck(:,:) = imread(char(DataExp.backg(idxImage)));
        atm(:,:) = imread(char(DataExp.atoms(idxImage)));
        prb(:,:) = imread(char(DataExp.probe(idxImage)));
    elseif strcmp(CAM,'FleaH')==1
        bck(:,:) = double(load(DataExp.backg(idxImage)));
        atm(:,:) = double(load(DataExp.atoms(idxImage)));
        prb(:,:) = double(load(DataExp.probe(idxImage)));
    else
        error('ExtractOD: Camera type invalid!');
    end
    atm = double(atm-bck);
    prb = double(prb-bck);

    %% Reconstruct the probe if PCA set to true =====================================
    if PCA
        if ~isempty(mask)
            [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'Mask',mask, 'N_ev',N_ev,'ScaleProbe',p.Results.ScaleProbe);
        else        
            [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'CropX',CropX,'CropY', CropY, 'N_ev',N_ev,'ScaleProbe',p.Results.ScaleProbe);
        end
    end

    %% Check if pixels are saturated
    if max(max(prb))>=DataExp.satCam
        fprintf('ExtractOD: Pixels are saturated.\n');
    end

    %% Probe Intensity Fluctuation Correction =======================================
    if ~PCA
        if intFlcCorr == 1, [prb,atm,~,~] = intCorrCorner(prb,atm,50); end
        if intFlcCorr == 2 
            [prb,atm,~,~] = intCorrROI(prb,atm,'Mask',mask,'CropX',CropX,'CropY',CropY); 
        end
    end
    
    %% Calculate OD
    atmOD = atm;
    prbOD = prb;
    % Based on NIST code 'analysis\od\calc_OD_basic'
    % If any pixel is less than one, make it one.  This prevents
    % divergences when taking the logarithm:
    atmOD(atmOD < 1) = 1;
    prbOD(prbOD < 1) = 1;

    if I_sat == Inf
        OD =  -log(atmOD./prbOD);
    else
        OD =  -log(atmOD./prbOD) + (prbOD-atmOD)./I_sat;
    end

end