function [x] = gen_x(mu, eta)

    if nargin == 1
        eta = 0.2; % Default value.
    end

    [c, ~, A, B, C] = sim_matrices();
    N = length(c); % N = m * n;

    cvx_precision low
    cvx_begin
        variable x(N)
        minimize -(c'*x) + mu * std(A*x)
        subject to 
            norm(x, 2) <= 1
            norm(B*x, 2) <= eta 
    cvx_end

