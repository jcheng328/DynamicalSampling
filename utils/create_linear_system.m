%{
        This script can create linear system if needed, and plot related
        graphs.

%}

function create_linear_system(egname, default_settings, verbose)
    arguments
        egname string
        default_settings struct
        verbose logical=true
    end
    switch egname
        case "Toy_Example" % set system A and x_0(f)
            A = [1/3,-1,-2/3; -1/3,1/3,-1/3; 2/3,4/3,5/3];
            f = [-3;1;4];
            save(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname), 'A', 'f');
            
        case "Discrete_Affine_System"
            % A discrete state-time affine system takes form of x(t+1) =
            % Ax(t) + c. Denote by J=diag(I3+N3, 0.6I2+N2, 0.5, -0.2I2) and
            % U = diag(I3, toeplitz([1,0,0],[1,1,1]), hankel([1,2],[2,1])).
            % The system A is constructed by A=UJU^{-1}. Invoking the
            % change of variables formula, the algorithm turns into y(t+1)
            % = Ay(t) where y(t)=x(t)+(A-I)^{-1}c, or equivalently, z(t+1) 
            % = Az(t) where x(t+1) = (A-I)x(t) + c.
            J = blkdiag(0.3*eye(3)+diag(ones(2,1),-1), 0.5*eye(2)+diag(ones(1,1),-1), 0.6, -0.2*eye(2));
            U = blkdiag(eye(3), toeplitz([1,0,0],[1,1,1]), hankel([1,2],[2,1]));
            A = U*J*inv(U);
            c = ones(8,1);
            x0 = [8:-1:1]';
            y0 = pinv(A-eye(8))*c + x0;
            save(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname), 'A', 'y0', 'c', 'x0');
            
            
        case "Simple_Directed_Unweighted_Graph" 
            % A simple directed unweighted graph of 20 nodes. Its weight
            % adjacent matrix W is randomly generated with 80 edges and
            % then we removes self loops.  We perform a random walk over 
            % graph which is given by x(t+1) = inv(D)Wx(t). The initial 
            % state x0 is a non-degenerate discrete probability (here we 
            % take Gaussian distribution) on {1,2,...,20}.
            
            NumberOfNodes = 20; NumberOfVertices = 80;
            GCOO = randi(NumberOfNodes, NumberOfVertices, 2); % GCOO = Graph in Coordinate Format
            GCOO(diff(GCOO,[],2)==0, :) = []; %remove self-loops
            s = GCOO(:,1); t = GCOO(:,2); % source and target
            G = digraph(s,t); W = full(adjacency(G)); % W = weighted adjacency matrix
            D = diag(sum(W,2)); % D = degree matrix
            A = (pinv(D)*W)'; 
            f =rand(size(A,1),1);
            save(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname), 'G', 'A', 'f');
            
            
          case "Ring_Graph"
            % An undirected graph with 30 nodes uniformly distributed on a
            % right-shaped structure and each vertex has 8 neighbors. The
            % edge weights are all equal to 1. We perform a random walk
            % over graph which is given by x(t+1) = inv(D)Wx(t). The
            % initial state x0 is a non-degenerate discrete probability
            % (here we take Gaussian distribution) on {1,2,...,20}.
            NumberofNodes = 30; NumberofNeighbors = 4; % Neighbors should be 2k for real k.
            G = gsp_ring(NumberofNodes, NumberofNeighbors); W = full(G.A); % W = weighted adjacency matrix
            D = diag(sum(W,2)); % D = degree matrix
            A = (pinv(D)*W)';
            f =rand(size(A,1),1);
            save(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname), 'G', 'A', 'f');
            
            %% Check if the file exists locally.
            folder_path = sprintf('./%s/%s', default_settings.dst_fig, egname);
            fprintf("[%-6s %*c] %-20s\n","Runing",5," ",sprintf("Checking if folder '%s' exists.",folder_path));
            if exist(folder_path,'dir')
                % File exists.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("Folder exists: '%s'.", folder_path));
            else
                % File doesn't exist.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("No such file or directory: '%s'. Now it's created.", folder_path));
                mkdir(folder_path)
            end
            % if resume
            %save('randomwalknew.mat','A','f','G');
            %{
            figure; axis square; gsp_plot_graph(G,struct('show_edges',1));
            hold on
            for k = 1:NumberofNodes/2
                theta = 2*pi/NumberofNodes*(k-1)*2;
                text(0.95*cos(theta)-0.07,0.95*sin(theta),num2str(2*k),'Fontsize',20);
            end
            hold off    
            opts.width      = 6;
            opts.height     = 6;
            opts.fontType   = 'Times';
            opts.fontSize   = 9;
            % scaling
            fig.Units               = 'centimeters';
            fig.Position(3)         = opts.width;
            fig.Position(4)         = opts.height;
            saveas(gca,sprintf('./figures/%s/%s_graph.eps',char(data_mode),char(data_mode)));
            %}
