%% solve_M
% Get the model matrices M and M0 which describes the linear relationship between
% the portfolio (X_fb, X) and the signals (Y).
%
% Also return the SVD form of M in order to be able to filter out by
% signal significance.

function [M, U, S, V, M0] = solve_model(X_fb, Y)
% Solve X = MY, as well as M = U S V^T.
% We assume that the system is underdetermined, that is, Y is tall.

    % Make sure Y is tall.
    if size(Y,1) < size(Y,2)
        error('Y is not tall, assumption broken.');
    end

    % Make sure X_fb is in matrix form.
    if size(X_fb, 2) ~= size(Y, 2)
        X_fb = reshape(X_fb, [numel(X_fb)/size(Y,2), size(Y,2)]);
    end

    % Trim leading column of zeros out.
    M0 = [X_fb(:,1), zeros(size(X_fb,1), size(X_fb,2)-1)];
    X_fb(:,1) = [];
    Y(:,1) = [];

    % Solve for M using pseudo-inverse (Y^T * M^T = X_fb^T).
    B = inv(Y'*Y);
    M = X_fb * B * Y'; 

    % Find SVD of M in an efficient manner.
    [Qx, Rx] = qr(X_fb, 0);
    [Qy, Ry] = qr(Y, 0);
    Bhat = Rx * B * Ry'; 
    [Ub, S, Vb] = svd(Bhat); % Only requires of a small n x n matrix.
    U = Qx * Ub;
    V = Qy * Vb;
