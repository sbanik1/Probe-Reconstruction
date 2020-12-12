function [orthogonalBasis] = GramSchmidt(INPUT_data,varargin) 
% =================================================================================
% This function evaluates the GS eigenvectors
%   INPUT_data: NyXNxXN matrix of input data (Image demensions = [Ny,Nx], # of images = N )
%   mask: Ny X Nx 2D array of mask (optional)
% Outputs:
%   orthogonalBasis: NyXNxXN matrix of basis
% ===================================================================================

    %% Initialize =========================================================
    Ny = size(INPUT_data,1);
    Nx = size(INPUT_data,2);
    N = size(INPUT_data,3);
    orthogonalBasis = zeros(Ny,Nx,N);
    
    %% Assemble optional inputs ===========================================
    p = inputParser;
    p.addParameter('Mask',ones(Ny,Nx),@(x)(isnumeric(x) && size(x,1) == Ny && size(x,2) == Nx && length(size(x)) == 2));
    parse(p,varargin{:}); 
    mask = p.Results.Mask;


    for n = 1:1:N
        x = INPUT_data(:,:,n);
        orthogonalBasis(:,:,n) = x;
        % Graham-Schmidt orthogonalization:
        for m = n-1:-1:1
            orthogonalBasis(:,:,n) = orthogonalBasis(:,:,n) - orthogonalBasis(:,:,m)*...
                (sum(sum(x.*mask.*orthogonalBasis(:,:,m))))/(sum(sum(orthogonalBasis(:,:,m).*...
                mask.*orthogonalBasis(:,:,m))));
        end
    end

    % Actually normalize the basis:
    for n = 1:1:N
        orthogonalBasis(:,:,n) = orthogonalBasis(:,:,n)/sum(sum(orthogonalBasis(:,:,n).*...
            mask.*orthogonalBasis(:,:,n)))^.5;
    end
    
end