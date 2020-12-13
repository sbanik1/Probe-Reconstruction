function [ODs, atms, prbs] = ExtractOD(DataExp,varargin)
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
    addParameter(p,'PrRe','None',@(x)(ischar(x) && ...
        (strcmp(x,'PCA') || strcmp(x,'GS') || strcmp(x,'None'))));
    addParameter(p,'intFlcCorr',0,@isnumeric);
    addParameter(p,'I_sat',Inf,@isnumeric);
    addParameter(p,'PCAsetValue',[],@(x) isa(x,'PCAset'));
    addParameter(p,'GSsetValue',[],@(x) isa(x,'GSset'));
    addParameter(p,'CropX',[],@isnumeric);
    addParameter(p,'CropY',[],@isnumeric);
    addParameter(p,'Mask',[],@isnumeric);
    addParameter(p,'N_ev',[],@isnumeric);
    parse(p,varargin{:});
    PrRe = p.Results.PrRe;
    intFlcCorr = p.Results.intFlcCorr;
    I_sat = p.Results.I_sat;
    PCAsetValue = p.Results.PCAsetValue;
    GSsetValue = p.Results.GSsetValue;
    CropX = p.Results.CropX;
    CropY = p.Results.CropY;
    N_ev = p.Results.N_ev;
    mask = p.Results.Mask;

    %% Check if all required inputs are provided
    
    if strcmp(PrRe,'PCA')
        if isempty(PCAsetValue)
            error('ExtractOD: PCAset object needs to be provided.'); 
        end
        if (isempty(mask) && (isempty(CropX) || isempty(CropY)))
            error('ExtractOD:: Either Mask or CropX and CropY needs to be provided.');
        end
    end
    if strcmp(PrRe,'GS')
        if isempty(GSsetValue)
            error('ExtractOD: GSset object needs to be provided.'); 
        end
        if (isempty(mask) && (isempty(CropX) || isempty(CropY)))
            error('ExtractOD:: Either Mask or CropX and CropY needs to be provided.');
        end
    end
    
    %% Initialize ==================================================================
    atms = zeros(DataExp.pixNo(1),DataExp.pixNo(2),length(DataExp.runNos));
    prbs = zeros(DataExp.pixNo(1),DataExp.pixNo(2),length(DataExp.runNos));
    ODs = zeros(DataExp.pixNo(1),DataExp.pixNo(2),length(DataExp.runNos));
    
    %% Start the loop ===============================================================
    currentDir = cd;
    cd(DataExp.basepath);
    for ii = 1:1:length(DataExp.runNos)
        %% Determine Camera and Initialize ==============================================
        clear bck atm prb
        CAM = DataExp.camera(1:5);
        if strcmp(CAM,'Andor')==1
            bck(:,:) = imread(char(DataExp.backg(ii)));
            atm(:,:) = imread(char(DataExp.atoms(ii)));
            prb(:,:) = imread(char(DataExp.probe(ii)));
        elseif strcmp(CAM,'FleaH')==1
            bck(:,:) = double(load(DataExp.backg(ii)));
            atm(:,:) = double(load(DataExp.atoms(ii)));
            prb(:,:) = double(load(DataExp.probe(ii)));
        else
            error('ExtractOD: Camera type invalid!');
        end
        atm = double(atm-bck);
        prb = double(prb-bck);

        %% Reconstruct the probe if PCA or GS set to true =====================================
        if strcmp(PrRe,'PCA')
            if ~isempty(mask)
                if isempty(N_ev)
                    [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'Mask',mask);
                else
                    [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'Mask',mask, 'N_ev',N_ev);
                end
            else    
                if isempty(N_ev)
                    [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'CropX',CropX,'CropY', CropY);
                else
                    [prb,~] = PCAset_ReConstr(PCAsetValue, atm, 'CropX',CropX,'CropY', CropY, 'N_ev',N_ev);
                end
            end
        elseif strcmp(PrRe,'GS')
            if ~isempty(mask)
                if isempty(N_ev)
                    [prb,~] = GSset_ReConstr(GSsetValue, atm, 'Mask',mask);
                else
                    [prb,~] = GSset_ReConstr(GSsetValue, atm, 'Mask',mask, 'N_ev',N_ev);
                end
            else
                if isempty(N_ev)
                    [prb,~] = GSset_ReConstr(GSsetValue, atm, 'CropX',CropX,'CropY', CropY);
                else
                    [prb,~] = GSset_ReConstr(GSsetValue, atm, 'CropX',CropX,'CropY', CropY, 'N_ev',N_ev);
                end
            end
        end

        %% Check if pixels are saturated
        if max(max(prb))>=DataExp.satCam
            fprintf('ExtractOD: Pixels are saturated.\n');
        end

        %% Probe Intensity Fluctuation Correction =======================================
        if strcmp(PrRe,'None')
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
        atms(:,:,ii) = atm;
        prbs(:,:,ii) = prb;
        ODs(:,:,ii) = OD;
    end
    cd(currentDir);

end