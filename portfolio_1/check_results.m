%% check_results
% Demonstration in an attempt to validate claims of no forward-biasing.

function check_results(prices)

    % Obtain the daily percent returns.
    yesterday_prices = circshift(prices, [0 1]);
    yesterday_prices(:,1) = 0;
    percent_return = (prices - yesterday_prices) ./ yesterday_prices;
    percent_return(~isfinite(percent_return)) = 0;

    % Get the demonstration models.
    M = getfield(load('demo_models.mat'), M_demo);
    fprintf('Demonstrating %d portfolios...\n\n', numel(M));

    for i = 1 : numel(M)
        fprintf('Portfolio %d/%d\n===\n', i, numel(M));

        % Get the modeling matrix.
        U = M{i}{1};
        S = M{i}{2};
        V = M{i}{3};
        M0 = M{i}{4};

        fprintf('Number of signals (rank of model matrix M): %d\n', size(V, 2));

        % Create a portfolio from the model, based on a 5-day past window of 
        % percent returns.
        % 
        % Note that although the portfolio for day j is based on percent 
        % returns from day j to day j-4, when the portfolio is simulated,
        % the day j portfolio is enacted on day j+2 (that is to say, the
        % profit and loss is calculated by multiplying the day j portfolio
        % with the day j+2 percent returns, see the original 
        % simulate_portfolio). 
        %
        % This is then a strong guarantee of there being only backward bias.

        for j = 1 : size(percent_return, 2)
            % Get past 5 days of percent returns, filling in zeros if needed.
            five_day_hist = percent_return(:,j:-1:max([1, j-4])); 
            five_day_hist = [five_day_hist, ...
                        zeros(size(five_day_hist,1), 5-size(five_day_hist,2))];
        end
    end


