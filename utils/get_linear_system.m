%{
        This script retrieves the existed system and simulate such models.

%}

function [observ, spec, instance_settings] = get_linear_system(egname, instance_settings, verbose)
    arguments
        egname string
        instance_settings struct
        verbose logical=true
    end
    data_mode = egname;
    temporal_size = instance_settings.temporal_size;
    noise = containers.Map;
    noise("activated") = instance_settings.noise_activated;
    noise("stdv") = instance_settings.noise_stdv;
    noise("type") = instance_settings.noise_type;
    
    switch data_mode
        case "Toy_Example_1" % set system A and x_0(f)
            A = [1/3,-1,-2/3; -1/3,1/3,-1/3; 2/3,4/3,5/3];
            f = [-3;1;4];
            observ = simulate(A, f, noise, temporal_size); % spatial-time 2D matrix, represent fully observed linear evolution system 
        case "Discrete_Affine_System"
            % A discrete state-time affine system takes form of x(t+1) =
            % Ax(t) + c. Denote by J=diag(I3+N3, 0.6I2+N2, 0.5, -0.2I2) and
            % U = diag(I3, toeplitz([1,0,0],[1,1,1]), hankel([1,2],[2,1])).
            % The system A is constructed by A=UJU^{-1}. Invoking the
            % change of variables formula, the algorithm turns into y(t+1)
            % = Ay(t) where y(t)=x(t)+(A-I)^{-1}c, or equivalently, z(t+1) 
            % = Az(t) where x(t+1) = (A-I)x(t) + c.
            %load(sprintf("./%s/%s.mat", instance_settings.dst_dataset, egname));
            
            
            %yobserv = simulate(A, y0, noise, temporal_size);  
            %xobserv = yobserv - pinv(A-eye(8))*c;
            
            % However, instead of using xobserv, we can also use yobserv.
            % observ = xobserv;
            observ = yobserv;
            
            % plot part observations
            plot_part_observ(xobserv, instance_settings);
            
            
            
        case "Simple_Directed_Unweighted_Graph" 
            % A simple directed unweighted graph of 20 nodes. Its weight
            % adjacent matrix W is randomly generated with 80 edges and
            % then we removes self loops.  We perform a random walk over 
            % graph which is given by x(t+1) = inv(D)Wx(t). The initial 
            % state x0 is a non-degenerate discrete probability (here we 
            % take Gaussian distribution) on {1,2,...,20}.
            
            load('./dataset/Simple_Directed_Unweighted_Graph.mat');
            observ = simulate(A, f, noise, temporal_size); 
            % plot graph
            plot_graph(G, instance_settings);
            
            
          case "Ring_Graph"
            % An undirected graph with 30 nodes uniformly distributed on a
            % right-shaped structure and each vertex has 8 neighbors. The
            % edge weights are all equal to 1. We perform a random walk
            % over graph which is given by x(t+1) = inv(D)Wx(t). The
            % initial state x0 is a non-degenerate discrete probability
            % (here we take Gaussian distribution) on {1,2,...,20}.
            
            load('./dataset/Ring_Graph.mat'); 
            observ = simulate(A, f, noise, temporal_size); 
            % use gsp toolbox to plot graph 
            plot_graph(G, instance_settings,true);
            
        case "Sphere_Graph"
            % An undirectedgraph with 150 nodes sampled on a hyper-sphere 
            % and each vertex is connected to its 10 nearest neighbors. We 
            % observe the system at t(l)=l∆t for l= 0,· · ·,599 and ∆t= 30.
            % The heat diffusion process over graphs is governed by x(t+1) =
            % expmat(-tL)x(t) + c.
            
            load('./dataset/Sphere_Graph.mat');
            observ = simulate(A, f, noise, temporal_size);
            % use gsp toolbox to plot graph 
            plot_graph(G, instance_settings,true);
        
         case "Human_Walk_Motion"
            % In this example, we consider the captured motion of a walking
            % human. Each human body part is localized and recorded by a 
            % 120Hz sensor during the process.
            load('./dataset/motion_dmd3.mat')
            A=A_naive;
            f=data(:,1);
            observ = data;
%             load human_walk_motion.mat data;
%             observ = data; dim = size(data,1);
%             A = observ(:,2:end) / observ(:,1:end-1);
%             f = observ(:,1);
            % check whether we can approximate human motion with linear system 
            dif = abs(observ(:,2:end) - A*observ(:,1:end-1));
            
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
            data = observ;
            X = data(:,1:end-1);
            Y = data(:,2:end);
            A = Y / X;
            rmse = @(x) sqrt(mean(x.^2,'all'));
            data_tilde = zeros(size(data));
            data_tilde(:,1) = data(:,1);
            for k = 2 : size(data,2)
                data_tilde(:,k) = A*data_tilde(:,k-1);
            end
            observ = data_tilde;
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
    spec = sort_complex(eig(A));
    instance_settings.temporal_size = size(observ, 2);
    instance_settings.spec = spec;
    if ~verbose
        disp("Ground truth of the spectrum from linear evolution system."+newline);
        disp(spec);
    end
end