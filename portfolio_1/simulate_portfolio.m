%% simulate_portfolio
% Calculate the portfolio performance.

function [ir, ret, tvr] = simulate_portfolio(X)

    % Load percentage returns.
    percent_return = getfield(load('data.mat'), 'percent_return');

    % Portfolio from two days ago is used to calculate profit/loss.
    X_m2 = circshift(X, [0 2]);
    X_m2(:, 1:2) = 0;
    stock_pnl = X_m2 .* percent_return;
    total_pnl = sum(stock_pnl, 1);

    % Calculate information ratio.
    ir = mean(total_pnl) / std(total_pnl);

    % Calculate annualized return.
    booksize = sum(abs(X), 1) / 2;
    ret = mean(total_pnl) / mean(booksize) * 252;

    % Calculate turnover.
    X_m1 = circshift(X, [0 1]);
    X_m1(:, 1) = 0;
    dollars_traded = sum(abs(X - X_m1), 1);
    daily_tvr = dollars_traded / 2 / booksize;
    tvr = mean(daily_tvr);

	fprintf('ir: %1.3f, ret: %1.3f, tvr: %1.3f\n', ir, ret, tvr);
