classdef PCAset
    properties
      % Very Basic Properties
      RunNos       % Type of data [SingleFrq or DoubleFrq]
      dateFile     % date of images
      basepath     % basepath
      PixX         % ROI along the column
      PixY         % ROI along the row
      Cam          % Camera
      Mask         % Mask to mask probes before evaluating PCs
      
      % Derived Quantities
      PC          % 2D array of Principal Components. Each component is along a column. Rows represent the different pixels.
      meanval     % Mean of the data
      Var         % Variance associated with each PC
    end

    %% Methods
    % The methods of this class call the following functions:
    %   -Ring_ExtractData
    methods
        
        % Constructor =================================================================
        function obj = PCAset(varargin) % ======================
            % Arrange the inputs
            % dateFile == YYYY/MM/DD
            % RunNo == 1D array of run numbers, e.g., '1:23'
            if nargin>1
                p = inputParser;
                addRequired(p,'dateFile',@(x)ischar(x));
                addRequired(p,'RunNos',@isnumeric);
                p.addParameter('Cam','Andor',@(x)ischar(x));
                p.addParameter('basepath','\\systemadministr\data\raw',@(x)ischar(x));
                parse(p,varargin{:}); 
                obj.dateFile = p.Results.dateFile;
                obj.RunNos = p.Results.RunNos;
                obj.Cam = p.Results.Cam;
                obj.basepath = p.Results.basepath;

                A = DataExp(obj.dateFile, obj.RunNos,obj.Cam,obj.basepath);
                obj.PixY = [1,A.pixNo(1)]; obj.PixX = [1,A.pixNo(2)];
                [DataIn] = PCAset_ArrangeRef(A, obj.PixX, obj.PixY);
            else
                p = inputParser;
                addRequired(p,'DataIn',@isnumeric);
                parse(p,varargin{:}); 
                DataIn = p.Results.DataIn;
                obj.PixY = [1,size(DataIn,1)]; obj.PixX = [1,size(DataIn,2)];
                DataIn = reshape(DataIn,[obj.PixY(2)*obj.PixX(2),size(DataIn,3)]);
            end
            [~, obj.PC, obj.Var] = PCA_SVD(DataIn,'econ');
            obj.meanval = mean(DataIn,2);
            obj.PC = obj.PC(:,1:min(500,numel(obj.RunNos)));
                       
        end % =======================================================================

        % Function to reconstruct image ======================================
        % Inputs:
        %   obj: The 'PCAset' class object
        %   N_ev: (Optional) The number of eigenvalues to be used for PCA
        function [ImageProj, coeff] = PCAset_ReConstr(obj, ImageIn, varargin) 
            p = inputParser;
            p.addParameter('N_ev',size(obj.PC,2),@(x)isnumeric(x));
            p.addParameter('CropX',[],@(x)isnumeric(x));
            p.addParameter('CropY',[],@(x)isnumeric(x));
            p.addParameter('Mask',[],@(x)isnumeric(x));
            p.addParameter('ScaleProbe',true,@(x)islogical(x));
            parse(p,varargin{:}); 
            N_ev = p.Results.N_ev;
            cropX = p.Results.CropX;
            cropY = p.Results.CropY;
            mask = p.Results.Mask;
            ScaleProbe = p.Results.ScaleProbe;
            
            Nx = obj.PixX(2)-obj.PixX(1)+1; 
            Ny = obj.PixY(2)-obj.PixY(1)+1;
            if (size(ImageIn,1) ~= Ny || size(ImageIn,2) ~= Nx)
                error('PCAset::PCAset_ReConstr: Dimensions of image do not match those of PCs.');
            end
            if (isempty(mask) && ~isempty(cropX) && ~isempty(cropY))
                mask = ones(Ny,Nx); 
                mask(cropY(1):cropY(end),cropX(1):cropX(end)) = 0;
            elseif ~isempty(mask)
                if size(mask)~=[Ny,Nx]
                    error('PCAset::PCAset_ReConstr: Mask needs to be the same size as Image.');
                end
            else
                error('PCAset::PCAset_ReConstr: Either Mask or CropX and CropY needs to be provided.');
            end
            
            ImageIn = ImageIn.*mask; ImageIn = reshape(ImageIn,[Nx*Ny,1]);
            coeff = obj.PC'*(ImageIn-obj.meanval);
            ImageProj = obj.meanval;
            for ii= 1:1:N_ev       
                ImageProj = ImageProj+coeff(ii,1)*obj.PC(:,ii);
            end
            ImageProj = reshape(ImageProj,[Ny,Nx]);
            % Scale the Reconstructed Image
            if ScaleProbe
                ImageIn = reshape(ImageIn,[Ny,Nx]);
                avg_out_atm = ImageIn(mask~=0); avg_out_atm = mean(avg_out_atm(:));
                avg_out_re = ImageProj(mask~=0); avg_out_re = mean(avg_out_re(:));
                rescale_factor = avg_out_atm/avg_out_re;
                ImageProj = ImageProj*rescale_factor;               
            end
            
        end
  

    end
end
