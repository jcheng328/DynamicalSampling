%{
    This script 
%}
function plot_break_axis(x,y,start,stop,width)
    arguments
        x
        y
        start
        stop
        width
    end
    dim = size(x, 1);
    y(x>start & x<stop)=[];
    x(x>start & x<stop)=[];
    
    x(x>=stop)=x(x>=stop)-(stop-start-width);
    
    h = plot(x, y ,'-black','marker','.','MarkerSize',24);
%     hold on;
%     plot(r,log(D(r,:)./D(r+1,:)),'oblack','MarkerSize',12);
    xlim([min(x) max(x)]);
    
    ytick=get(gca,'YTick');
    t1=text(start+width/2-1,ytick(1),'//','fontsize',30);
    xtick=get(gca,'XTick');
    dtick=xtick(2)-xtick(1);
    gap=floor(width/dtick);
    last=max(xtick(xtick<=start));          % last tick mark in LH dataset
    next=min(xtick(xtick>=(last+dtick*(1+gap))));   % first tick mark within RH dataset
    offset=size(x(x>last&x<next),2)*(x(2)-x(1));

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
    
    
end