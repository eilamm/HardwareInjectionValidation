% Eilam Morag
% November 27, 2016
% plotFStat: Runs from dates A to B. Parses FstatLoudest and FstatValues
% for cumulative and daily for each day in that range of days for the twoF
% and predicted twoF values and plots them. Does this for pulsar 'id'.
function plotFStat(A, B, id)
    %% Initializing variables
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
    %% Iterating through the output files to find the FStat values for each day
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
   
    %% Actually plotting the values
    plotFStat_helper(A, B, cumulData, id, cumulative);
    % Filter out the outliers from the daily data
    dailyData = outlierFilter(dailyData, A);
    plotFStat_helper(A, B, dailyData, id, daily);
    
    fprintf('%s%i\n', 'Finished plotting pulsar ', id);
    %% Updating the webpage for this pulsar
    pulsarHTML(B.date2str_num(), id);
end

%% Outlier filter: This function represses and logs FStat outliers
% Takes in twoF, which can be predicted or cumulative. If the value is
% above the EXPECTEDMAX value, which will be set to 500 (to be
% conservative, as daily twoF values usually hover between 5 to 70), then
% it returns NaN and outputs to a .txt file that it encountered an outlier
% on day X of value twoF
function filteredData = outlierFilter(data, startDay)
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
    
    
    days_outliers(n, 1) = string; 
    % The - 1 is because the first day should be startDay
    for ii = 1:1:n
        index = indicesOutliers(ii);
        days_str = date2str(startDay.add_days(index - 1));
        outlier_str = sprintf(':\t%s%.2f\t%s%.2f\n', 'Computed: ', data(index, 1), 'Predicted: ', data(index, 2));
        days_outliers(ii) = [days_str outlier_str];
    end
    
    fileID = fopen('outlierLog.txt', 'wt');
    fprintf(fileID, '%s', days_outliers);
    fclose(fileID);
end