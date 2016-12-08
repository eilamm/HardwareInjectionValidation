% Eilam Morag
% November 28, 2016
% parseFstatPredicted: Parses the FstatPredicted file for a given day and 
% for daily or cumulative versions (c == 0 means daily, c == 1 means
% cumulative) and for a given pulsar
% FstatPredicted_9_Jan-17-2016_cumulative.txt

function twoF = parseFstatPredicted(id, date, c)
    basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/';
    if (c == 0)
        file = sprintf('%s%s%i%s%s%s', basepath, 'output/FstatPredicted_', id, '_', ...
            date2str_nospace(date), '_daily.txt');
    elseif (c == 1)
        file = sprintf('%s%s%i%s%s%s', basepath, 'output/FstatPredicted_', id, '_', ...
            date2str_nospace(date), '_cumulative.txt');
    end
    
%     path = sprintf('%s%s', basepath, file);
    fileID = fopen(file);
    % If the file does not exist
    if (fileID == -1)
        twoF = NaN;
        fprintf('%s%s\n', 'No predicted data for: ', date.date2str());
        return;
    end
    
    % The data we want is in the 18th line
    discardLines(fileID, 17);
    
    % Split the line by whitespace and grab the relevant data
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    twoF_str = char(line(3));
    % Get rid of the semicolon
    twoF_str = twoF_str(1:end-1);
    % Convert string to double
    twoF = str2double(twoF_str);
    
    fclose(fileID);
end