%             load('ring_randomwalk_Jiahui.mat'); 
            
        case "Sphere_Graph"
            % An undirectedgraph with 150 nodes sampled on a hyper-sphere 
            % and each vertex is connected to its 10 nearest neighbors. We 
            % observe the system at t(l)=l∆t for l= 0,· · ·,599 and ∆t= 30.
            % The heat diffusion process over graphs is governed by x(t+1) =
            % expmat(-tL)x(t) + c.
            
            dim = 150; NumberofNodes = dim;
            G = gsp_sphere(NumberofNodes); W = full(G.A); % W = weighted adjacency matrix
            D = diag(sum(W,2)); % D = degree matrix
            L = pinv(sqrt(D))*W*pinv(sqrt(D)); % L = Laplacian matrix
            dt = 20;
            A = expm(-dt*(eye(dim)-L)); % I-L = normalized Laplacian matrix
            f = (A-eye(dim))*(rand(dim,1)+randn(dim,1));
            save(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname), 'G', 'A', 'f');
            fig = figure('visible', 'off');
            bcolor = [0, 0.4470, 0.7410];
            
            
            data_mode = egname;
            temporal_size = default_settings.temporal_size;
            noise = containers.Map;
            noise("activated") = default_settings.noise_activated;
            noise("stdv") = default_settings.noise_stdv;
            noise("type") = default_settings.noise_type;

            for dt = 10:5:25
                load(sprintf("./%s/%s.mat", default_settings.dst_dataset, egname));
                dim = 150; W = full(G.A); % W = weighted adjacency matrix
                D = diag(sum(W,2)); % D = degree matrix
                L = pinv(sqrt(D))*W*pinv(sqrt(D)); % L = Laplacian matrix
                A = expm(-dt*(eye(dim)-L)); % I-L = normalized Laplacian matrix
                f = (A-eye(dim))*(rand(dim,1)+randn(dim,1));
                observ = simulate(A, f, noise, temporal_size);
                spec = sort_complex(eig(A));
                default_settings.temporal_size = size(observ, 2);
                default_settings.spec = spec;
                speclst = Namespace();
                speclst('Ground_Truth') = default_settings.spec;
                viewpoints = [1,2,3,4,5,6,7,8,9];
                dim = size(observ, 1);
                N = size(observ, 2);
                % construct initial hankel matrix
                H = construct_hankel(observ, viewpoints, floor(N/2));

                % determine numerical rank r
                r = get_rank(H, 'spectrum_gap', size(observ,1));
                r = min(r, size(observ,1));
                r = 10;

                default_settings.numerical_rank = r;
                % test each method
                method_lst = default_settings.method_lst;
                for method=method_lst
                    if ~verbose
                        disp("method:   "+char(method)+newline);
                    end
                    spec = recover(observ, viewpoints, r, char(method));
                    spec = sort_complex(spec);
                    if ~verbose
                        disp(spec);
                    end
                    % record results
                    speclst(char(method)) = spec;
                end
                x = speclst('Ground_Truth'); scatter(x,(dt) * ones(size(x)),50,'black','filled'); hold on;
                x = speclst('Matrix_Pencil_SVD_LS'); scatter(x,(dt) * ones(size(x)),100,'red'); hold on;
            end
            xlim([0 1]);
            
            %% Check if the file exists locally.
            folder_path = sprintf('./%s/%s', default_settings.dst_fig, egname);
            file_path = sprintf('%s_various_dt_tempsize_%s_viewpoints%s.eps', egname, num2str(temporal_size), num2str(viewpoints));
            fprintf("[%-6s %*c] %-20s\n","Runing",5," ",sprintf("Saving figure into %s.",fullfile(folder_path, file_path)));
            if exist(folder_path,'dir')
                % File exists.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("Folder exists: '%s'.", folder_path));
            else
                % File doesn't exist.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("No such file or directory: '%s'. Now it's created.", folder_path));
                mkdir(folder_path)
            end
    
            saveas(fig, sprintf('./%s/%s/%s_various_dt_tempsize_%s_viewpoints%s.eps', default_settings.dst_fig, egname, egname, num2str(temporal_size), num2str(viewpoints)), 'epsc');
            
         case "Human_Walk_Motion"
            % In this example, we consider the captured motion of a walking
            % human. Each human body part is localized and recorded by a 
            % 120Hz sensor during the process.
