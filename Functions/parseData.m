% Eilam Morag
% October 29, 2016
% parseData: grabs a line from the file, splits it by white space,
% grabs the middle value (the data), and returns it as a double. USED FOR PULSAR CLASS.
function data = parseData(fileID)
    line = strsplit(fgetl(fileID));
    data = str2double(line(2));
end
