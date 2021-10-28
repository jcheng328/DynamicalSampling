% 0
close all;
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 16;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;
plot([0],[1]);
ax = gca
hold on;
bcolor = [0, 0.4470, 0.7410];
x = speclst10('Ground_Truth');
scatter(x,ones(size(x)),50,'black','filled');
x = speclst10('Matrix_Pencil_SVD_LS');
hold on;
scatter(x,ones(size(x)),100,'red');

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



xlabel('Spectrum', 'Interpreter', 'latex');
ylabel('$\Delta t$ (log scale)','Interpreter','latex');


xlim([0,1])
ylim([1,1.8])
% % -0.5
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstn5('Ground_Truth');
% scatter(x,-0.5*ones(size(x)),50,bcolor);
% x = speclstn5('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,-0.5*ones(size(x)),50,'red','filled');

% % -0.4
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstn4('Ground_Truth');
% scatter(x,-0.4*ones(size(x)),50,bcolor);
% x = speclstn4('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,-0.4*ones(size(x)),50,'red','filled');

% % -0.3
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstn3('Ground_Truth');
% scatter(x,-0.3*ones(size(x)),50,bcolor);
% x = speclstn3('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,-0.3*ones(size(x)),50,'red','filled');
% 
% % -0.2
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstn2('Ground_Truth');
% scatter(x,-0.2*ones(size(x)),50,bcolor);
% x = speclstn2('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,-0.2*ones(size(x)),50,'red','filled');

% % -0.1
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstn1('Ground_Truth');
% scatter(x,-0.1*ones(size(x)),50,bcolor);
% x = speclstn1('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,-0.1*ones(size(x)),50,'red','filled');

% % 0.1
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp1('Ground_Truth');
% scatter(x,0.1*ones(size(x)),50,bcolor);
% x = speclstp1('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.1*ones(size(x)),50,'red','filled');

% % 0.2
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp2('Ground_Truth');
% scatter(x,0.2*ones(size(x)),50,bcolor);
% x = speclstp2('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.2*ones(size(x)),50,'red','filled');

% % 0.3
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp3('Ground_Truth');
% scatter(x,0.3*ones(size(x)),50,bcolor);
% x = speclstp3('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.3*ones(size(x)),50,'red','filled');

% % 0.4
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp4('Ground_Truth');
% scatter(x,0.4*ones(size(x)),50,bcolor);
% x = speclstp4('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.4*ones(size(x)),50,'red','filled');

% % 0.5
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp5('Ground_Truth');
% scatter(x,0.5*ones(size(x)),50,bcolor);
% x = speclstp5('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.5*ones(size(x)),50,'red','filled');

% % 0.6
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp6('Ground_Truth');
% scatter(x,0.6*ones(size(x)),100,bcolor);
% x = speclstp6('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.6*ones(size(x)),50,'red','filled');

% % 0.7
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp7('Ground_Truth');
% scatter(x,0.7*ones(size(x)),50,bcolor);
% x = speclstp7('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.7*ones(size(x)),50,'red','filled');

% % 0.8
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp8('Ground_Truth');
% scatter(x,0.8*ones(size(x)),50,bcolor);
% x = speclstp8('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.8*ones(size(x)),50,'red','filled');

% % 0.9
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp9('Ground_Truth');
% scatter(x,0.9*ones(size(x)),50,bcolor);
% x = speclstp9('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,0.9*ones(size(x)),50,'red','filled');

% % 1.0
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp10('Ground_Truth');
% scatter(x,1.0*ones(size(x)),50,bcolor);
% x = speclstp10('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,1.0*ones(size(x)),50,'red','filled');

% % 1.1
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp11('Ground_Truth');
% scatter(x,1.1*ones(size(x)),50,bcolor);
% x = speclstp11('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,1.1*ones(size(x)),50,'red','filled');

% 1.2
hold on;
bcolor = [0, 0.4470, 0.7410];
x = speclst12('Ground_Truth');
scatter(x,1.2*ones(size(x)),50,'black','filled');
x = speclst12('Matrix_Pencil_SVD_LS');
hold on;
scatter(x,1.2*ones(size(x)),100,'red');

% % 1.3
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp13('Ground_Truth');
% scatter(x,1.3*ones(size(x)),50,bcolor);
% x = speclstp13('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,1.3*ones(size(x)),50,'red','filled');

% 1.4
hold on;
bcolor = [0, 0.4470, 0.7410];
x = speclst14('Ground_Truth');
scatter(x,1.4*ones(size(x)),50,'black','filled');
x = speclst14('Matrix_Pencil_SVD_LS');
hold on;
scatter(x,1.4*ones(size(x)),100,'red');

% % 1.5
% hold on;
% bcolor = [0, 0.4470, 0.7410];
% x = speclstp15('Ground_Truth');
% scatter(x,1.5*ones(size(x)),50,bcolor);
% x = speclstp15('Matrix_Pencil_SVD_LS');
% hold on;
% scatter(x,1.5*ones(size(x)),50,'red','filled');

% 1.6
hold on;
bcolor = [0, 0.4470, 0.7410];
x = speclst16('Ground_Truth');
scatter(x,1.6*ones(size(x)),50,'black','filled');
x = speclst16('Matrix_Pencil_SVD_LS');
hold on;
scatter(x,1.6*ones(size(x)),100,'red');

% 1.8
hold on;
bcolor = [0, 0.4470, 0.7410];
x = speclst18('Ground_Truth');
scatter(x,1.8*ones(size(x)),50,'black','filled');
x = speclst18('Matrix_Pencil_SVD_LS');
hold on;
scatter(x,1.8*ones(size(x)),100,'red');

saveas(fig,'./figures/sphere_graph_with_various_t.eps');