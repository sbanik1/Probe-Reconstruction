function [probe, atoms, conv_fac_mean, warn_ind] = intCorrCorner(probe, atoms, pix_corner)
% ===================================================================================
% Function corrects for probe intensity fluctuations
% Input: Probe and Atom absorption image
% Output: Corrected Probe and Atom absorption image
% ===================================================================================
    % Threshold parameters defining the success of intensity correction
    conv_fac_low = 0.8;     % Threshold for normalization factor "conversion"
    conv_fac_high = 1.2;
    warn_ind = 0;
    
    % Extracting images
    s = size(probe);
    if size(atoms)~=s
        error('Bare Probe signal is not the same size as Signal');
    end
    if pix_corner>min(s)
        error('Comparision square should be smaller than image')
    end
  
    % Conversion factor estimation for each pixel
    conv_fac = ones(pix_corner,pix_corner);
    for ix = 1:pix_corner
        for iy = 1:pix_corner
            if (atoms(ix,iy) == 0)
                conv_fac(ix,iy) = 1;
            else
                conv_fac(ix,iy) = probe(ix,iy)/atoms(ix,iy);
            end
        end
    end  
    conv_fac_sum = sum(sum(conv_fac));
    terms = pix_corner^2;   
    conv_fac_mean = conv_fac_sum/terms;
    if (conv_fac_mean>conv_fac_high || conv_fac_mean<conv_fac_low)
        warning('Huge intensity fluctuations: Factor = %0.2f',conv_fac_mean);
        warn_ind = 1;
    end
    
    %figure(4)
    %imagesc(conv_fac);
    %title(sprintf('Normalization Co-efficient: Conversion Factor = %0.2f',conv_fac_mean));
    %colorbar
    %pause(2);

    %% Corrected Images
    atoms = conv_fac_mean*atoms;

    clear ix iy terms conv_fac_sum 
    
end