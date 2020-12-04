function [signals,PC,V] = PCA_SVD(data,mode)
    % PCA_SVD: Perform PCA using SVD.
    %     data - MxN matrix of input data
    %            (M dimensions, N trials)
    %     mode - mode for SVD operation (optional)
    %  signals - MxN matrix of projected data
    %       PC - each column is a PC
    %        V - Mx1 matrix of variances
    
    
    [M,N] = size(data);
    % subtract off the mean for each dimension
    mn =  mean(data,2);
    data = data - repmat(mn,1,N);
    % construct the matrix Y
    Y = data' / sqrt(N-1);
    % SVD does it all
    if nargin == 1
        [~,S,PC] = svd(Y);
    elseif nargin == 2
        [~,S,PC] = svd(Y,mode);
    else
        error('PCA_SVD:: Only 1 or 2 input arguments allowed!');
    end
    
    % Calculate the variances
    S = diag(S);
    V = S .* S;
    % Project the original data
    signals = PC' * data;
end
