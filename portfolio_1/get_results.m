function [f_x, f_ir, f_ret, f_tvr] = get_results(mu, x, time_window, tvr0)

    Y = get_signals(time_window);
    q = 2.^[0:7]; % Number of signals to use in the model.

    for i = 1 : length(x)
        [M, U, S, V, M0] = solve_model(x{i}, Y);
        for j = 1 : length(q)
            k = 1 : min([q(j), length(diag(S))]);
            X = M0 + U(:,k) * (S(k,k) * (V(:,k)' * Y));
            [ir(i,j), ret(i,j), tvr(i,j)] = simulate(X);
            nsig(i,j) = q(j);
            m(i,j) = mu(i);
            x_hist{i,j} = X;
        end
    end

    % Prepare to step through and find best tvr points.
    mu = sort(unique(m(:)));
    ns = sort(unique(nsig(:)));

    % Get our final data.
    for i = 1 : length(mu)
        for j = 1 : length(ns)
            ind = intersect(find(nsig == ns(j)), find(m == mu(i)));
            if min(tvr(ind) <= tvr0)
                [~, t_ind] = max((tvr(ind)<=tvr0) .* tvr0);
            else
                [~, t_ind] = min(tvr(ind));
            end
            f_ind = ind(t_ind);
            f_tvr(i,j) = tvr(f_ind);
            f_ret(i,j) = ret(f_ind);
            f_ir(i,j) = ir(f_ind);
            f_x(i,j) = x_hist(f_ind);
        end
    end

