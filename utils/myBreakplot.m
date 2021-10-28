close all
fig = figure;
x = 1:size(observ,1);
y = log(D(1:size(observ,1),:)./D(2:size(observ,1)+1,:));
start = 15;
stop = 135;
width = 5;
y(x>start & x<stop)=[];
x(x>start & x<stop)=[];
x2=x;
x2(x2>=stop)=x2(x2>=stop)-(stop-start-width);
h = plot(x2, y ,'-black','linewidth',1,'marker','.','markersize',12);
hold on;
plot(r,log(D(r,:)./D(r+1,:)),'oblack',...
'MarkerSize',12);
xlim([1 35])

fig.Units               = 'centimeters';
fig.Position(3)         = opts.width*1.4;
fig.Position(4)         = opts.height;
% 
% set text properties
% set(fig.Children, ...
%     'FontName',     'Times', ...
%     'FontSize',     12);
% 
% set(fig,'LooseInset',max(get(fig,'TightInset'), 0.02))
% 
xlabel('index $i$', 'Interpreter', 'latex');
ylabel('$\sigma_i / \sigma_{i+1} $(log scale)','Interpreter','latex');

ytick=get(gca,'YTick');
t1=text(start+width/2-1,ytick(1),'//','fontsize',15);
xtick=get(gca,'XTick');
dtick=xtick(2)-xtick(1);
gap=floor(width/dtick);
last=max(xtick(xtick<=start));          % last tick mark in LH dataset
next=min(xtick(xtick>=(last+dtick*(1+gap))));   % first tick mark within RH dataset
offset=size(x2(x2>last&x2<next),2)*(x(2)-x(1));

for i=1:sum(xtick>(last+gap))
    xtick(find(xtick==last)+i+gap)=stop+offset+dtick*(i-1);
end
    
for i=1:length(xtick)
    if xtick(i)>last&xtick(i)<next
        xticklabel{i}=sprintf('%d',[]);
    else
        xticklabel{i}=sprintf('%d',xtick(i));
    end
end
set(gca,'xticklabel',xticklabel);
saveas(fig,sprintf('./%s/%s/%s_hankel_specgap.eps',dst_fig,char(data_mode),char(data_mode)));