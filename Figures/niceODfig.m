function niceODfig(fig,gridOn,clrBar)
% ===================================================================================
% Makes an OD figure look nicer
% niceODfig(fig,gridOn,clrBar)
% fig = figure object
% gridOn = 0,1 -- grid Off/On
% clrBar = 0,1 -- colorbar Off/On
% ===================================================================================
figure(fig)
set(gca,'FontSize',12)
colormap(jet);
% colormap(customcolormap_preset('red-white-blue'));

% Grid properties
if gridOn==1
	grid on
	set(gca,'GridColor','w')
end

% Colorbar properties
if clrBar==1
	c = colorbar; c.Location = 'eastOutside'; 
%     c.Color = [0.9,0.9,0.9]; % white
    c.Color = 'k'; % black
end

% Define figure paper size
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 6]);
set(gcf, 'PaperPosition', [0 0 6 6]);

