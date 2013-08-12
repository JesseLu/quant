% Simulate portfolio in a "mathy" way.

function [f_ir, f_ret, f_tvr] = sim_x(x)
% x should be a mn x 1 vector of real values representing the portfolio.

    x = double(x);
    [A, B, C] = sim_matrices();

    f_ir = mean(A*x) / std(A*x); % Information ratio.
    f_ret = 504 * sum(A*x) / sum(abs(x)); % Annualized return.
    f_tvr = mean(C*abs(B*x) ./ (C*abs(x))); % Turnover.
    f_t = sum(abs(B*x)) / sum(abs(x));

	fprintf('ir: %f, ret: %f, tvr: %f, t: %f\n', f_ir, f_ret, f_tvr, f_t);
       
