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
    
    if (cumulative == 1)
        suffix = ['_', date.date2str_nospace, '_cumulative'];
    elseif (cumulative == 0)
        suffix = ['_', date.date2str_nospace, '_daily'];
    end
    
    basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/';
    % Names for the output files of the lalapps_compute script
    loud = sprintf('%s%s%i%s%s', basepath, 'output/FstatLoudest_', p.id, suffix, '.txt');
    val = sprintf('%s%s%i%s%s', basepath, 'output/FstatValues_', p.id, suffix, '.txt');
    hist = sprintf('%s%s%i%s%s', basepath, 'output/FstatHist_', p.id, suffix, '.txt');
    
    earthpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz';
    sunpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz';
    
    fprintf('%s%i\n', 'Recovering injection: ', p.id);
    
    FreqBand = (5/86400)/num_days;
    
    earth = ['" --ephemEarth "', earthpath];
    sun = ['" --ephemSun "', sunpath];
    
    Freq = sprintf('%s%1.15e', '" --Freq=', p.f0);
    Freqband = sprintf('%s%1.15e', ' --FreqBand=', FreqBand);
    alpha = sprintf('%s%1.15e', ' --Alpha=', p.alpha);
    delta = sprintf('%s%1.15e', ' --Delta=', p.delta);
    f1dot = sprintf('%s%1.15e', ' --f1dot=', p.fdot);
    refTime = sprintf('%s%d', ' --refTime=', p.reftime);
    tags = sprintf('%s',  ' --IFO "', server, '" --FstatMethod "ResampBest" ');
    outputFiles = sprintf('%s', '--outputLoudest ', loud, ' --outputFstat ', val, ...
        ' --outputFstatHist ', hist);
    
    cmd2 = sprintf('%s%s%s%s%s%s%s%1.15e%s%1.15e%s%1.15e%s%1.15e%s%1.15e%s%d%s%s%s%s%s%s%s%s', 'lalapps_ComputeFstatistic_v2 --DataFiles "', ...
        datafiles, '" --ephemEarth "', earthpath,  '" --ephemSun "', ...
        sunpath, '" --Freq=', p.f0, ' --FreqBand=', FreqBand, ' --Alpha=', ...
        p.alpha, ' --Delta=', p.delta, ' --f1dot=', p.fdot, ...
        ' --refTime=', p.reftime, ' --IFO "H1" --FstatMethod "ResampBest" ', ...
        '--outputLoudest ', loud, ' --outputFstat ', val, ...
        ' --outputFstatHist ', hist);
    
    cmd = sprintf('%s%s%s%s%s%s%s%s%s', 'lalapps_ComputeFstatistic_v2 --DataFiles "', ...
        datafiles, earth, sun, Freq, Freqband, alpha, delta, f1dot, ...
        refTime, tags, outputFiles);
        
    
    % Actual name of the lalapps_compute script
    filename = [basepath, 'scripts/recover_pulsarx', num2str(p.id), suffix];
%     disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
%     [~, output] = system(['./', filename]);
%     disp(output);
end