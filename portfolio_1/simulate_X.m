%% simulate_X
% Alternative way of simulating the portfolio which makes full use of 
% simulation_matrices.

function [f_ir, f_ret, f_tvr] = simulate_X(X)

    x = double(X(:));
    [c, a, A, B, C] = simulation_matrices();

    f_ir = (c'*x) / std(A*x); % Information ratio.
    f_ret = a * (c'*x) / norm(x, 1); % Annualized return.
    f_tvr = mean(C*abs(B*x) ./ (C*abs(x))); % Turnover.
    f_t = norm(B*x, 1) / norm(x, 1); % Approximation for turnover.

	fprintf('ir: %1.3f, ret: %1.3f, tvr: %1.3f, t: %1.3f\n', f_ir, f_ret, f_tvr, f_t);
       
