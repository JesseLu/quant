% Simulate portfolio in a "mathy" way.

function [f_ir, f_ret, f_tvr] = sim_x(x)
% x should be a mn x 1 vector of real values representing the portfolio.

    x = double(x);
    [c, a, A, B, C] = sim_matrices();

    f_ir = (c'*x) / std(A*x); % Information ratio.
    f_ret = a * (c'*x) / norm(x, 1); % Annualized return.
    f_tvr = mean(C*abs(B*x) ./ (C*abs(x))); % Turnover.
    f_t = norm(B*x, 1) / norm(x, 1);

	fprintf('ir: %f, ret: %f, tvr: %f, t: %f\n', f_ir, f_ret, f_tvr, f_t);
       
