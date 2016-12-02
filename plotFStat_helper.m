% Eilam Morag
% December 2, 2016
% plotFStat_helper: Plots the data and sets appropriate titles and labels.

function plotFStat_helper(A, B, data, id, cumulative)
    num_days = A - B;
    xaxis = 1:1:num_days;
    
    figure;
    
    % Plot the computed values
    scatter(xaxis, data(:, 1), 'red');
    hold on;
    
    % Plot the predicted values on the same graph
    scatter(xaxis, data(:, 2), 'blue');
    
    legend('Computed', 'Predicted');
    title(['Daily Fstat Values between ', A.date2str(), ' and ', B.date2str(), ' for Pulsar ', num2str(id)]);
    xlabel(['Days since ', A.date2str()]);
    ylabel('Fstat');
    
    filename = sprintf('%s%i%s%s%s%s%s', '/home/eilam.morag/public_html/HWInjection/Pulsar_', id, '_', A.date2str_nospace(), '_', B.date2str_nospace());
    if (cumulative == 0)
        filename = [filename, '_d.png'];
    elseif (cumulative == 1)
        filename = [filename, '_c.png'];
    end
    saveas(gcf, filename);
    
    close(gcf);
end