% Code to create GS basis
clc
clear, close all
[FunctionsLibPath,DataPath] = StartupPR;
p = genpath([FunctionsLibPath 'Probe-Reconstruction']); addpath(p), clear p
%% Inputs==================================================================
% Basic Inputs ============================================================
RunNos = 31:200;                % Run Numbers to for generating basis
dateFile = '2020_11_24';        % Date folder
% Inputs for OD evaluation ================================================
I_sat = 2410;                   % Saturation intensity [camera counts]
% Reconstruction Inputs ===================================================
RunNo_reconst = 367;            % Image run number to reconstruct
N_ev = [];                      % #of PC used to reconstruct
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
saveName_reconst = ['GS_re_Date' strrep(dateFile,'_','-') sprintf('_Run%d',...
    RunNo_reconst)];

%% Example Reconstruction: Square ROI ===================================== 
% Get the usual OD, atm and prb ===========================================
A = DataExp(dateFile, RunNo_reconst,'Andor',DataPath);
[OD, atm, ~] = ExtractOD(A,'I_sat',I_sat);
% Prepare a Square ========================================================
Nx = A.pixNo(2); Ny = A.pixNo(1);
mask = ones(Ny,Nx); mask(CropY(1):CropY(2),CropX(1):CropX(2)) = 0;
% Determine the GS Eigenvectors ===========================================
GSdataSet = GSset(dateFile,RunNos,'basepath',DataPath,'Cam','Andor','Mask',mask);
% Reconstrcut and find OD =================================================
[OD_re, ~, prb_re] = ExtractOD(A,'I_sat',I_sat,'PrRe','GS','GSsetValue',GSdataSet,...
    'Mask',mask,'N_ev',N_ev);
% Calculate some stats ====================================================
avg_out_atm = atm(mask~=0); avg_out_atm = mean(avg_out_atm(:));
std_out_atm = atm(mask~=0); std_out_atm = std(std_out_atm(:));
avg_out_re = prb_re(mask~=0); avg_out_re = mean(avg_out_re(:));
std_out_re = prb_re(mask~=0); std_out_re = std(std_out_re(:));
AN_org = sum(OD(~mask)); AN_re = sum(OD_re(~mask));
% Plot the Image ============================================================
figure(2), clf
subplot(2,2,1)
imagesc(atm,[0 countLimMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f, Atoms Image: $A$\n$Avg_{out}$ = %0.2f counts\n$Std_{out}$ = %0.2f counts',...
    RunNo_reconst,avg_out_atm,std_out_atm));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k','LineWidth',2);
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k','LineWidth',2); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k','LineWidth',2);
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k','LineWidth',2); hold off;
subplot(2,2,2)
imagesc(prb_re,[-0.5 countLimMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f, Reconst. Image: $P_{re}$\n$Avg_{out}$ = %0.2f counts\n $Std_{out}$ = %0.2f counts',...
    RunNo_reconst,avg_out_re,std_out_re));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k','LineWidth',2);
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k','LineWidth',2); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k','LineWidth',2);
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k','LineWidth',2); hold off;
std_out_diff = prb_re(mask~=0)-atm(mask~=0);
text(0,150,sprintf('$Std[P_{re}-A]_{out}$ = %0.2f',std(std_out_diff(:))),'FontSize',14);
subplot(2,2,3)
imagesc(OD,[-0.5 ODLimMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f, $OD_{org}$:',RunNo_reconst));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k','LineWidth',2);
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k','LineWidth',2); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k','LineWidth',2);
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k','LineWidth',2); hold off;
title(sprintf('Run %0.0f, $OD_{org}$ \n $\\Sigma OD$ = %0.2f',...
    RunNo_reconst,AN_org));
subplot(2,2,4)
imagesc(OD_re,[-0.5 ODLimMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f, $OD_{re}$:',RunNo_reconst));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k','LineWidth',2);
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k','LineWidth',2); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k','LineWidth',2);
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k','LineWidth',2); hold off;
title(sprintf('Run %0.0f, $OD_{re}$ \n $\\Sigma OD$ = %0.2f',...
    RunNo_reconst,AN_re));
