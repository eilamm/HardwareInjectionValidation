% Returns the naming convention for the files containing the predicted F-stat
function name = getFstatPredictNamingConvention()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 23);
    name = fgetl(fileID);
    fclose(fileID);
end
