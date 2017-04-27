% TURNS Hold on
function plot_vlines(startDate, endDate)
    hold on;
    day = startDate;
    i = 0;
    while (day <= endDate)
        if (day.last_of_month() == 1)
            line([i i], ylim, 'LineStyle', '--', 'Color', 'm', ...
                 'LineWidth', 0.85);
        end
        day = day.next_day();
        i = i + 1;
    end
end