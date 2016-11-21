% Eilam Morag
% November 19, 2016
% Creates lalapps predict and compute scripts that use all sfts from date A
% to date B

function sfts = cumulativeCalcPoint(A, B, pulsar_list)
    date = A;
    while date <= B
        d = date.day;
        m = date.month;
        y = date.year;
        [filenames_date, data_exists, folder_path] = read_data(d, m, y);
        % Add the sfts for the current date (in filenames_date) to the list
        % of all sfts in the date range so far (in sfts)
        sfts = [sfts filenames_date];
        
        % Increment the date
        date = date.next_day();
    end
    
    % Run the lalapps compute and predict functions on these pulsars
    str = [B.date2str_nospace, '_clative'];
    
    
    
    
end