% Eilam Morag
% November 27, 2016
% plotFStat: Runs from dates A to B. Parses FstatLoudest and FstatValues
% for cumulative and daily for each day in that range of days for the twoF
% and predicted twoF values and plots them. Does this for pulsar 'id'.
function plotFStat(A, B, id)
   day = A;
   num_days = B - A;
   
   % cumulData will store the cumulative Fstat values. Each row will
   % correspond to a day's entry in the plot, with entry 1 being the first
   % day in the range of days. The first column will be the computed Fstat
   % and the second column will be the predicted Fstat
   cumulData = zeros(num_days, 2);
   
   % dailyData will be the same thing but for the daily plot
   dailyData = zeros(num_days, 2);
   
   % the 'cumulative' and 'daily' variables are really just a 1 and a 0.
   % I'm using them to make it visually easier to understand which call to
   % parseFstatLoudest is for cumulative data and which is for daily.
   cumulative = 1;
   daily = 0;
   while (day <= B)
       
       index = day - A;
       
       % Cumulative
       twoF = parseFstatLoudest(id, day, cumulative);
       twoF_p = parseFstatPredicted(id, day, cumulative);
       
       cumulData(index, 1) = twoF;
       cumulData(index, 2) = twoF_p;
       %%%%%%%%%%%%%%%%%%%%
       
       % Daily
       twoF = parseFstatLoudest(id, day, daily);
       twoF_p = parseFstatPredicted(id, day, daily);
       
       dailyData(index, 1) = twoF;
       dailyData(index, 2) = twoF_p;
       %%%%%%%%%%%%%%%%%%%%
       
       day = day.next_day();
   end
   
   % This will serve as the xaxis values, to clean up the code.
   xaxis = 1:1:num_days;
   
   % Plot cumulative data %%%%%%%%%%%%%%%%%%%%%%%
   figure;
   % Plot the computed values
   plot(xaxis, cumulData(index, 1), '-o', xaxis, cumulData(index, 2), '-x');
%    hold on;
   % Plot the predicted values on the same graph
%    plot(xaxis, cumulData(index, 2), '-x');
   legend('Computed', 'Predicted');
   title(['Cumulative Fstat Values between ', A.date2str(), ' and ', B.date2str(), ' for Pulsar ', num2str(id)]);
   xlabel(['Days since ', A.date2str()]);
   ylabel('Fstat');
   filename = sprintf('%s%i%s%s%s%s%s', '/home/eilam.morag/public_html/HWInjection/Pulsar_', id, '_', A.date2str_nospace(), '_', B.date2str_nospace(), '_c.png');
   saveas(gcf, filename);
   close(gcf);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Plot daily data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   figure;
   % Plot the computed values
   plot(xaxis, dailyData(index, 1), '-o', xaxis, dailyData(index, 2), '-x');
%    hold on;
   % Plot the predicted values on the same graph
%    plot(xaxis, dailyData(index, 2), '-x');
   legend('Computed', 'Predicted');
   title(['Daily Fstat Values between ', A.date2str(), ' and ', B.date2str(), ' for Pulsar ', num2str(id)]);
   xlabel(['Days since ', A.date2str()]);
   ylabel('Fstat');
   filename = sprintf('%s%i%s%s%s%s%s', '/home/eilam.morag/public_html/HWInjection/Pulsar_', id, '_', A.date2str_nospace(), '_', B.date2str_nospace(), '_d.png');
   saveas(gcf, filename);
   close(gcf);
end