%             load human_walk_motion.mat data;
%             load('./dataset/motion_dmd3.mat')
%             A=A_naive;
%             f=data(:,1);
%             observ = data; 
%             
            % check whether we can approximate LIP model with linear system 
%             check_linear_system(observ, egname, default_settings);
            % check whether we can approximate LIP model with affine system
%             check_linear_system(observ(:,2:end)-observ(:,1:end-1), default_settings);
            
            
        case  "LIP"
            % In this example, we consider a low rank affine dynamical 
            % system,the LIP model of influenza virus inflection model, 
            % dV/dt=rI−cV dH/dt=−βHV dI/dt=βHV−δI(52). We used rescaled 
            % model for convenience, with parameters β=10.8,r= 12,c= 3,δ= 4
            % and initial state V(0) = 0.093/(4×105),H(0) = 1,I(0) = 0.We 
            % use Matlab built-in function ode45, which is an implicit 
            % implementation of fourth-orderRunge-Kutta method, to solve 
            % this affine linear differential equations, subjecting to the 
            % initial conditions. 
            load("LIP_data");
            observ = observ(:, 181:210);
            
            %% Check if the file exists locally.
            folder_path = sprintf('./%s/%s', default_settings.dst_fig, egname);
            fprintf("[%-6s %*c] %-20s\n","Runing",5," ",sprintf("Checking if folder '%s' exists.",folder_path));
            if exist(folder_path,'dir')
                % File exists.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("Folder exists: '%s'.", folder_path));
            else
                % File doesn't exist.
                fprintf("[%*c %-5s] %-20s\n",6," ","OK",sprintf("No such file or directory: '%s'. Now it's created.", folder_path));
                mkdir(folder_path)
            end
    
            % check whether we can approximate LIP model with linear system 
            check_linear_system(observ, egname, default_settings);
            % check whether we can approximate LIP model with affine system
