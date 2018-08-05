% Returns the naming convention for the files containing the computed F-stat
function name = getFstatComputeNamingConvention()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 20);
    name = fgetl(fileID);
    fclose(fileID);
end
