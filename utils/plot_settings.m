function plot_settings(fig)
%     opts.Colors     = get(groot,'defaultAxesColorOrder');
    opts.saveFolder = 'img/';
    opts.width      = 8*1.4;
    opts.height     = 6;
    opts.fontType   = 'Times';
    opts.fontSize   = 9;
    % scaling
    fig.Units               = 'centimeters';
    fig.Position(3)         = opts.width;
    fig.Position(4)         = opts.height;

    % set text properties
    set(fig.Children, ...`
        'FontName',     'Times', ...
        'FontSize',     12);

    % remove unnecessary white space
    set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
end