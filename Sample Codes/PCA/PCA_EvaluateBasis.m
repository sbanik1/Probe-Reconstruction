% Code to create PCA basis
clear, close all
[ErNaGD,basepath,~] = StartupErNa;
p = genpath([ErNaGD,'Data Analysis - SB']); addpath(p), clear p

%% Prepare the dataset
% Basic Inputs ============================
RunNos = 106:295;
dateFile = '2020_11_25';
Cam = 'Andor';

%% Determine the PCs

PCAdataSet = PCAset(dateFile,RunNos,'basepath',basepath,'Cam','Andor');
figure(1), clf, subplot(2,2,[1 2])
plot(1:1:size(PCAdataSet.Var,1),PCAdataSet.Var,'.','MarkerSize',10); grid on;
xlabel('PC Number'); ylabel('Variance'); 
title([strrep(dateFile,'_','/') ': ' sprintf('\nPC evaluated over Runs %0.0f to %0.0f',...
    RunNos(1), RunNos(end))]);
print(sprintf('PCA_Runs%0.0f-%0.0f', RunNos(1), RunNos(end)),'-dpng','-r200');
save('PCA','PCAdataSet');

%% Example Reconstruction: Square ROI ========================================
countMax = 9500;
A = DataExp(dateFile, RunNos,'Andor',basepath);
[~, atm, ~] = ExtractOD(A,1);
% ROI
CropX = [196 500];
CropY = [196 500];
Nx = 512; Ny = 512;

% Prepare mask and reconstruct ============================================
mask = ones(Ny,Nx); mask(CropY(1):CropY(2),CropX(1):CropX(2)) = 0;
[ImageProj, ~] = PCAset_ReConstr(PCAdataSet, atm,'Mask',mask,'N_ev',15,...
    'ScaleProbe',true);
avg_out_atm = atm(mask~=0); avg_out_atm = mean(avg_out_atm(:));
std_out_atm = atm(mask~=0); std_out_atm = std(std_out_atm(:));
avg_out_re = ImageProj(mask~=0); avg_out_re = mean(avg_out_re(:));
std_out_re = ImageProj(mask~=0); std_out_re = std(std_out_re(:));

% Plot the Image ============================================================
subplot(2,2,3)
imagesc(atm,[0 countMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f\nImage with Atoms: $A$\n$Avg_{out}$ = %0.2f counts\n$Std_{out}$ = %0.2f counts',...
    RunNos(1),avg_out_atm,std_out_atm));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k');
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k'); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k');
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k'); hold off;
subplot(2,2,4)
imagesc(ImageProj,[0 countMax]); colorbar; grid on; axis image;
title(sprintf('Run %0.0f\nReconstructed Image: $P_{re}$\n$Avg_{out}$ = %0.2f counts\n $Std_{out}$ = %0.2f counts',...
    RunNos(1),avg_out_re,std_out_re));
hold on; line(CropX, [CropY(1), CropY(1)], 'Color', 'k');
hold on; line(CropX, [CropY(2), CropY(2)], 'Color', 'k'); 
hold on; line([CropX(1), CropX(1)], CropY, 'Color', 'k');
hold on; line([CropX(2), CropX(2)], CropY, 'Color', 'k'); hold off;

std_out_diff = ImageProj(mask~=0)-atm(mask~=0);
text(0,150,sprintf('$Std[P_{re}-A]_{out}$ = %0.2f',std(std_out_diff(:))),'FontSize',14)

%% Example Reconstruction: Ring ROI
A = DataExp(dateFile, RunNos,'Andor',basepath);
[~, atm, ~] = ExtractOD(A,1);

% Cropping ROI
Xc = 350; Yc = 355;
R_mean = 25; thk = 60;

Nx = 512; Ny = 512;
x = 1:1:Nx; y = 1:1:Ny;
x = x - Xc; y = y - Yc;
[X,Y] = meshgrid(x,y);
[TH,R] = cart2pol(X,Y);
clear X Y x y

% Prepare mask and reconstruct ===========================================
mask = ones(Ny,Nx); mask(R>R_mean-thk/2 & R<R_mean+thk/2) = 0;
[ImageProj, coeff] = PCAset_ReConstr(PCAdataSet, atm,'Mask',mask,'N_ev',15,...
    'ScaleProbe',true); 
avg_out_atm = atm(mask~=0); avg_out_atm = mean(avg_out_atm(:));
std_out_atm = atm(mask~=0); std_out_atm = std(std_out_atm(:));
avg_out_re = ImageProj(mask~=0); avg_out_re = mean(avg_out_re(:));
std_out_re = ImageProj(mask~=0); std_out_re = std(std_out_re(:));

% Plot the Data ==========================================================
angles = linspace(-pi, pi,100);
x_out = (R_mean+thk/2) * cos(angles)+Xc;
y_out = (R_mean+thk/2) * sin(angles)+Yc;
x_in = (R_mean-thk/2) * cos(angles)+Xc;
y_in = (R_mean-thk/2) * sin(angles)+Yc;

figure(2), clf, subplot(2,2,[1 2])
plot(1:1:size(PCAdataSet.Var,1),PCAdataSet.Var,'.','MarkerSize',10); grid on;
title([strrep(dateFile,'_','/') ': ' sprintf('\nPC evaluated over Runs %0.0f to %0.0f',...
    RunNos(1), RunNos(end))]);
subplot(2,2,3)
imagesc(atm,[0 countMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',1);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',1); hold off;
title(sprintf('Run %0.0f\nImage with Atoms: $A$\n$Avg_{out}$= %0.2f\n$Std_{out}$ = %0.2f counts',...
    RunNos(1),avg_out_atm,std_out_atm));
subplot(2,2,4)
imagesc(ImageProj,[0 countMax]); colorbar; grid on; axis image;
hold on; plot(x_out,y_out,'Color', 'k','LineWidth',1);
hold on; plot(x_in,y_in,'Color', 'k','LineWidth',1); hold off;
err = std(reshape(atm.*mask-ImageProj.*mask,Nx*Ny,1));
title(sprintf('Run %0.0f\nReconstructed Image: $P_{re}$\n$Avg_{out}$ = %0.2f\n $Std_{out}$ = %0.2f counts',...
    RunNos(1),avg_out_re,std_out_re));

std_out_diff = ImageProj(mask~=0)-atm(mask~=0);
text(0,150,sprintf('$Std[P_{re}-A]_{out}$ = %0.2f',std(std_out_diff(:))),'FontSize',14)


