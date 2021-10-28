%{
    This script plots Hankel matrix from selected partial observations, its 
    singular values of Hankel matrix in the descending order, as well as 
    the quotient of singular values.
%}

function plot_hankel(H, dim, r, opts)
    arguments
        H double
        dim int32
        r int32
        opts struct
    end
    % create folders
    mkdir(sprintf('./%s/%s/%s/%s', opts.dst_fig, opts.egname, opts.expname, opts.testname));
    
    % plot colormap of hankel matrix
    figure_configuration_rect_halfpage(opts); fig = figure('visible','off');
    cmap = parula; cmap(1,:)=[0,0,0]; cdata = H;
    lowlim = min(cdata,[],'all') - (max(cdata,[],'all') - min(cdata,[],'all')) / (size(cmap,1) - 1)*3;
    cdata = (cdata - lowlim) / (max(cdata,[],'all') - lowlim)*255;
    image(cdata); colormap(fig, cmap); axis off;
    saveas(fig, sprintf('./%s/%s/%s/%s/%s_Hankel_viewpoints%s.eps', opts.dst_fig, opts.egname, opts.expname, opts.testname, opts.egname, num2str(opts.viewpoints)), 'epsc');

    % plot singular values of Hankel matrix
    figure_configuration_rect_halfpage(opts); fig = figure('visible','off'); 
    D = sort(svd(H), 'descend');
    plot(1:dim, log(D(1:dim)),'-','linewidth',5,'marker','.','markersize',12*3); xlim([1 dim]);
    xlabel('index $i$', 'Interpreter', 'latex');
    ylabel('$\sigma_i$(log scale)','Interpreter','latex');
    
    saveas(fig, sprintf('./%s/%s/%s/%s/%s_hankel_spec_tempsize_%s_viewpoints%s.eps', opts.dst_fig, opts.egname, opts.expname, opts.testname, opts.egname, num2str(opts.temporal_size), num2str(opts.viewpoints)), 'epsc');
    
    % plot their quotients
    figure_configuration_rect_halfpage(opts); fig = figure('visible','off'); 
    % inplace holder for ploting 
    if dim < 80
        plot(1:dim,log(D(1:dim,:)./D(2:dim+1,:)),'-','linewidth',5,'marker','.','markersize',12*3);
        hold on;
        plot(r,log(D(r,:)./D(r+1,:)),'o','MarkerSize',12*4);
        xlim([1 dim]);
    else
        plot_break_axis(1:dim,log(D(1:dim,:)./D(2:dim+1,:)), 30, dim-15, 5)
        hold on;
        plot(r,log(D(r,:)./D(r+1,:)),'o','MarkerSize',12*4);
    end
    xlabel('index $i$', 'Interpreter', 'latex');
    ylabel('$\sigma_i / \sigma_{i+1} $(log scale)','Interpreter','latex');
    
    saveas(fig, sprintf('./%s/%s/%s/%s/%s_hankel_specquotient_tempsize_%s_viewpoints%s.eps', opts.dst_fig, opts.egname, opts.expname, opts.testname, opts.egname, num2str(opts.temporal_size), num2str(opts.viewpoints)), 'epsc');
    
end