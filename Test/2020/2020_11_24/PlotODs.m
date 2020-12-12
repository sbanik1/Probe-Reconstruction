% Code to create PCA basis
clc
clear, close all
[FunctionsLibPath,DataPath] = StartupPR;
p = genpath(FunctionsLibPath); addpath(p), clear p
%% Inputs==================================================================
% Basic Inputs ============================================================
RunNo_plot = [146,151,159];     % Image run number to reconstruct
RunNo_GSbasis = 146:190;        % Image run number for GS basis
dateFile = '2020_11_24';        % Date folder
PrRe = 'GS';                    % Type of Probe Reconst. [Choose from 'None', 'PCA' or 'GS']
% Inputs for OD evaluation ================================================
I_sat = 2410;                   % Saturation intensity [camera counts]
% ROI Inputs ==============================================================
Xc = 350; Yc = 355;             % Center for ring ROI [pix#]
R_mean = 95; thk = 60;          % Radius and thickness of ring ROI [pix]
% Display Options =========================================================
countLimMax = 9500;             % Image count lim for display 
ODLimMax = 0.5;                 % OD lim for display
SavePlots = true;               % Save plot? [logical]

%% Initialize =============================================================
dirSave = 'OD_Images'; dirCurrent = cd;
if exist(fullfile(cd,dirSave), 'dir') == 0
    mkdir(fullfile(cd,dirSave));
end
saveName = ['ODs_Date' strrep(dateFile,'_','-') '_' PrRe];

%% Get the OD =============================================================
A = DataExp(dateFile, RunNo_plot,'Andor',DataPath);
% Prepare Ring mask =======================================================
Nx = A.pixNo(2); Ny = A.pixNo(1);
x = 1:1:Nx; y = 1:1:Ny;
x = x - Xc; y = y - Yc;
[X,Y] = meshgrid(x,y);
[~,R] = cart2pol(X,Y);
clear X Y x y
mask = ones(Ny,Nx); mask(R>R_mean-thk/2 & R<R_mean+thk/2) = 0;
% Evaluate OD =============================================================
if strcmp(PrRe,'PCA')    
    load('PCA.mat');
    [ODs, ~, ~] = ExtractOD(A,'I_sat',I_sat,'PrRe',PrRe,'PCAsetValue',PCAdataSet,...
    'Mask',mask,'N_ev',[]);
elseif strcmp(PrRe,'GS')
    % Determine the GS Eigenvectors 
    GSdataSet = GSset(dateFile,RunNo_GSbasis,'basepath',DataPath,'Cam','Andor','Mask',mask);
    [ODs, ~, ~] = ExtractOD(A,'I_sat',I_sat,'PrRe',PrRe,'GSsetValue',GSdataSet,...
    'Mask',mask,'N_ev',[]);
else
    [ODs, ~, ~] = ExtractOD(A,'I_sat',I_sat,'PrRe',PrRe);
end  
% Get some stats ==========================================================
AN_org = zeros(length(A.runNos),1);
for ii = 1:1:length(A.runNos)
    temp = ODs(:,:,ii);
    temp = temp(~mask);
    AN_org(ii) = sum(temp);
end
%% Plot the Image ============================================================
angles = linspace(-pi, pi,100);
x_out = (R_mean+thk/2) * cos(angles)+Xc;
y_out = (R_mean+thk/2) * sin(angles)+Yc;
x_in = (R_mean-thk/2) * cos(angles)+Xc;
y_in = (R_mean-thk/2) * sin(angles)+Yc;
figure(2), clf
for ii = 1:1:length(A.runNos)
    subplot(1,length(A.runNos),ii)
    imagesc(ODs(:,:,ii),[-0.5 ODLimMax]); colorbar; grid on; axis image;
    hold on; plot(x_out,y_out,'Color', 'k','LineWidth',2);
    hold on; plot(x_in,y_in,'Color', 'k','LineWidth',2); hold off;
    title(sprintf('Run %0.0f, $OD$ \n $\\Sigma OD_{in}$ = %0.2f',...
        A.runNos(ii),AN_org(ii)));
end
if SavePlots
    set(gcf, 'PaperUnits', 'inches','PaperPosition', [0 0 3*length(A.runNos) 3]);
    cd(dirSave); print(saveName,'-dpng','-r200'); cd(dirCurrent);        
end

