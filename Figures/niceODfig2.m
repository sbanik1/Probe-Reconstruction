function niceODfig2(fig,OD,gridOn,clrBar,savImg)
% ===================================================================================
% Displays an OD figure that looks nice
% niceODfig2(fig,OD,gridOn,clrBar,savImg)
% fig = figure object
% OD = OD image to display
% gridOn = 0,1 -- grid Off/On
% clrBar = 0,1 -- colorbar Off/On
% savImg = 0,1 -- save image Off/On
% ===================================================================================
figure(fig)
set(gca,'FontSize',12)
set(gca,'TickLabelInterpreter','latex');
colormap(jet);
fig.Pointer = 'cross';

% Display OD
imagesc(OD,[-0.2,2]);
pbaspect([size(OD,2) size(OD,1) 1])
set(gca, 'FontSize',12)


% Grid properties
if gridOn==1
	grid on
	set(gca,'GridColor','w')
elseif gridOn==0
    axis off
end

% Colorbar properties
if clrBar==1
	c = colorbar; 
%     c.Location = 'east'; c.Color = [0.9,0.9,0.9]; % white
    c.Location = 'eastOutside'; c.Color = 'k'; % black
end

% Define figure paper size
% set(gcf, 'PaperUnits', 'inches');
% set(gcf, 'PaperSize', [6 6]);
% set(gcf, 'PaperPosition', [0 0 6 6]);

% Save image
if savImg == 1
    strTmp = fig.FileName;
    if isempty(strTmp)==1
        warning('[niceODfig] Image not saved, figure file name not specified.')
    else
        print(strTmp,'-dpng','-r200')
    end
end

clear fig