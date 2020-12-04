function scaleBar(OD,barSize,pixSize)

[sy,sx] = size(OD);
x = 1:1:sx;
y = 1:1:sy;
[XX,YY] = meshgrid(x,y);
bx = 0.1*sx;
by = 0.9*sy;
bar = zeros(sy,sx);
bar(XX>bx & XX<(bx+barSize/pixSize))=1;
bar(YY<by) = 0;
if max(sx,sy)>300
    bar(YY>(by+0.01*sy)) = 0;
else
    bar(YY>(by+0.01*sy)) = 0;
end
    
sz = size(OD);
barColor = cat(3, ones(sz), ones(sz), ones(sz)); % grid color RGB
barAlpha = bar;

hold on
hh = imagesc(barColor);
set(hh, 'AlphaData', barAlpha)
hold off

str = sprintf('$%d \\, \\mu m$',barSize);
txt = text(bx*1.1,by*0.95,str,'Color',[0.9,0.9,0.9],'Interpreter','Latex');
if max(sx,sy)>300
    txt.FontSize = 36;
else
    txt.FontSize = 20;
end
