% Eilam Morag
% October 29, 2016
% lalapps_compute: gives the following bash command:
% lalapps_PredictFstat --DataFiles \"$DATAFILES\" --ephemEarth \"$EARTH_PATH\" 
% --ephemSun \"$SUN_PATH\" --Freq=$F0 --Alpha=$ASCENSION --Delta=$DECLINATION 
% --aPlus=$APLUS --aCross=$ACROSS --psi=$PSI --IFO \"H1\" --outputFstat " << outputFstat;
function lalapps_predict(p, datafiles, date, cumulative, server)
    % Suffix is used to uniquely name the lalapps scripts and their outputs
    if (cumulative == 1)
       % suffix = ['_', date.date2str_nospace, '_cumulative'];
	suffix = sprintf('_%i_%s_cumulative', p.id, date.date2str_nospace);
    elseif (cumulative == 0)
       % suffix = ['_', date.date2str_nospace, '_daily'];
	suffix = sprintf('_%i_%s_daily', p.id, date.date2str_nospace);
    end
    
    basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/';
    % Name for the output of the lalapps_predict script
    outputPath = sprintf('%soutput/Pulsar%d/%s/', basepath, p.id, date.date2str_nospace()); 
    val = sprintf('%sFstatPredicted_restricted%s.txt', outputPath, suffix);
%    val = sprintf('%s%s%i%s%s', basepath, 'output/FstatPredicted_', p.id, suffix, '.txt');
    
%     earthpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz';
    earthpath = '/home/eilam.morag/lalsuite/lalpulsar/test/earth00-19-DE405.dat.gz';
%     sunpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz';
    sunpath = '/home/eilam.morag/lalsuite/lalpulsar/test/sun00-19-DE405.dat.gz';
    
%     fprintf('%s%i\n', 'Predicting injection: ', p.id);
    earth = ['" --ephemEarth "', earthpath];
    sun = ['" --ephemSun "', sunpath];
    Freq = sprintf('%s%1.12e', '" --Freq=', p.f0);
    alpha = sprintf('%s%1.12e', ' --Alpha=', p.alpha);
    delta = sprintf('%s%1.12e', ' --Delta=', p.delta);
    aplus = sprintf('%s%1.15e', ' --aPlus=', p.aplus);
    across = sprintf('%s%1.15e', ' --aCross=', p.across);
    psi = sprintf('%s%1.15e', ' --psi=', p.psi);
    
    last = [' --IFO "', server, '" --outputFstat ', val];
    cmd = sprintf('%s', 'lalapps_PredictFstat --DataFiles "', ...
        datafiles, earth, sun, Freq, alpha, delta, aplus, across, psi, last);
    
    % Name of the actual lalapps_predict script
%    filename = [basepath, 'scripts/predict_pulsar',  suffix];
    filename = [basepath, 'scripts/predict_pulsar_restricted',  suffix];
%     disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
%     [~, output] = system(['./', filename]);
%     disp(output);
end