%             check_linear_system(observ(:,2:end)-observ(:,1:end-1), default_settings);
            
        case  "Low_Rank_Affine_Dynamical_System"
            % A low rank affine system takes form of dx/dt = Ax(t) + c with
            % Dirichlet boundary x(0) = b. We simulate the affine system
            % with its explicit solution x(t) = expmat(tA)b + (expmat(tA) -
            % I)d. Invoking the change of variables formula, the algorithm
            % turns into y(t+1) = Ay(t) where y(t) = x(t) + (A-I)^{-1}c.
            J = blkdiag(0.9* eye(3)+diag(ones(2,1),-1), 0.6*eye(2)+diag(ones(1,1),-1), 0.5, -0.2*eye(2));
            U = blkdiag(eye(3), toeplitz([1,0,0],[1,1,1]), hankel([1,2],[2,1]));
            A = expm(U*J*inv(U));
            c = ones(8,1);
            d = inv(A) * c;
            x0 = [1:8]';
            y0 = inv(A-eye(8))*c + x0;
            % spatial-time 2D matrix, represent fully observed linear evolution system
            yobserv = simulate(A, y0, noise, temporal_size);  
            xobserv = yobserv - inv(A-eye(8))*c;
            observ = xobserv;
            observ = yobserv;
            
            fig = figure;
            for k = [1,2,4,7]
                plot(0:size(yobserv,2)-1, yobserv(k,:));
                hold on;
            end
            legend('viewpoint 1','viewpoint 2','viewpoint 4','viewpoint 7','Location','Best');
            xlabel('time');
            ylabel('state');
            plot_settings(fig);dst_fig = 'figures';
            saveas(fig,sprintf('./%s/%s/%s_observations.eps',dst_fig,char(data_mode),char(data_mode)));
            
            
        case "Biparte_Graph"
            % for biparte graph
            % Make a random MxN adjacency matrix
            m = 20;
            n = 20;
            a = rand(m,n)>.90;
            % Expand out to symmetric (M+N)x(M+N) matrix
            big_a = [zeros(m,m), a;
                    a', zeros(n,n)];     
            g = graph(big_a);
            Adj = adjacency(g);
            B = full(Adj);
            D = diag(sum(B,2));
            A = pinv(sqrt(D))*B*pinv(sqrt(D));
            deltat      = 1;
            A           = expm(-deltat*(eye(size(A,1))-A));
            f           = rand(size(A,1),1);
%             save('bipartite40.mat','A','f','g');
            %load('bipartite40.mat');
            % Plot
            h = plot(g);
            % Make it pretty
            h.XData(1:m) = 1;
            h.XData((m+1):end) = 2;
            h.YData(1:m) = linspace(0,1,m);
            h.YData((m+1):end) = linspace(0,1,n);

%             P = pinv(D)*B;
%             A= P';
%             f =rand(size(A,1),1);
%             f = f./sum(sum(f));
%             disp(sprintf('%20s: %30d',"Dimension: ", numel(f)));
            observ = simulate(A, f, noise, temporal_size); % spatial-time 2D matrix, represent fully observed linear evolution system 
            
        case "Erdos_Renyi_Graph"
            G = gsp_sensor(60);
            paramplot.show_edges = 1;
            gsp_plot_graph(G,paramplot);
            Adj = G.A;
            B = full(Adj);
            D = diag(sum(B,2));
            A = pinv(sqrt(D))*B*pinv(sqrt(D));
            deltat      = 3;
            A           = expm(-deltat*(eye(size(A,1))-A));
            f           = rand(size(A,1),1);
            observ = simulate(A, f, noise, temporal_size);
        case "Dolphin"
        case "PSD_Low_Rank_Matrix"
            n = data_info("n");
            r = data_info("r");
            
            A           = randn(n,n);
            [U, S, ~]   = svd(A);
            S           = diag(S);
            S(r:end)    = 0;
            A           = U * diag(S) * U'./max(S);
            f           = randn(n,1);
            observ = simulate(A, f, noise, temporal_size);
            
        case "Random_Simple_d_Regular_Graph"
            rng(2);
            addpath("./randRegGraph/randRegGraph");
            vertNum = data_info("vertNum");
            deg = data_info("deg");
            
            [A,w]       = createRandomRegWeightedGraph(vertNum, deg);
            f           = randn(vertNum,1);
            observ = simulate(A, f, noise, temporal_size);
            
         case "Unitary_Matrix"
            f           = randn(vertNum,1);
            observ = simulate(A, f, noise, temporal_size);
            
    end 
end
