% Generate a portfolio with tvr between 0.19 and 0.2.
function [x] = gen_tuned_x(mu, tvr_err)

    if nargin == 1
        tvr_err = 1e-3;
    end
    tvr0 = 0.2;
    eta = tvr0; % Initial value for eta.

    eta_ival = [0 inf]; % Current range of eta.
    tvr_ival = [nan nan];

    for i = 1 : 10 % Maximum 40 iterations.
        fprintf('mu: %1.1e, eta: %1.3f, iter: %d | ', mu, eta, i);
        x = gen_x(mu, eta);
        [~, ~, tvr] = sim_x(x);

        if tvr <= tvr0 && tvr >= tvr0 - tvr_err % Termination condition.
            break

        elseif tvr > tvr0
            eta_ival(2) = eta;
            tvr_ival(2) = tvr;
            eta = my_interp(eta_ival, tvr_ival, tvr0);

        elseif tvr < tvr0 - tvr_err
            eta_ival(1) = eta;
            tvr_ival(1) = tvr;
            if isfinite(eta_ival(2))
                eta = my_interp(eta_ival, tvr_ival, tvr0);
            else
                eta = 2 * eta;
            end
        
        else
            error('Obtained invalid turnover value.');
        end
    end


function [eta] = my_interp(eta_ival, tvr_ival, tvr0)

    if any(isnan(tvr_ival))
        eta = mean(eta_ival);
    else
        eta = interp1(tvr_ival, eta_ival, tvr0);
    end
