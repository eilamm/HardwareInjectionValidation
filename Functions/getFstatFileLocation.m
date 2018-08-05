% Returns the path to the directory where the files containing F-stat values will be stored. The actual files will be in subdirectories branching from this directory (see stage 2 in manual)
function path = getFstatFileLocation()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 17);
    path = fgetl(fileID);
    fclose(fileID);
end
