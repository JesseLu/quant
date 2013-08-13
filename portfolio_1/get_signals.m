% Get the non-forward-looking signals that will be used to predict optimal x.
% We make sure we don't look forward by limiting signals for the portfolio
% to the day-of percent return.

function [Y] = get_signals(h_size, num_ord)

    R = double(getfield(load('data.mat'), 'percent_return'));
    [m, n] = size(R); % m stocks over n days.

    p = m * h_size * num_ord;
    Y = zeros(p, n);
    ylen = m * h_size;

    for i = 1 : n
        ind = i : -1 : max([1, i-h_size+1]);
        yi = (R(:,ind));
        yi = [yi(:); zeros(ylen-numel(yi),1)];
        for j = 1 : num_ord
            Y((j-1)*ylen+1:j*ylen, i) = yi.^j;
        end
    end
    

    
