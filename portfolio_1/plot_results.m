%% plot_results
% Plot and output results for the report.

function [table_text] = plot_results(ret, ir, tvr)

    % Plot results.
    q = 2.^[7:-1:0];
    for i = 1 : length(q)
        legend_text{i} = sprintf('%d signals', q(i));
    end
    plot(fliplr(ir), fliplr(ret), '.-');
    legend(legend_text);
    xlabel('information ratio');
    ylabel('annualized return');
    title('Pareto-optimal portfolios with varying signal numbers');

    % Output tables (in latex format).
    q = 2.^[0:7];
    data = {ret, ir, tvr};
    for i = 1 : length(data)
        tt{i} = sprintf('\\begin{tabular}{l c c c c c c c c}\n$n_\\text{signals}$ ');
        for j = 1 : length(q)
            tt{i} = [tt{i}, sprintf('& %d ', q(j))];
        end
        tt{i} = [tt{i}, sprintf(' \\\\\n')];

        for j = 1 : size(data{i}, 1)
            for k = 1 : size(data{i}, 2)
                tt{i} = [tt{i}, sprintf('& %1.3f ', data{i}(j,k))];
            end
            if j == size(data{i}, 1)
                tt{i} = [tt{i}, sprintf('\n\\end{tabular}')];
            else
                tt{i} = [tt{i}, sprintf(' \\\\\n')];
            end
        end
    end
    table_text = tt;
