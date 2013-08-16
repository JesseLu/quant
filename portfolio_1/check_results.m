%% check_results
% Demonstration in an attempt to validate claims of no forward-biasing.

function check_results(prices, simulate_fun)

    % Obtain the daily percent returns.
    yesterday_prices = circshift(prices, [0 1]);
    yesterday_prices(:,1) = 0;
    percent_return = (prices - yesterday_prices) ./ yesterday_prices;
    percent_return(~isfinite(percent_return)) = 0;

    % Get the demonstration models.
    M = getfield(load('demo_models.mat'), 'M_demo');
    fprintf('Demonstrating %d portfolios...\n\n', numel(M));

    for i = 1 : numel(M)
        fprintf('Portfolio %d/%d\n=============\n', i, numel(M));

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

        portfolio = zeros(size(prices)); % Empty intial portfolio.

        for j = 1 : size(percent_return, 2)
            % Get past 5 days of percent returns, filling in zeros if needed.
            five_day_hist = percent_return(:,j:-1:max([1, j-4])); 
            five_day_hist = [five_day_hist, ...
                        zeros(size(five_day_hist,1), 5-size(five_day_hist,2))];

            % For each day, create its portfolio based on the model, which is
            % constant for each day, and the 5-day history.
            portfolio(:,j) = U * S * (V' * five_day_hist(:)); 
        end

        portfolio(:,1) = M0(:,1); % Set initial portfolio on day 1.

        simulate_fun(prices, portfolio);
        fprintf('\n');

        % Do some plotting to get a feel for what the portfolio is doing.
        figure(i);

        subplot 211; imagesc(portfolio, [-.002 .002]); 
        title(sprintf('Portfolio #%d positions', i));

        subplot 413; plot(sum(percent_return .* portfolio, 1));
        axis([1 252 -0.05 0.05]);
        hold on
        plot([1 252], [0 0], 'k--');
        hold off
        ylabel('Daily profit/loss');

        subplot 414; 
        yesterday_portfolio = circshift(portfolio, [0 1]);
        yesterday_portfolio(:,1) = 0;
        plot(sum(abs(portfolio-yesterday_portfolio),1) ./ ...
                                    sum(abs(portfolio),1));
        axis([1 252 0 0.5]);
        hold on
        plot([1 252], [0.2 0.2], 'k--');
        hold off
        ylabel('Daily turnover');

        drawnow;

    end


