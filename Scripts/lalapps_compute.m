% Eilam Morag
% October 29, 2016
% lalapps_compute: gives the following bash command:
% lalapps_ComputeFstatistic_v2 --DataFiles \"$DATAFILES\" 
% --ephemEarth \"$EARTH_PATH\" --ephemSun \"$SUN_PATH\" --Freq=$F0 
% --FreqBand=$FREQBAND --Alpha=$ASCENSION --Delta=$DECLINATION 
% --f1dot=$FDOT --refTime=$REFTIME --IFO \"H1\" --FstatMethod 
% \"ResampBest\" --outputLoudest " << loud << " --outputFstat " << 
% val << " --outputFstatHist " << hist
function lalapps_compute(p, datafiles, date, cumulative, num_days, server)
    basepath = getProjectHomeLocation();
    if (cumulative == 1)
    	atomFolder = sprintf('%s/Atoms/cumulative/Pulsar%d/%s', basepath, p.id, date.date2str_nospace);
    	suffix = sprintf('%i_%s_cumulative', p.id, date.date2str_nospace);
    elseif (cumulative == 0)
    	atomFolder = sprintf('%s/Atoms/daily/Pulsar%d/%s/', basepath, p.id, date.date2str_nospace);
    	suffix = sprintf('%i_%s_daily', p.id, date.date2str_nospace);
    end
    if (~exist(atomFolder, 'dir'))
        mkdir(atomFolder);
    end
    atoms = sprintf('%s/ATOM%s', atomFolder, suffix);
    outputPath = sprintf('%s/Pulsar%d/%s', getFstatFileLocation(), p.id, date.date2str_nospace()); 
    % Names for the output files of the lalapps_compute script
    loud = sprintf('%s/%s_%s.txt', outputPath, getFstatComputeNamingConvention(), suffix);

    [~, userHomeDirectory] = system('echo ~');
    userHomeDirectory = userHomeDirectory(1:end-1); % Remove newline character
    earthpath = sprintf('%s/lalsuite/lalpulsar/test/earth00-19-DE405.dat.gz', userHomeDirectory);
    sunpath = sprintf('%s/lalsuite/lalpulsar/test/sun00-19-DE405.dat.gz', userHomeDirectory);
    
    
    FreqBand = (5/86400)/num_days;
     
    cmd = sprintf('lalapps_ComputeFstatistic_v2 --DataFiles "%s" \\\n--ephemEarth "%s" --ephemSun "%s" \\\n--Freq=%1.15e --FreqBand=%1.15e --f1dot=%1.15e \\\n--Alpha=%1.15e --Delta=%1.15e --refTime=%d \\\n--IFO "%s" --outputLoudest %s --outputFstatAtoms %s', datafiles, earthpath, sunpath, p.f0, FreqBand, p.fdot, p.alpha, p.delta, p.reftime, server, loud, atoms);

         
    % Actual name of the lalapps_compute script
    filename = sprintf('%s/%s_%s', getLALScriptsLocation(), getLALComputeNamingConvention(), suffix);
    fileID = fopen(filename, 'w');
    fprintf(fileID, '%s', cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
end
