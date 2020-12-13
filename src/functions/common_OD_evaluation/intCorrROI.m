function [probe, atoms, conv_fac, warn_ind] = intCorrROI(probe,atoms,varargin)
% ===================================================================================
% Function corrects for probe intensity fluctuations
% Input: Probe and Atom absorption image
% Output: Corrected Probe and Atom absorption image
% ===================================================================================
    
    %% Parse Optional Inputs ========================================================
    p = inputParser;
    addParameter(p,'Mask',[],@isnumeric);
    addParameter(p,'CropX',[1 50],@isnumeric);
    addParameter(p,'CropY',[1 50],@isnumeric);
    parse(p,varargin{:});
    mask = p.Results.Mask;
    CropX = p.Results.CropX;
    CropY = p.Results.CropY;
    
    %% Check Inputs =================================================================
    if (isempty(mask) && ~isempty(CropY) && ~isempty(CropX))
        mask = ones(size(probe));
        mask(CropY(1):CropY(2),CropX(1):CropX(2)) = 0;
    elseif (isempty(mask) && isempty(CropY) && isempty(CropX))
        error('intCorrROI: All CropX, CropY and Mask cannot be set to empty.');
    end
    %% Threshold parameters defining the success of intensity correction ============
    conv_fac_low = 0.8;     % Threshold for normalization factor "conversion"
    conv_fac_high = 1.2;
    warn_ind = 0;
    
    %% Extracting images ============================================================
    s = size(probe);
    if size(atoms)~=s
        error('intCorrROI: Bare Probe signal is not the same size as Signal');
    end
    if size(mask)~=s
        error('intCorrROI: Mask should be same size as atoms image')
    end
  
    %% Conversion factor estimation =================================================
    atoms_msk = atoms.*mask;
    probe_msk = probe.*mask;
    conv_fac = mean(atoms_msk(:))/mean(probe_msk(:));
    probe = probe*conv_fac;
    
    if (conv_fac>conv_fac_high || conv_fac<conv_fac_low)
        warning('intCorrROI: Huge intensity fluctuations: Factor = %0.2f',conv_fac);
        warn_ind = 1;
    end
    
end