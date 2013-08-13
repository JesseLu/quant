%% batch_find_X
% Obtain a set of nearly Pareto-optimal (non-forward-biased) portfolios
% for various numbers of signals.
% Should be used in conjuction with batch_solve_Xfb.

function [X, f_ir, f_ret, f_tvr] = batch_find_X(mu, X_fb, time_window, tvr0)

    % Generate the non-forward-biased signals.
    % Our model is guaranteed to be only backward-biased since these signals
    % only come from the past.
    Y = generate_Y(time_window); 

    % The range of the numbers of signals to use.
    % Although we can use many signals, we wish to only keep the most
    % significant of them.
    q = 2.^[0:7];

    % Look through the various forward-biased portfolios we have
    % and generate models and corresponding backward-biased 
    % portfolios based on them.
    for i = 1 : length(X_fb)
        % Compute a backward-biased model from each forward-biased portfolio.
        [M, U, S, V, M0] = solve_M(X_fb{i}, Y);

        % Use various reduced-signal versions of the model to 
        % generate backward-biased portfolios.
        for j = 1 : length(q)
            k = 1 : min([q(j), length(diag(S))]); % Chooses signals to use.

            % Obtain and simulate backward-biased portfolio.
            X1 = M0 + U(:,k) * (S(k,k) * (V(:,k)' * Y));
            fprintf('mu: %1.3f, nsig: %d, ', mu(i), q(j));
            [ir(i,j), ret(i,j), tvr(i,j)] = simulate_portfolio(X1);

            % Keep track of additional info.
            nsig(i,j) = q(j);
            m(i,j) = mu(i);
            X_hist{i,j} = X1;
        end
    end

    % Prepare to step through and find best tvr points.
    mu = sort(unique(m(:)));
    ns = sort(unique(nsig(:)));

    % Get our final data by finding the portfolios with appropriate turnover.
    for i = 1 : length(mu)
        for j = 1 : length(ns)
            % Find the data point with appropriate tvr.
            ind = intersect(find(nsig == ns(j)), find(m == mu(i)));
            if min(tvr(ind) <= tvr0)
                [~, t_ind] = max((tvr(ind)<=tvr0) .* tvr0);
            else
                [~, t_ind] = min(tvr(ind));
            end
            f_ind = ind(t_ind);

            % Record final data.
            f_tvr(i,j) = tvr(f_ind);
            f_ret(i,j) = ret(f_ind);
            f_ir(i,j) = ir(f_ind);
            X(i,j) = X_hist(f_ind);
        end
    end

