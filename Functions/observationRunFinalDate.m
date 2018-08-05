% This function parses the file "observationRunDates.txt" for the final day in the observation run to be analyzed
function fd = observationRunFinalDate()
    pathSettings = sprintf('%s/Settings/observationRunDates.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 3);
    temp = strsplit(fgetl(fileID), '-');    
    m = str2num(temp{1});
    d = str2num(temp{2});
    y = str2num(temp{3});
    fd = Date([m, d, y]);
    fclose(fileID);
end
