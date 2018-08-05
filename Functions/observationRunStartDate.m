% This function parses the file "observationRunDates.txt" for the first day in the observation run to be analyzed
function sd = observationRunStartDate()
    pathSettings = sprintf('%s/Settings/observationRunDates.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    fgetl(fileID);
    temp = strsplit(fgetl(fileID), '-');    
    m = str2num(temp{1});
    d = str2num(temp{2});
    y = str2num(temp{3});
    sd = Date([m, d, y]);
    fclose(fileID);
end
