%% axest
function makepretty_axes(xname,yname)
xlabel(xname,"FontWeight","bold")
ylabel(yname,"FontWeight","bold")
ax = gca;
ax.LineWidth = 2;
ax.FontSize = 14;
box on
ax.TickDir = 'both';
ax.TickLength = [0.007 0.007];
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '--';
ax.GridAlpha = 0.1;
ax.FontName = 'Arial';







