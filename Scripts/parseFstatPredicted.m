% Eilam Morag
% November 28, 2016
% parseFstatPredicted: Parses the FstatPredicted file for a given day and 
% for daily or cumulative versions (c == 0 means daily, c == 1 means
% cumulative) and for a given pulsar
% FstatPredicted_9_Jan-17-2016_cumulative.txt

function twoF = parseFstatPredicted(id, date, c)
%    basepath = sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/Pulsar%d/%s', id, date.date2str_nospace());
    basepath = sprintf('%s/Pulsar%d/%s', getFstatFileLocation(), id, date.date2str_nospace());
    if (c == 0)
%        file = sprintf('%s%s%i%s%s%s', basepath, '/FstatPredicted_restricted_', id, '_', ...
%        date2str_nospace(date), '_daily.txt');
        file = sprintf('%s/%s_%i_%s_%s', basepath, getFstatPredictNamingConvention(), id, date2str_nospace(date), 'daily.txt');
    elseif (c == 1)
%        file = sprintf('%s%s%i%s%s%s', basepath, '/FstatPredicted_restricted_', id, '_', ...
%        date2str_nospace(date), '_cumulative.txt');
        file = sprintf('%s/%s_%i_%s_%s', basepath, getFstatPredictNamingConvention(), id, date2str_nospace(date), 'cumulative.txt');
    end
    
    fileID = fopen(file);
    % If the file does not exist
    if (fileID == -1)
        twoF = NaN;
        fprintf('%s%i%s%s\n', 'No predicted data for Pulsar ', id, ' on ', date.date2str());
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