if SavePlots
    set(gcf, 'PaperUnits', 'inches','PaperPosition', [0 0 10 10]);
    cd(dirSave); print([saveName_reconst '_ROIsquare'],'-dpng','-r200'); cd(dirCurrent);        
end

%% Example Reconstruction: Ring ROI =======================================
% Get the usual OD, atm and prb ===========================================
A = DataExp(dateFile, RunNo_reconst,'Andor',DataPath);
[OD, atm, ~] = ExtractOD(A,'I_sat',I_sat);
% Prepare Ring mask =======================================================
Nx = A.pixNo(2); Ny = A.pixNo(1);
x = 1:1:Nx; y = 1:1:Ny;
x = x - Xc; y = y - Yc;
[X,Y] = meshgrid(x,y);
[TH,R] = cart2pol(X,Y);
clear X Y x y
mask = ones(Ny,Nx); mask(R>R_mean-thk/2 & R<R_mean+thk/2) = 0;
% Determine the GS Eigenvectors ===========================================
GSdataSet = GSset(dateFile,RunNos,'basepath',DataPath,'Cam','Andor','Mask',mask);
% Reconstruct and obtain OD ===============================================
[OD_re, ~, prb_re] = ExtractOD(A,'I_sat',I_sat,'PrRe','GS','GSsetValue',GSdataSet,...
    'Mask',mask,'N_ev',N_ev);
% Get some stats ==========================================================
avg_out_atm = atm(mask~=0); avg_out_atm = mean(avg_out_atm(:));
std_out_atm = atm(mask~=0); std_out_atm = std(std_out_atm(:));
avg_out_re = prb_re(mask~=0); avg_out_re = mean(avg_out_re(:));
std_out_re = prb_re(mask~=0); std_out_re = std(std_out_re(:));
AN_org = sum(OD(~mask)); AN_re = sum(OD_re(~mask));
% Plot the Data ==========================================================
angles = linspace(-pi, pi,100);
x_out = (R_mean+thk/2) * cos(angles)+Xc;
y_out = (R_mean+thk/2) * sin(angles)+Yc;
x_in = (R_mean-thk/2) * cos(angles)+Xc;
y_in = (R_mean-thk/2) * sin(angles)+Yc;

figure(3), clf,
subplot(2,2,1)
imagesc(atm,[0 countLimMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',2);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',2); hold off;
title(sprintf('Run %0.0f, Atoms Image: $A$\n$Avg_{out}$= %0.2f\n$Std_{out}$ = %0.2f counts',...
    RunNo_reconst,avg_out_atm,std_out_atm));
subplot(2,2,2)
imagesc(prb_re,[0 countLimMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',2);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',2); hold off;
err = std(reshape(atm.*mask-prb_re.*mask,Nx*Ny,1));
title(sprintf('Run %0.0f, Reconst. Image: $P_{re}$\n$Avg_{out}$ = %0.2f\n $Std_{out}$ = %0.2f counts',...
    RunNo_reconst,avg_out_re,std_out_re));
std_out_diff = prb_re(mask~=0)-atm(mask~=0);
text(0,150,sprintf('$Std[P_{re}-A]_{out}$ = %0.2f',std(std_out_diff(:))),'FontSize',14);
subplot(2,2,3)
imagesc(OD,[-0.5 ODLimMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',2);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',2); hold off;
title(sprintf('Run %0.0f, $OD_{org}$ \n $\\Sigma OD$ = %0.2f',...
    RunNo_reconst,AN_org));
subplot(2,2,4)
imagesc(OD_re,[-0.5 ODLimMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',2);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',2); hold off;
title(sprintf('Run %0.0f, $OD_{re}$ \n $\\Sigma OD$ = %0.2f',...
    RunNo_reconst,AN_re));
if SavePlots
    set(gcf, 'PaperUnits', 'inches','PaperPosition', [0 0 10 10]);
    cd(dirSave); print([saveName_reconst '_ROIring'],'-dpng','-r200'); cd(dirCurrent);        
end
