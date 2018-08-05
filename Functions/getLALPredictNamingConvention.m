% Returns the naming convention for the LAL scripts that call lalapps_PredictFstatistic
function name = getLALPredictNamingConvention()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 14);
    name = fgetl(fileID);
    fclose(fileID);
end
