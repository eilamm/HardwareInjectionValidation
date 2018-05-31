% Eilam Morag
% December 2, 2016
% plotFStat_helper: Plots the data and sets appropriate titles and labels.

function plotFStat_helper(A, B, data, id, cumulative)
    num_days = A - B;
    
    %% Plot the values
    figure;
    
    % Prepare the xaxis
    xaxis = 1:1:num_days;
    
    % Plot the computed values
    scatter(xaxis, data(:, 1), 'red');
    hold on;
    
    % Plot the predicted values on the same graph
    scatter(xaxis, data(:, 2), 'blue');
    
    %% Initialize paths for this date's directory
    path =  sprintf('/home/eilam.morag/public_html/HWInjection/Pulsar%02d', id);
    % Make paths to the 'current' subdirectory and to the date's
    % subdirectory
    current = sprintf('%s/current', path);
    path = sprintf('%s/%s', path, B.date2str_num());
    
    % Check if there's a directory for this date. If not, create one.
    if (~exist(path, 'dir'))
        mkdir(path);
    end
    
    %% Saving and formatting the graphs
    if (cumulative == 0)
	filename = sprintf('%s/%s_d.png', path, B.date2str_num());
	current_filename = sprintf('%s/dailyPlot.png', current);
        title({'Daily F-stat Values'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    elseif (cumulative == 1)
	filename = sprintf('%s/%s_c.png', path, B.date2str_num());
	current_filename = sprintf('%s/cumulativePlot.png', current);
        title({'Cumulative F-stat Values'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    end
    legend('Computed', 'Predicted', 'Location', 'eastoutside');     
    ylabel('Fstat');
    xTickDateLabels(A, B, gcf);   
    yTicksDecimalNotation(gcf);
    grid;
    % Separate the months
    
    % Save to the date's directory and to the 'current' directory
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);
end

% function plotFStat_helper(A, B, data, id, cumulative)
%     num_days = A - B;
%     xaxis = 1:1:num_days;
%     
%     figure;
%     
%     % Plot the computed values
%     scatter(xaxis, data(:, 1), 'red');
%     hold on;
%     
%     % Plot the predicted values on the same graph
%     scatter(xaxis, data(:, 2), 'blue');
%     
%     filename = sprintf('%s%i%s%s%s%s%s', '/home/eilam.morag/public_html/HWInjection/Pulsar_', id, '_', A.date2str_nospace(), '_', B.date2str_nospace());
%     if (cumulative == 0)
%         filename = [filename, '_d.png'];
%         title(['Daily Fstat Values between ', A.date2str(), ' and ', B.date2str(), ' for Pulsar ', num2str(id)]);
%     elseif (cumulative == 1)
%         filename = [filename, '_c.png'];
%         title(['Cumulative Fstat Values between ', A.date2str(), ' and ', B.date2str(), ' for Pulsar ', num2str(id)]);
%     end
%     legend('Computed', 'Predicted', 'Location', 'NorthWest');     
%     xlabel(['Days since ', A.date2str()]);
%     ylabel('Fstat');
%     
%     saveas(gcf, filename);
%     close(gcf);
% end
