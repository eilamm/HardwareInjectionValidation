% Returns the path to the directory where the LAL scripts will be stored
function path = getLALScriptsLocation()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 8);
    path = fgetl(fileID);
    fclose(fileID);
end
