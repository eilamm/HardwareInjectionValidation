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
%    basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/'; 
    basepath = getProjectHomeLocation();
    if (cumulative == 1)
    	atomFolder = sprintf('%s/Atoms/cumulative/Pulsar%d/%s', basepath, p.id, date.date2str_nospace);
    	mkdir(atomFolder);
    	suffix = sprintf('%i_%s_cumulative', p.id, date.date2str_nospace);
    	atoms = sprintf('%s/ATOM%s', atomFolder, suffix);
    elseif (cumulative == 0)
    	atomFolder = sprintf('%s/Atoms/daily/Pulsar%d/%s/', basepath, p.id, date.date2str_nospace);
    	mkdir(atomFolder);
    	suffix = sprintf('%i_%s_daily', p.id, date.date2str_nospace);
    	atoms = sprintf('%s/ATOM%s', atomFolder, suffix);
    end
%    outputPath = sprintf('%soutput/Pulsar%d/%s/', basepath, p.id, date.date2str_nospace()); 
    outputPath = sprintf('%s/Pulsar%d/%s', getFstatFileLocation(), p.id, date.date2str_nospace()); 
    % Names for the output files of the lalapps_compute script
%    loud = sprintf('%sFstatLoudestResampOff_restricted%s.txt', outputPath, suffix);
    loud = sprintf('%s/%s_%s.txt', outputPath, getFstatComputeNamingConvention(), suffix);

    [~, userHomeDirectory] = system('echo ~');
%    earthpath = '/home/eilam.morag/lalsuite/lalpulsar/test/earth00-19-DE405.dat.gz';
    earthpath = sprintf('%s/lalsuite/lalpulsar/test/earth00-19-DE405.dat.gz', userHomeDirectory);
%    sunpath = '/home/eilam.morag/lalsuite/lalpulsar/test/sun00-19-DE405.dat.gz';
    sunpath = sprintf('%s/lalsuite/lalpulsar/test/sun00-19-DE405.dat.gz', userHomeDirectory);
    
    
    FreqBand = (5/86400)/num_days;
     
    cmd = sprintf('lalapps_ComputeFstatistic_v2 --DataFiles "%s" \\\n--ephemEarth "%s" --ephemSun "%s" \\\n--Freq=%1.15e --FreqBand=%1.15e --f1dot=%1.15e \\\n--Alpha=%1.15e --Delta=%1.15e --refTime=%d \\\n--IFO "%s" --outputLoudest %s --outputFstatAtoms %s', datafiles, earthpath, sunpath, p.f0, FreqBand, p.fdot, p.alpha, p.delta, p.reftime, server, loud, atoms);

         
    % Actual name of the lalapps_compute script
%    filename = [basepath, 'scripts/recover_pulsar', suffix];
%    filename = [basepath, 'scripts/recover_pulsar_restricted', suffix];
    filename = sprintf('%s/%s_%s', getLALScriptsLocation(), getLALComputeNamingConvention(), suffix);
    fileID = fopen(filename, 'w');
    fprintf(fileID, '%s', cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
end
