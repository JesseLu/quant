%% generate_Y
% Generates the backward-looking signals that will be used to predict
% optimal backward-biased portfolios (X).
%
% The use of past data only guarantees that the portfolios generated from 
% these signals via the model matrix M (X = MY), will not be forward-biased.
%

function [Y] = generate_Y(h_size)

    % The signals consist of a history of percent return data.
    R = double(getfield(load('data.mat'), 'percent_return'));
    [m, n] = size(R); % m stocks over n days.

    p = m * h_size;
    Y = zeros(p, n);

    % Build the signals matrix.
    % Y corresponds to X in the sense that the signals for the ith day 
    % are found in the ith column of Y and consist of the percent return 
    % for that day and h_size days preceding.
    %
    % This is a strong guarantee of non-forward-biasing since in portfolio
    % simulation, the enactment of a portfolio is delayed by an additional 
    % 2 days.
    for i = 1 : n
        ind = i : -1 : max([1, i-h_size+1]);
        yi = (R(:,ind));
        Y(:,i) = [yi(:); zeros(p-numel(yi),1)];
    end
    

    
