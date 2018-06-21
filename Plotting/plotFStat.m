% Eilam Morag
% November 27, 2016
% plotFStat: Runs from dates A to B. Parses FstatLoudest and FstatValues
% for cumulative and daily for each day in that range of days for the twoF
% and predicted twoF values and plots them. Does this for pulsar 'id'.
function plotFStat(A, B, id)
    %% Initializing variables
    day = A;
    num_days = B - A;
    load('Pulsar-parameters/pulsars.mat', 'pulsar_list');
    pulsar = pulsar_list(id + 1);
    % cumulData will store the cumulative Fstat values. Each row will
    % correspond to a day's entry in the plot, with entry 1 being the first
    % day in the range of days. The first column will be the computed Fstat
    % and the second column will be the predicted Fstat
    cumulData = zeros(num_days, 2);

    h0Data = zeros(num_days, 1);
    cosiotaData = zeros(num_days, 1);
    phi0Data = zeros(num_days, 1);
    psiData = zeros(num_days, 1);
   
    % dailyData will be the same thing but for the daily plot
    dailyData = zeros(num_days, 2);

       % the 'cumulative' and 'daily' variables are really just a 1 and a 0.
       % I'm using them to make it visually easier to understand which call to
       % parseFstatLoudest is for cumulative data and which is for daily.
    cumulative = 1;
    daily = 0;
    %% Iterating through the output files to find the FStat values for each day
    while (day <= B)

           index = day - A;

           % Cumulative
           [twoF, h0, cosiota, phi0, psi] = parseFstatLoudest(id, day, cumulative);
           twoF_p = parseFstatPredicted(id, day, cumulative);

	   h0Data(index) = h0;
	   cosiotaData(index) = cosiota;
           phi0Data(index) = phi0;
	   psiData(index) = psi;

           cumulData(index, 1) = twoF;
           cumulData(index, 2) = twoF_p;
           %%%%%%%%%%%%%%%%%%%%

           % Daily
           [twoF, ~, ~, ~, ~] = parseFstatLoudest(id, day, daily);
           twoF_p = parseFstatPredicted(id, day, daily);

           dailyData(index, 1) = twoF;
           dailyData(index, 2) = twoF_p;
           %%%%%%%%%%%%%%%%%%%%
       
        day = day.next_day();
    end
    printFStatLog(A, B, dailyData, cumulData, id); 
    
    % Filter out the outliers from the daily data
    dailyData = outlierFilter(dailyData, A, id);

    %% Actually plotting the values
    % Create paths to directories where plots will be saved
    path =  sprintf('/home/eilam.morag/public_html/HWInjection/Pulsar%02d', id);
    % Make paths to the 'current' subdirectory and to the date's
    % subdirectory
    current = sprintf('%s/current', path);
    path = sprintf('%s/%s', path, B.date2str_num());

    % Check if there's a directory for this date. If not, create one.
    if (~exist(path, 'dir'))
        mkdir(path);
    end


    %%%%%%%%%%%%%%% Cumulative F-stat %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, cumulData(:, 1), 'red');
    hold on;
    % Plot the predicted values on the same graph
    scatter(1:num_days, cumulData(:, 2), 'blue');
    hold off;

    legend('Computed', 'Predicted', 'Location', 'eastoutside');
    ylabel('Fstat');
    xTickDateLabels(A, B, gcf);
    yTicksDecimalNotation(gcf);
    grid;
    % Give it title and labels
    title({'Cumulative F-stat Values'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    
    
    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_c.png', path, B.date2str_num());
    current_filename = sprintf('%s/cumulativePlot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);

    %%%%%%%%%%%%%%% Daily F-stat      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, dailyData(:, 1), 'red');
    hold on;
    % Plot the predicted values on the same graph
    scatter(1:num_days, dailyData(:, 2), 'blue');
    hold off;

    legend('Computed', 'Predicted', 'Location', 'eastoutside');
    ylabel('Fstat');
    xTickDateLabels(A, B, gcf);
    yTicksDecimalNotation(gcf);
    grid;
    % Give it title and labels
    title({'Daily F-stat Values'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    
    
    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_d.png', path, B.date2str_num());
    current_filename = sprintf('%s/dailyPlot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf); 

    %%%%%%%%%%%%%%% h0                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, h0Data, 'red');

    % Plot expected value over it
    hold on;
    plot(1:num_days, ones(1, num_days)*pulsar.h0, '-b');
    hold off;

    % Set axis limits
    if (pulsar.h0 > max(h0Data))
       ylim([0, 1.1*pulsar.h0]);
    else
       ylim([0, 1.1*max(h0Data)]);
    end

    % Give it title and labels
    xTickDateLabels(A, B, gcf);
    title({'Cumulative h_0'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    legend('Computed', 'Expected', 'Location', 'NorthEastOutside');
    grid;
    
    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_h0.png', path, B.date2str_num());
    current_filename = sprintf('%s/h0Plot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);

    %%%%%%%%%%%%%%% cos(iota)         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, cosiotaData, 'red');

    % Plot expected value over it
    hold on;
    plot(1:num_days, ones(1, num_days)*cos(pulsar.iota), '-b');
    hold off;

    % Set axis limits
    ylim([-1, 1]);

    % Give it title and labels
    xTickDateLabels(A, B, gcf);
    yTicksDecimalNotation(gcf);	% The call to this MUST come after the y-limits are set!
    title({'Cumulative cos(iota)'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    legend('Computed', 'Expected', 'Location', 'NorthEastOutside');
    grid; 

    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_cosiota.png', path, B.date2str_num());
    current_filename = sprintf('%s/cosiotaPlot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);

    %%%%%%%%%%%%%%% phi0              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, phi0Data, 'red');

    % Plot expected value over it
    hold on;
    plot(1:num_days, ones(1, num_days)*pulsar.phi0, '-b');
    plot(1:num_days, ones(1, num_days)*mod(pulsar.phi0 + pi, 2*pi), '--b');
    hold off;

    % Set axis limits
    ylim([0, 2*pi]);

    % Give it title and labels
    xTickDateLabels(A, B, gcf);
    yTicksDecimalNotation(gcf);	% The call to this MUST come after the y-limits are set!
    title({'Cumulative phi_0'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    legend('Computed', 'Expected', 'Location', 'NorthEastOutside');
    grid;   
     
    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_phi0.png', path, B.date2str_num());
    current_filename = sprintf('%s/phi0Plot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);

    %%%%%%%%%%%%%%% psi               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Create the plot
    figHandle = figure();
    
    % Plot the computed values
    scatter(1:num_days, psiData, 'red');

    % Plot expected value over it
    hold on;
    plot(1:num_days, ones(1, num_days)*pulsar.psi, '-b');
    hold off;

    % Set axis limits
    ylim([-pi/4, pi/4]);    
    
    % Give it title and labels
    xTickDateLabels(A, B, gcf);
    yTicksDecimalNotation(gcf);	% The call to this MUST come after the y-limits are set!
    title({'Cumulative psi'; sprintf('%s to %s, Pulsar %d',  A.date2str(), B.date2str(), id)});
    legend('Computed', 'Expected', 'Location', 'NorthEastOutside');
    grid;
    
    % Save to the date's directory and to the 'current' directory
    filename = sprintf('%s/%s_psi.png', path, B.date2str_num());
    current_filename = sprintf('%s/psiPlot.png', current);
    saveas(gcf, filename);
    saveas(gcf, current_filename);
    close(gcf);
   
    fprintf('%s%i\n', 'Finished plotting pulsar ', id);
    %% Updating the webpage for this pulsar
   %  pulsarHTML2(id);
end





function figHandle = plotFStat_helper(A, B, data, id, cumulative)
    num_days = A - B;

    %% Plot the values
    figHandle = figure;

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








































%% Outlier filter: This function represses and logs FStat outliers
% Takes in an n-row x 2-col data matrix, where the first column is computed
% FStat and the second col is predicted FStat. FStat values are considered
% outliers if they are > EXPECTEDMAX, which will be set to 500 (to be
% conservative, as daily twoF values usually hover between 5 to 70). Outliers
% are overwritten as NaN and recorded in outlierLog.txt
function filteredData = outlierFilter(data, startDay, id)
    EXPECTEDMAX = 500;
    outlierVector = data > EXPECTEDMAX;
    filteredData = data;
    filteredData(outlierVector == 1) = NaN;
    
    indicesOutliers = find(outlierVector);
    secondCol = indicesOutliers > length(outlierVector);
    indicesOutliers(secondCol) = indicesOutliers(secondCol) - length(outlierVector);
    indicesOutliers = unique(indicesOutliers);
    % Initialize a Date array of correct size
    n = length(indicesOutliers);
    
    
    days_outliers = cell(n, 1);
    % The - 1 is because the first day should be startDay
    for ii = 1:1:n
        index = indicesOutliers(ii);
        days_str = date2str(startDay.add_days(index - 1));
        outlier_str = sprintf(':\t%s%.2f\t%s%.2f\n', 'Computed: ', data(index, 1), 'Predicted: ', data(index, 2));
        days_outliers{ii} = [days_str outlier_str];
    end
    
    filename = sprintf('%s%d%s', 'outlierLog_', id, '.txt');
    fileID = fopen(filename, 'wt');
    fprintf(fileID, '%s', transpose(char(days_outliers)));
    fclose(fileID);
end
