%% plot_results
% Plot and output results for the report.

function plot_results(ret, ir, tvr)

    q = 2.^[7:-1:0];
    for i = 1 : length(q)
        legend_text{i} = sprintf('%d signals', q(i));
    end
    plot(fliplr(ir), fliplr(ret), '.-');
    legend(legend_text);
    xlabel('information ratio');
    ylabel('annualized return');
    title('Pareto-optimal portfolios with varying signal numbers');
