% Returns the directory where the homepage for the website is stored
function path = getWebsiteLocation()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 26);
    path = fgetl(fileID);
    fclose(fileID);
end
