
function [signals,PC,V] = PCA_EvaluatePCs(data,varargin)
% =================================================================================
% This function arranges the probe images in 1D matrix form for PCA
% evaluation.
%   data: MxN matrix of input data (M dimensions, N trials)
%   mode: mode of SVD operation (option) [Choose from [] or 'econ']
%   PixX: 2 elemnt vector defining how to crop the images along X [start_pix, end_pix] 
%   PixY: 2 elemnt vector defining how to crop the images along Y [start_pix, end_pix] 
% Outputs:
%   signals: MxN matrix of projected data
%   PC: principal components
%   V: Mx1 matrix of variances
% ===================================================================================
    %% Assemble optional inputs ===========================================
    p = inputParser;
    p.addParameter('mode','econ',@(x)ischar(x));
    parse(p,varargin{:});     
    
    [M,N] = size(data);
    % subtract off the mean for each dimension
    mn =  mean(data,2);
    data = data - repmat(mn,1,N);
    % construct the matrix Y
    Y = data' / sqrt(N-1);
    % SVD does it all
    if isempty(p.Results.mode)
        [~,S,PC] = svd(Y);
    elseif strcmp(p.Results.mode,'econ')
        [~,S,PC] = svd(Y,'econ');
    else
        error('PCA_EvaluatePCs: mode can only be econ');
    end
    
    % Calculate the variances
    S = diag(S);
    V = S .* S;
    % Project the original data
    signals = PC' * data;
end
