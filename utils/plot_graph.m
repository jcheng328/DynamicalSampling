

function [] = plot_graph(G, opts, use_gsp)
    arguments 
        G 
        opts struct
        use_gsp logical=false
    end
    fig = figure('visible', 'off'); figure_configuration_rect_halfpage(opts);
    if use_gsp
        gsp_plot_graph(G,struct('show_edges',1));
    else
        plot(G,'Layout','circle'); 
    end
    axis off; axis square;
    saveas(fig,sprintf('./%s/%s/%s_plotgraph.eps', opts.dst_fig, opts.egname, opts.egname), 'epsc');
        
end