%% batch_solve_Xfb
% Solve for a range of portfolios, with different eta estimates, as well as
% different weightings (mu) between the information ratio and the annualized 
% return.

function [X_fb] = batch_solve_Xfb()

    % Range of mu and eta values to generate portfolios over
    mu = [0.0, 0.2, 0.4, 0.7, 1.0];
    eta = [0.18 : 0.02 : 0.28];
    [mu, eta] = ndgrid(mu, eta);

    % Simulate every (mu, eta) value pair.
    for i = 1 : numel(mu)
        fprintf('\n\n=====\n%d/%d\n=====\n\n', i, numel(mu));
        X_fb{i} = solve_Xfb(mu(i), eta(i));
        simulate_portfolio(X_fb{i});
        save('batch_gen_data.mat', 'mu', 'eta', 'X_fb');
    end

