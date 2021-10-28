close all; fig = figure; plot(G,'Layout','circle','NodeLabel',{},'LineWidth', 1, 'LineStyle', '-','ArrowSize',10,'MarkerSize',8); axis off;axis square;
NumberofNodes = 20
hold on
for k = 1:NumberofNodes/2
    theta = 2*pi/NumberofNodes*(k-1)*2;
    text(1.15*cos(theta)-0.07,1.15*sin(theta),num2str(2*k),'Fontsize',20);
end
hold off
opts.width      = 20;
opts.height     = 20;
opts.fontType   = 'Times';
opts.fontSize   = 9;
% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
saveas(gca,sprintf('./figures/%s/%s_graph.eps',char(data_mode),char(data_mode)));