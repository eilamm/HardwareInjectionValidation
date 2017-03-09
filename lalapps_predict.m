% Eilam Morag
% October 29, 2016
% lalapps_compute: gives the following bash command:
% lalapps_PredictFstat --DataFiles \"$DATAFILES\" --ephemEarth \"$EARTH_PATH\" 
% --ephemSun \"$SUN_PATH\" --Freq=$F0 --Alpha=$ASCENSION --Delta=$DECLINATION 
% --aPlus=$APLUS --aCross=$ACROSS --psi=$PSI --IFO \"H1\" --outputFstat " << outputFstat;
function lalapps_predict(p, datafiles, date, cumulative, server)
    % Suffix is used to uniquely name the lalapps scripts and their outputs
    if (cumulative == 1)
        suffix = ['_', date.date2str_nospace, '_cumulative'];
    elseif (cumulative == 0)
        suffix = ['_', date.date2str_nospace, '_daily'];
    end
    
    basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/';
    % Name for the output of the lalapps_predict script
    val = sprintf('%s%s%i%s%s', basepath, 'output/FstatPredicted_', p.id, suffix, '.txt');
    
    earthpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz';
    sunpath = '/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz';
    
    fprintf('%s%i\n', 'Predicting injection: ', p.id);
    earth = ['" --ephemEarth "', earthpath];
    sun = ['" --ephemSun "', sunpath];
%     Freq = ['" --Freq=', num2str(p.f0)];
    Freq = sprintf('%s%1.12e', '" --Freq=', p.f0);
%     alpha = [' --Alpha=', num2str(p.alpha)];
    alpha = sprintf('%s%1.12e', ' --Alpha=', p.alpha);
%     delta = [' --Delta=', num2str(p.delta)];
    delta = sprintf('%s%1.12e', ' --Delta=', p.delta);
%     aplus = [' --aPlus=', num2str(p.aplus)];
    aplus = sprintf('%s%1.15e', ' --aPlus=', p.aplus);
%     across = [' --aCross=', num2str(p.across)];
    across = sprintf('%s%1.15e', ' --aCross=', p.across);
%     psi = [' --psi=', num2str(p.psi)];
    psi = sprintf('%s%1.15e', ' --psi=', p.psi);
    
    last = [' --IFO "', server, '" --outputFstat ', val];
    cmd = sprintf('%s', 'lalapps_PredictFstat --DataFiles "', ...
        datafiles, earth, sun, Freq, alpha, delta, aplus, across, psi, last);
    
    % Name of the actual lalapps_predict script
    filename = [basepath, 'scripts/predict_pulsarx', num2str(p.id), suffix];
%     disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, cmd);
    fclose(fileID);
    
    file2script = ['chmod u+x ', filename];
    system(file2script);
%     [~, output] = system(['./', filename]);
%     disp(output);
end