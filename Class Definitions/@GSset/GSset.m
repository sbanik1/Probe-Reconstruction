classdef GSset
    properties
      % Very Basic Properties
      RunNos       % Run nos for basis
      dateFile     % date of images
      basepath     % basepath
      PixX         % ROI along the column
      PixY         % ROI along the row
      Cam          % Camera
      Mask         % Mask to mask probes before evaluating GS eigenvectors
      
      % Derived Quantities
      GS          % 3D array of GS eigen vectors. The different vectors are along the 3rd dimension.
    end

    %% Methods
    methods
        
        % Constructor =================================================================
        function obj = GSset(varargin) % ======================
            % Arrange the inputs
            % dateFile == YYYY/MM/DD
            % RunNo == 1D array of run numbers, e.g., '1:23'
            if nargin>1
                p = inputParser;
                addRequired(p,'dateFile',@(x)ischar(x));
                addRequired(p,'RunNos',@isnumeric);
                p.addParameter('Cam','Andor',@(x)ischar(x));
                p.addParameter('basepath','\\systemadministr\data\raw',@(x)ischar(x));
                p.addParameter('Mask',[],@(x)isnumeric(x));
                parse(p,varargin{:}); 
                obj.dateFile = p.Results.dateFile;
                obj.RunNos = p.Results.RunNos;
                obj.Cam = p.Results.Cam;
                obj.basepath = p.Results.basepath;
                obj.Mask = p.Results.Mask;

                A = DataExp(obj.dateFile, obj.RunNos,obj.Cam,obj.basepath);
                obj.PixY = [1,A.pixNo(1)]; obj.PixX = [1,A.pixNo(2)];
                if ~isempty(p.Results.Mask)
                    if size(obj.Mask,1) ~= obj.PixY
                        error('GSset::GSset: Size of Mask along rows/Y is wrong.');
                    end
                    if size(obj.Mask,2) ~= obj.PixX
                        error('GSset::GSset: Size of Mask along cols/X is wrong.');
                    end
                else
                    obj.Mask = ones(obj.PixY,obj.PixX);
                end
           
                [~, ~, DataIn] = ExtractOD(A,'intFlcCorr',0);
            else
                p = inputParser;
                addRequired(p,'DataIn',@isnumeric);
                parse(p,varargin{:}); 
                DataIn = p.Results.DataIn;
                obj.PixY = [1,size(DataIn,1)]; obj.PixX = [1,size(DataIn,2)];
                if size(DataIn,3) == 1
                    error('GSset::GSset: The input data needs to be a 3D array.')
                end
                
            end
            obj.GS = GramSchmidt(DataIn,'Mask',obj.Mask);                      
        end % =======================================================================

        % Function to reconstruct image ======================================
        % Inputs:
        %   obj: The 'GSset' class object
        %   N_ev: (Optional) The number of eigenvectors to be used for
        %   re-construction
        function [ImageProj, coeff] = GSset_ReConstr(obj, ImageIn, varargin) 
            p = inputParser;
            p.addParameter('N_ev',size(obj.GS,3),@(x)isnumeric(x));
            p.addParameter('CropX',[],@(x)isnumeric(x));
            p.addParameter('CropY',[],@(x)isnumeric(x));
            p.addParameter('Mask',[],@(x)isnumeric(x));
            parse(p,varargin{:}); 
            N_ev = p.Results.N_ev;
            cropX = p.Results.CropX;
            cropY = p.Results.CropY;
            mask = p.Results.Mask;
            
            Nx = obj.PixX(2)-obj.PixX(1)+1; 
            Ny = obj.PixY(2)-obj.PixY(1)+1;
            if (size(ImageIn,1) ~= Ny || size(ImageIn,2) ~= Nx)
                error('GSset::GSset_ReConstr: Dimensions of image do not match those of GS Eigenvectors.');
            end
            if (isempty(mask) && ~isempty(cropX) && ~isempty(cropY))
                mask = ones(Ny,Nx); 
                mask(cropY(1):cropY(end),cropX(1):cropX(end)) = 0;
            elseif ~isempty(mask)
                if size(mask)~=[Ny,Nx]
                    error('GSset::GSset_ReConstr: Mask needs to be the same size as Image.');
                end
            else
                error('GSset::GSset_ReConstr: Either Mask or CropX and CropY needs to be provided.');
            end
            
            ImageIn = ImageIn.*mask;
            coeff = zeros(N_ev,1);
            for ii= 1:1:N_ev 
                coeff(ii) = sum(sum(obj.GS(:,:,ii).*ImageIn));
            end
            ImageProj = zeros(size(ImageIn));
            for ii= 1:1:N_ev       
                ImageProj = ImageProj+coeff(ii,1)*obj.GS(:,:,ii);
            end
            
        end
  

    end
end
