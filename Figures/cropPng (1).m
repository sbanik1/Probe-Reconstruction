% Load PNG and crop
clc
imgName = 'dir_';

run_i = 1;
run_f = 3;

% Size of central roi
del = 100
% This numbers work with 768x1024 masks
ri = 768/2-del;
rf = 768/2+del-1;
ci = 1024/2-del;
cf = 1024/2+del-1;

for ii=run_i:run_f
    run = ii;
    clear M1 M2 file
    file = [imgName,sprintf('%d',run),'.png'];
    M1 = imread(file);
    M2 = M1(ri:rf,ci:cf);
    figure(1)
    imshow(M1)
    figure(2)
    imshow(M2)
    saveName = [imgName,sprintf('%d_crop.png',run)];
    imwrite(M2,saveName);
end
    
    
    