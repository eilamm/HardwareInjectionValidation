% Returns the naming convention for the LAL scripts that call lalapps_ComputeFstatistic_v2
function name = getLALComputeNamingConvention()
    pathSettings = sprintf('%s/Settings/paths.txt', getProjectHomeLocation());
    fileID = fopen(pathSettings);
    discardLines(fileID, 11);
    name = fgetl(fileID);
    fclose(fileID);
end
