% Returns the matrices relevant to the portfolio simulation.
function [c, a, A, B, C] = sim_matrices()

    % Load percentage returns.
    percent_return = double(getfield(load('percent_return.mat'), 'percent_return'));
    [m, n] = size(percent_return); % m stocks over n days.
    pret = percent_return(:);

    % Form vector and matrix used to calculate the daily profit/loss.
    c = [pret(2*m+1:end); zeros(2*m, 1)] ./ n;
    i = repmat(1:n-2, [m 1]);
    A = sparse(i(:), 1:m*(n-2), pret(2*m+1:end), n, m*n);
    a = 504 * n;

    % Matrix to find dollars traded.
    B = sparse([1:m*n, 1:m*(n-1)], [1:m*n, m+1:m*n], ...
                [ones(1, m*n), -ones(1, m*(n-1))], m*n, m*n);

    % Matrix that sums up across days.
    i = repmat(1:n, [m 1]);
    C = sparse(i(:), 1:m*n, ones(m*n, 1), n, m*n);
