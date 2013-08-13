function [x] = batch_gen_x()

    mu = [0.0, 0.2, 0.4, 0.7, 1.0];
    eta = [0.18 : 0.02 : 0.28];

    [mu, eta] = ndgrid(mu, eta);


    for i = 1 : numel(mu)
        fprintf('\n\n=====\n%d/%d\n=====\n\n', i, numel(mu));
        x{i} = gen_x(mu(i), eta(i));
        sim_x(x{i});
        save('batch_gen_data.mat', 'mu', 'eta', 'x');
    end

