% Code to evaluate the effect of incorporating different # of eigenvectors for probe
% reconstruction.
clc
clear, close all
[FunctionsLibPath,DataPath] = StartupPR;
p = genpath(FunctionsLibPath); addpath(p), clear p
%% Inputs==================================================================
% Basic Inputs ============================================================
RunNos = 146:190;                % Run Numbers to for generating basis
dateFile = '2020_11_24';        % Date folder
% Inputs for OD evaluation ================================================
I_sat = 2410;                   % Saturation intensity [camera counts]
% Reconstruction Inputs ===================================================
RunNo_reconst = 151;            % Image run number to reconstruct
N_ev = 1:1:length(RunNos);      % #of PC used to reconstruct
CropX = [196 500];              % Col pix#s to crop the image for square ROI reconst.
CropY = [196 500];              % Row pix#s to crop the image for square ROI reconst.
Xc = 350; Yc = 355;             % Center for ring ROI
R_mean = 95; thk = 60;          % Radius and thickness of ring ROI
% Display Options =========================================================
countLimMax = 9500;             % Image count lim for display 
ODLimMax = 0.5;                 % OD lim for display
SavePlots = true;               % Save plot? [logical]

%% Initialize =============================================================
dirSave = 'GS_Images'; dirCurrent = cd;
if exist(fullfile(cd,dirSave), 'dir') == 0
    mkdir(fullfile(cd,dirSave));
end
saveName = ['GS_NumPCvar_Date' strrep(dateFile,'_','-') sprintf('_Run%d',...
    RunNo_reconst)];
diff_out_mean = zeros(length(N_ev),1);
diff_out_std = zeros(length(N_ev),1);

%% Example Reconstruction: Ring ROI =======================================
% Get the usual OD, atm and prb ===========================================
A = DataExp(dateFile, RunNo_reconst,'Andor',DataPath);
[OD, atm, prb] = ExtractOD(A,'I_sat',I_sat);
% Prepare Ring mask and reconstruct =====================================
Nx = A.pixNo(2); Ny = A.pixNo(1);
x = 1:1:Nx; y = 1:1:Ny;
x = x - Xc; y = y - Yc;
[X,Y] = meshgrid(x,y);
[TH,R] = cart2pol(X,Y);
clear X Y x y
mask = ones(Ny,Nx); mask(R>R_mean-thk/2 & R<R_mean+thk/2) = 0;
GSdataSet = GSset(dateFile,RunNos,'basepath',DataPath,'Cam','Andor','Mask',mask);
for ii = 1:1:length(N_ev)
    [OD_re, ~, prb_re] = ExtractOD(A,'I_sat',I_sat,'PrRe','GS','GSsetValue',GSdataSet,...
    'Mask',mask,'N_ev',N_ev(ii));
    diff_out = prb_re(mask~=0)-atm(mask~=0);
    diff_out_mean(ii) = mean(diff_out);
    diff_out_std(ii) = std(diff_out);
end
%% Plot ===================================================================
figure(1), clf
subplot(2,1,1)
plot(N_ev,diff_out_mean,'.','MarkerSize',15);
grid on; ylabel(sprintf('$\\left<A-P_{re}\\right>_{pix}$ (counts)'));
title([sprintf('Basis evaluated from %d images \n',length(RunNos)) sprintf('GS evaluated over Runs %0.0f to %0.0f',...
    RunNos(1), RunNos(end)) ' (' strrep(dateFile,'_','/') ')' ]);
subplot(2,1,2)
plot(N_ev,diff_out_std,'.','MarkerSize',15);
grid on; ylabel(sprintf('$STD(A-P_{re})_{pix}$ (counts)'));
xlabel('Number of eigen-images used');
if SavePlots
    set(gcf, 'PaperUnits', 'inches','PaperPosition', [0 0 10 7]);
    cd(dirSave); print(saveName,'-dpng','-r200'); cd(dirCurrent);        
end

