%% solve_Xfb
% Compute a nearly optimal forward-biased portfolio.
%
% Increasing input parameter mu allows us to increase the information ratio
% at the expense of the annualized return.
%
% Input parmaeter eta is varied in order to obtain the correct turnover ratio.
% The exact relationship between eta and tvr is unknown, although in practice
% it is nearly linear.
% 
% Requires the cvx package (www.cvxr.com/cvx).

function [X_fb] = solve_Xfb(mu, eta)

    if nargin == 1
        eta = 0.2; % Default value.
    end

    [c, ~, A, B, C, X_dims] = simulation_matrices();
    N = prod(X_dims); % N = m * n;

    cvx_precision low
    cvx_begin
        variable x(N)
        minimize -(c'*x) + mu * std(A*x)
        subject to 
            % Note that we use 2-norm instead of the 1-norm here,
            % this is for stability purposes.
            norm(x, 2) <= 1
            norm(B*x, 2) <= eta 
    cvx_end

    X_fb = reshape(x, X_dims);
