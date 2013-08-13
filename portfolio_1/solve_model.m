% Get the model matrix M which describes the linear relationship between
% the portfolio and the signals.

% Also return the SVD form so that we can just use the strongest signals.

function [M, U, S, V] = solve_model(X, Y)
% Solve X = MY, as well as M = U S V^T.
% We assume that the system is underdetermined, that is, Y is tall.

    % Make sure Y is tall.
    if size(Y,1) < size(Y,2)
        error('Y is not tall, assumption broken.');
    end

    % Solve for M using pseudo-inverse (Y^T * M^T = X^T).
    B = inv(Y'*Y);
    M = X * B * Y'; 

    % Find SVD of M.
    [Qx, Rx] = qr(X, 0);
    [Qy, Ry] = qr(Y, 0);
    Bhat = Rx * B * Ry';
    [Ub, S, Vb] = svd(Bhat);
    U = Qx * Ub;
    V = Qy * Vb;
