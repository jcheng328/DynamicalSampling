%{
    This script plots selected partial observations. (line plot and colormap) 
%}

function plot_part_observ(observ, opts)
    arguments 
        observ double
        opts struct
    end
    % create folders
    mkdir(sprintf('./%s/%s/%s/%s', opts.dst_fig, opts.egname, opts.expname, opts.testname));
    
    % plot lines 
    figure_configuration_rect_halfpage(opts); fig = figure('visible','off'); 
    Markers = {'x','s','d','^','+','o','*','v','>','<'}; Marker_Counter = 1;
    for k = 1:numel(opts.viewpoints)
        vp = opts.viewpoints(k);
        plot(0:size(observ,2)-1, observ(vp,:), '-', 'marker', Markers{mod(k-1,numel(Markers))+1}, 'markersize', 12); hold on;
    end
    xlim([0 size(observ,2)-1]);
    legend("viewpoint "+string(1:size(observ,1))+" ","Location","best");
    xlabel('time'); ylabel('state');
    
    saveas(fig, sprintf('./%s/%s/%s/%s/%s_observ_plotline_tempsize_%s_viewpoints%s.eps', opts.dst_fig, opts.egname, opts.expname, opts.testname, opts.egname, num2str(opts.temporal_size), num2str(opts.viewpoints)), 'epsc');
    
    % plot colormap
    figure_configuration_rect_halfpage(opts); fig = figure('visible','off'); 
    cmap = parula; cmap(1,:)=[0,0,0]; cdata = observ;
    lowlim = min(cdata(opts.viewpoints,:),[],'all') - (max(cdata(opts.viewpoints,:),[],'all') - min(cdata(opts.viewpoints,:),[],'all')) / (size(cmap,1) - 1)*3;
    cdata = (cdata - lowlim) / (max(cdata(opts.viewpoints,:),[],'all') - lowlim)*255;
    cdata(setdiff([1:size(cdata,1)], opts.viewpoints), :) = 0;
    image(cdata); colormap(fig, cmap); axis off;
    saveas(fig, sprintf('./%s/%s/%s/%s/%s_observ_colormap_viewpoints%s.eps', opts.dst_fig, opts.egname, opts.expname, opts.testname, opts.egname, num2str(opts.viewpoints)), 'epsc');
end