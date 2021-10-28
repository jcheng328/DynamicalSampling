%{
    This script can provide rmse, histogram, quotient, snr, and plot the
    approximated linear system and its original counter part.
%}

function check_linear_system(data, egname, opts)
    arguments
        data double
        egname string
        opts struct
    end
    X = data(:,1:end-1);
    Y = data(:,2:end);
    A = Y / X;
    rmse = @(x) sqrt(mean(x.^2,'all'));
    data_tilde = zeros(size(data));
    data_tilde(:,1) = data(:,1);
    for k = 2 : size(data,2)
        data_tilde(:,k) = A*data_tilde(:,k-1);
    end
    
    % rmse
    fprintf("rmse of example %s: %f\n", egname, rmse(data_tilde-data));
    
    % relative L2 norm
    
    fprintf("relative rmse of example %s: %f\n", egname, rmse(data_tilde-data)/rmse(data));
    
    % histogram
    figure_configuration_rect_halfpage(opts);
    fig = figure('visible','off'); histogram(data); saveas(fig,sprintf('./%s/%s/%s_orign_data_hist.eps', opts.dst_fig, egname, egname), 'epsc');
    fig = figure('visible','off'); histogram(data_tilde); saveas(fig,sprintf('./%s/%s/%s_simul_data_hist.eps', opts.dst_fig, egname, egname), 'epsc');
    fig = figure('visible','off'); histogram(data-data_tilde); saveas(fig,sprintf('./%s/%s/%s_simul_res_hist.eps', opts.dst_fig, egname, egname), 'epsc');
    
    % quotient
    fprintf("quotient max(abs(residual))/max(abs(simulated data)) of example %s : %f\n", egname, max(abs(data_tilde-data),[],'all')/max(abs(data),[],'all'));
    
%     % snr
%     fprintf("SNR of example %s : %f\n", egname, snr(data_tilde, data_tilde-data));
    
    % plot
    
    
    

end