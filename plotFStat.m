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
    plotFStat_helper(A, B, dailyData, id, daily);
    
    fprintf('%s%i\n', 'Finished plotting pulsar ', id);
    %% Updating the webpage for this pulsar
    pulsarHTML(B.date2str_num(), id);
end