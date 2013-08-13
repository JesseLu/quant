function test_solve_model(m, n, p)

    X = randn(m, n);
    Y = randn(p, n);

    [M, U, S, V] = solve_model(X, Y);

    res = X - M*Y;
    err = norm(res(:)) / norm(X(:))

    res = M - U*S*V';
    err = norm(res(:)) / norm(M(:))
