% Eilam Morag
% October 29, 2016
% lalapps_compute: gives the following bash command:
% lalapps_PredictFstat --DataFiles \"$DATAFILES\" --ephemEarth \"$EARTH_PATH\" 
% --ephemSun \"$SUN_PATH\" --Freq=$F0 --Alpha=$ASCENSION --Delta=$DECLINATION 
% --aPlus=$APLUS --aCross=$ACROSS --psi=$PSI --IFO \"H1\" --outputFstat " << outputFstat;
function lalapps_predict(p, datafiles, date, cumulative)
    val = sprintf('%s%i%s', 'FstatValues_', p.id, '.txt');
    
    earthpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz';
    sunpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz';
    
    fprintf('%s%i\n', 'Predicting injection: ', p.id);
    earth = ['" --ephemEarth "', earthpath];
    sun = ['" --ephemSun "', sunpath];
    Freq = ['" --Freq=', num2str(p.f0)];
    alpha = [' --Alpha=', num2str(p.alpha)];
    delta = [' --Delta=', num2str(p.delta)];
    aplus = [' --aPlus=', num2str(p.aplus)];
    across = [' --aCross=', num2str(p.across)];
    psi = [' --psi=', num2str(p.psi)];
    
    last = [' --IFO "H1" --outputFstat ', val];
    cmd = sprintf('%s', 'lalapps_PredictFstat --DataFiles "', ...
        datafiles, earth, sun, Freq, alpha, delta, aplus, across, psi, last);
    
    if (cumulative == 1)
        filename = ['predict_pulsarx', num2str(p.id), '_', date.date2str_nospace, '_cumulative'];
    elseif (cumulative == 0)
        filename = ['predict_pulsarx', num2str(p.id), '_', date.date2str_nospace, '_daily'];
    end
    disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
%     [~, output] = system(['./', filename]);
%     disp(output);
end