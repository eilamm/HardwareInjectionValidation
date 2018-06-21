% Eilam Morag
% November 19, 2016
% Creates lalapps predict and compute scripts that use all sfts from date A
% to date B

function sfts = cumulativePoint(A, B, pulsar_list, server)
    % Initializations
    date = A;
    sfts = '';
    % Iterate over dates in range from A to B
    while date <= B
        filenames_date = read_data(date, server);
        % Add the sfts for the current date (in filenames_date) to the list
        % of all sfts in the date range so far (in sfts)
        
        sfts = [sfts, filenames_date];
        
        % Increment the date
        date = date.next_day();
    end
    
    % Get rid of last semicolon in the list of sfts
    sfts = sfts(1:end-1);
    
    
    
    
end
