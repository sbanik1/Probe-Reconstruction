function niceErrorBar(x,yavg,ystd)

color = zeros(9,3);
color(1,:)=[0.004,0.475,0.867];
color(2,:)=[0.914,0.000,0.098];
color(3,:)=[0.000,0.600,0.298];
color(4,:)=[0.914,0.761,0.000];
color(5,:)=[0.443,0.000,0.784];
color(6,:)=[0.831,0.000,0.671];
color(7,:)=[1.000,0.498,0.314];
color(8,:)=[0.467,0.533,0.600];
color(9,:)=[0.902,0.949,1.000];

eb = errorbar(x,yavg,ystd);
grid on

eb.Marker = 'o';
eb.MarkerSize = 8;
eb.MarkerEdgeColor = color(2,:);
eb.MarkerFaceColor = color(2,:);
eb.Color = color(1,:);
eb.LineStyle = 'none';
% eb.CapSize = 10;
% eb.LineWidth = 1;
end