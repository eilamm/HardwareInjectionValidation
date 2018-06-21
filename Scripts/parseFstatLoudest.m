% Eilam Morag
% November 27, 2016
% parseFstatLoudest: Parses the FstatLoudest file for a given day and 
% for daily or cumulative versions (c == 0 means daily, c == 1 means
% cumulative) and for a given pulsar
% FstatLoudest_9_Jan-17-2016_cumulative.txt
function [twoF, h0, cosiota, phi0, psi] = parseFstatLoudest(id, date, c)
    basepath = sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/Pulsar%d/%s', id, date.date2str_nospace());
    if (c == 0)
%        file = sprintf('%s%s%i%s%s%s', basepath, '/FstatLoudestResampOff_', id, '_', ...
            file = sprintf('%s%s%i%s%s%s', basepath, '/FstatLoudestResampOff_restricted_', id, '_', ...
            date2str_nospace(date), '_daily.txt');
    elseif (c == 1)
%        file = sprintf('%s%s%i%s%s%s', basepath, '/FstatLoudestResampOff_', id, '_', ...
            file = sprintf('%s%s%i%s%s%s', basepath, '/FstatLoudestResampOff_restricted_', id, '_', ...
            date2str_nospace(date), '_cumulative.txt');
    end
    
    fileID = fopen(file);
    % If the file does not exist
    if (fileID == -1)
        twoF = NaN;
	h0 = NaN;
	cosiota = NaN;
	phi0 = NaN;
	psi = NaN;
        fprintf('%s%i%s%s\n', 'No loudest data for Pulsar ', id, ' on ', date.date2str());
        return;
    end

    % h0 is on 23rd line -- skip first 22 lines of file
    discardLines(fileID, 22);
    % Read in line 23 and split it by whitespace
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    h0_str = char(line(3));
    % Get rid of the semicolon
    h0_str = h0_str(1:end-1);
    % Convert string to double
    h0 = str2double(h0_str);


    % cos(iota) is on the 25th line -- skip line 24
    discardLines(fileID, 1); 
    % Read in line 25 and split it by whitespace
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    cosiota_str = char(line(3));
    % Get rid of the semicolon
    cosiota_str = cosiota_str(1:end-1);
    % Convert string to double
    cosiota = str2double(cosiota_str);


    % phi0 is on the 27th line -- skip line 26
    discardLines(fileID, 1); 
    % Read in line 27 and split it by whitespace
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    phi0_str = char(line(3));
    % Get rid of the semicolon
    phi0_str = phi0_str(1:end-1);
    % Convert string to double
    phi0 = str2double(phi0_str);

    % psi is on the 29th line -- skip line 28
    discardLines(fileID, 1); 
    % Read in line 29 and split it by whitespace
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    psi_str = char(line(3));
    % Get rid of the semicolon
    psi_str = psi_str(1:end-1);
    % Convert string to double
    psi = str2double(psi_str);

    % 2F is on the 47th line -- skip lines 30-46    
    discardLines(fileID, 17); 
    % Read in line 47 and split it by whitespace
    line = strsplit(fgetl(fileID));
    % Take the data from line and convert it from a cell array to a string
    twoF_str = char(line(3));
    % Get rid of the semicolon
    twoF_str = twoF_str(1:end-1);
    % Convert string to double
    twoF = str2double(twoF_str);
    fclose(fileID);
end

