function [x] = make_portfolio(mu)

    [c, ~, A, B, C] = sim_matrices();
    N = length(c); % N = m * n;

    cvx_begin
        variable x(N)
        minimize -(c'*x) + mu * std(A*x)
        subject to 
            norm(x) <= 1
            norm(B*x) <= 0.2
    cvx_end
