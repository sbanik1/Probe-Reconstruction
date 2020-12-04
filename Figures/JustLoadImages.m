% To analize a file, change run_number, date, date_text
% 02/13: Updated to use while aligning the DMD
set(0,'DefaultFigureWindowStyle','docked')
clear,clc, clf

dateFile = '2019_10_30';
run_start= 451;
run_end  = 451;

OD_lim = 1;

%ROI
r1 = 735;
r2 = r1+119;
c1 = 775;
c2 = c1+119;
%%
dir = cd;
if exist(fullfile(cd,'Processed Images'), 'dir') == 0
    mkdir(fullfile(cd,'Processed Images'));
end

strFile = {'Image_h','Probe_h','Background_h'};

for kk=run_start:run_end
%% Defining File names
    strT = [strrep(dateFile,'_','/') sprintf('  #%d\n',kk)];
    run_number = kk;
    for ii = 1:3
        file_name(ii) = strcat(strFile(ii),'_',dateFile,'_',num2str(run_number,'%4.4d'),'.txt');
    end
    while ( exist(fullfile(cd,char(file_name(1))), 'file') ~=2 || ...
            exist(fullfile(cd,char(file_name(2))), 'file') ~=2 ||...
            exist(fullfile(cd,char(file_name(3))), 'file') ~=2)
    end
    
    clear ii start stop jj params vars_to_extract basepath

%% Extracting info from images
    % Background image
    temp3 =  (char(file_name(3)));
    str3 = temp3(1:length(temp3));
    background(:,:) = double(load(str3));
    % Probe+Atoms image
    temp1 = (char(file_name(1)));
    str1 = temp1(1:length(temp1));
    atoms(:,:) = double(load(str1));
    % Probe image
    temp2 =  (char(file_name(2)));
    str2 = temp2(1:length(temp2));
    probe(:,:) = double(load(str2));
    
    atoms = atoms-background;
    probe = probe-background;
    
    clear temp1 str1 temp2 str2 temp3 str3 file_name background
    
%% Manual intensity correction
    SA  = sum(atoms(1:200,1:200));
    SP  = sum(probe(1:200,1:200));
    clear IntC
    IntC = SA/SP;
    probe = probe*IntC;
    
    atoms = transpose(atoms);
    probe = transpose(probe);
    
    AbsImg = probe-atoms;
    min(min(AbsImg));
    max(max(AbsImg));
    
    figure(1)
    imagesc(AbsImg)
    title([strT 'Absorption'])
    pbaspect([size(AbsImg,2) size(AbsImg,1) 1])
    grid on
    set(gca,'FontSize',12,'GridColor','w')
    
    clear SA SP
%% OD
    M = zeros(size(atoms));
    k = find(probe);
    M(k) = atoms(k)./probe(k);
    clear k
    k = find(M<0);
    M(k) = 0;
      
    OD = -log(M);
    OD_max = max(max(OD));
    OD_min = min(min(OD));
    clear k M
    idx = find(OD==inf);
    OD(idx)=10;
       
    if OD_lim==0
        OD_lim_img = 1.1*OD_max;
    else
        OD_lim_img = OD_lim;
    end
    
    OD2 = OD(r1:r2,c1:c2);
    
    figure(2)
    imagesc(OD2,[0,OD_lim_img])
    title(strT)
    c = colorbar; c.Location = 'south'; c.Color = 'white';
    pbaspect([size(OD2,2) size(OD2,1) 1])
    grid on
    set(gca,'FontSize',12,'GridColor','w')
 
%     cd(fullfile(cd,'Processed Data B'));
%         save_name = sprintf('OD_Run%0.0f_cr',run_number);
%         print(save_name ,'-dpng','-r200');
%     cd(dir)     

%% Animated GIF sequence

%     h = figure(4);
%     gif_name = sprintf('Sequence_%.0f-%.0f.gif',run_start,run_end);
%     n = kk-run_start+1;
% 
%     frame = getframe(h); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
% 
%     % Write to the GIF File 
%     if n == 1 
%       imwrite(imind,cm,gif_name,'gif', 'Loopcount',inf); 
%     else 
%       imwrite(imind,cm,gif_name,'gif','WriteMode','append'); 
%     end 

%%
    clear atoms probe background file_name save_name
    clear var OD strF 
    clear OD2 OD_lim_img
end