function [ spec ] = recover( observ, viewpoints, r, method)
    % recover This function recover <r> spectrum from the observations <observ>
    % at <viewpoints> using <method>
    %   observ      -- matrix
    %   viewpoints  -- vector
    %   r           -- int, numerical rank r
    %   method      -- str
        switch method
            case {"Prony_LS","Prony_TLS"}
                % Algorithm and code provided by A. Fernández Rodríguez, 2018.
                % Step 1. Construct and Solve Hankel-like matrix equation.
                colsize = r+1;
                H = construct_hankel(observ, viewpoints, colsize); % H in R(M-r,r+1)
                switch method
                    case "Prony_LS"
                        alpha = [1;flipud(H(1:end,1:end-1)\ -H(1:end,end))];
                    case "Prony_TLS"
                        alpha = [1;tls(fliplr(H(:,1:end-1)), -H(:,end))];
                end
                if sum(isnan(alpha))
                    disp('NaN warning: Coefficient recovered has NaN! \n Please use other exampes.!')
                    alpha(isnan(alpha)) = realmax * sign(alpha(isnan(alpha)));
                end
                if sum(isinf(alpha))
                    disp('Inf warning: Coefficient recovered has NaN! \n Please use other exampes.!')
                    alpha(isinf(alpha)) = realmax * sign(alpha(isinf(alpha)));
                end
                % Find the roots of the polynomial.
                spec = roots(alpha);
            case "Root_MUSIC"
                % Algorithm provided by N. P. Waweru and et.al., 2014
                colsize = r+1;
                H = construct_hankel(observ(:,1:2*r+1), viewpoints, colsize); % H in R(r+1,r+1)
                [U,S,V] = svd(H,0);
                Ubot = U(:,r+1:end);
                B = [];
                for j=1:size(Ubot,2)
                    u = Ubot(:,j);
                    v = flipud(conj(u));
                    B(:,j) = conv(u,v);
                end
                C = sum(B,2);
                spec = roots(C(end:-1:1));
                spec = spec(abs(spec) <= 1);
            case {"ESPRIT_LS", "ESPRIT_TLS", "MEPM"}
                % Algorithm LS and TLS ESPRIT provided by Gerlind Plonka, 2014, Jian Chen 2019, respectively.
                % Step 1. Construct and Solve Matrix Equation.
                d = size(observ,1);
                colsize = d+1;
                H = construct_hankel(observ, viewpoints, colsize); % H in R(2M/3,M/3)
                [U, ~, ~] = svd(H,0);
                switch method
                    case "ESPRIT_LS"
                        J = U(1:end-1,1:r) \ U(2:end,1:r);
                    case "ESPRIT_TLS"
                        J = tls(U(1:end-1,1:r) , U(2:end,1:r));
                end
                % Step 2. Find the Eigenvalues of Matrix.
                spec = eig(J);
            case {"Matrix_Pencil", "Matrix_Pencil_LS", "Matrix_Pencil_TLS", "Matrix_Pencil_SVD_LS", "Matrix_Pencil_SVD_TLS"}
                % Algorithm and code provided by A. Fernández Rodríguez, 2018.
                colsize = size(observ,1) + 1;
                % Step 1. Construct and Solve Hankel-like Matrix Equation.
                H = construct_hankel(observ, viewpoints, colsize); % H in R(M-d, d) with M = 3d
                [~, ~, W] = svd(H);
                Wstar = W';
                switch method
                    case {"Matrix_Pencil", "Matrix_Pencil_LS"}
                        C = H(:, 1:end-1) \ H(:, 2:end);
                    case "Matrix_Pencil_TLS"
                        C = tls(H(:, 1:end-1), H(:, 2:end));
                    case "Matrix_Pencil_SVD_LS" 
                        % Please note that C doesn't equal W(1:end-1, 1:r) \
                        % W(2:end, 1:r)!!!!! If you use this one, you are
                        % actually using ESPRIT method.
                        C = Wstar(1:r, 1:end-1) \ Wstar(1:r, 2:end);
                        
                    case "Matrix_Pencil_SVD_TLS"
                        C = tls(Wstar(1:r, 1:end-1), W(1:r, 2:end));
                end
                % Step 2. Find the eigenvalues of Companion Matrix.
                spec = eig(C);
                % Step 3. Remove redundant zeros.
                [~, idx] = maxk(abs(spec), r);
                spec = spec(idx);
        end
    end
        