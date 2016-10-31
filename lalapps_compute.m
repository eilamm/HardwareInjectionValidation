% Eilam Morag
% October 29, 2016
% lalapps_compute: gives the following bash command:
% lalapps_ComputeFstatistic_v2 --DataFiles \"$DATAFILES\" 
% --ephemEarth \"$EARTH_PATH\" --ephemSun \"$SUN_PATH\" --Freq=$F0 
% --FreqBand=$FREQBAND --Alpha=$ASCENSION --Delta=$DECLINATION 
% --f1dot=$FDOT --refTime=$REFTIME --IFO \"H1\" --FstatMethod 
% \"ResampBest\" --outputLoudest " << loud << " --outputFstat " << 
% val << " --outputFstatHist " << hist
function lalapps_compute(p, datafiles)
    loud = sprintf('%s%i%s', 'FstatLoudest_', p.id, '.txt');
    val = sprintf('%s%i%s', 'FstatValues_', p.id, '.txt');
    hist = sprintf('%s%i%s', 'FstatHist_', p.id, '.txt');
    
    earthpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz';
    sunpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz';
    
    fprintf('%s%i\n', 'Recovering injection: ', p.id);
    
    cmd = sprintf('%s%s%s%s%s%s%s%d%s%s%d%s%d%s%d%s%d%s%s%s%s%s%s%s%s', 'lalapps_ComputeFstatistic_v2 --DataFiles "', ...
        datafiles, '" --ephemEarth "', earthpath,  '" --ephemSun "', ...
        sunpath, '" --Freq=', p.f0, ' --FreqBand=0.1', ' --Alpha=', ...
        p.alpha, ' --Delta=', p.delta, ' --f1dot=', p.fdot, ...
        ' --refTime=', p.reftime, ' --IFO "H1" --FstatMethod "ResampBest" ', ...
        '--outputLoudest ', loud, ' --outputFstat ', val, ...
        ' --outputFstatHist ', hist);
    
    filename = ['recover_pulsarx', num2str(p.id)];
    disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
%     [~, output] = system(['./', filename]);
%     disp(output);
end