% Simulate the portfolio.

function [ir, ret, tvr] = simulate(p)

    % Load percentage returns.
    percent_return = getfield(load('percent_return.mat'), 'percent_return');

    % Portfolio from two days ago is used to calculate profit/loss.
    p_m2 = circshift(p, [0 2]);
    p_m2(:, 1:2) = 0;
    stock_pnl = p_m2 .* percent_return;
    total_pnl = sum(stock_pnl, 1);

    % Calculate information ratio.
    ir = mean(total_pnl) / std(total_pnl);

    % Calculate annualized return.
    booksize = sum(abs(p), 1) / 2;
    ret = mean(total_pnl) / mean(booksize) * 252;

    % Calculate turnover.
    p_m1 = circshift(p, [0 1]);
    p_m1(:, 1) = 0;
    dollars_traded = sum(abs(p - p_m1), 1);
    daily_tvr = dollars_traded / 2 / booksize;
    tvr = mean(daily_tvr);

	fprintf('ir: %f, ret: %f, tvr: %f\n', ir, ret, tvr);
