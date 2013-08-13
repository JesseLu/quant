%% setup_problem
% Compute the percent_return data from the price data and store it in data.mat.
function [] = setup_problem(prices)

    % Double precision needed for sparse matrices later.
    prices = double(prices); 

    % prices_m1 is prices minus one day (yesterday).
	prices_m1= circshift(prices, [0 1]);
	prices_m1(:, 1) = 0;

    percent_return = (prices - prices_m1) ./ prices_m1;
	percent_return(~isfinite(percent_return)) = 0;

    save('data.mat', 'percent_return');
