% Eilam Morag
% December 2, 2016
% Creates four scripts that will run all the lalapps-calling scripts
function create_runAll_scripts(startdate, enddate)
    list = listUnexecutedScripts(startdate, enddate, 1, 0);
    outputFile = 'ComputeCumulativeRunAllScripts';
    create_runAll_scripts_helper(list, outputFile);
    
    list = listUnexecutedScripts(startdate, enddate, 1, 1);
    outputFile = 'ComputeDailyRunAllScripts';
    create_runAll_scripts_helper(list, outputFile);
    
    list = listUnexecutedScripts(startdate, enddate, 0, 0);
    outputFile = 'PredictCumulativeRunAllScripts';
    create_runAll_scripts_helper(list, outputFile);
    
    list = listUnexecutedScripts(startdate, enddate, 0, 1);
    outputFile = 'PredictDailyRunAllScripts';
    create_runAll_scripts_helper(list, outputFile);
end

%% Creates a script to run all lalapps scripts contained in 'list'
% Creates a script to run all files of format inputFiles. Script name will
% be outputFile.

function create_runAll_scripts_helper(list, outputFile)
    nrows = length(list);
    
%    base = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/';
%    outpath = [base, outputFile];
    outpath = sprintf('%s/%s', getLALScriptsLocation(), outputFile);
    fileID = fopen(outpath, 'w');
    
    script_beginning = sprintf('%s\n\n%s\n%s%s%s\n\n', '#!/bin/bash',...
        'start_time=$(date +%s)', ...
        'echo "Running: ', outputFile, '... "');
    
    fprintf(fileID, '%s', script_beginning);


    for i = 1:nrows
        fprintf(fileID, '%s\n', list{i});
    end
    
    script_ending = sprintf('\n\n%s\n\n%s\n\n%s\n%s\n%s\n%s', 'echo', 'echo "Finished running all scripts"', ...
        'end_time=$(date +%s)', 'runtime=$((end_time-start_time))', ...
        'echo "Runtime: $runtime"', 'echo');

    fprintf(fileID, '%s', script_ending);
    
    fclose(fileID);
    
    system(['chmod u+x ', outpath]);
end




%% Local function listUnexecutedScripts
% Returns a list of scriptnames that fall within the constraints and have
% not yet been executed
function list = listUnexecutedScripts(startdate, enddate, compute, daily)
%    outBasePath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/';
    outBasePath = getFstatFileLocation();
    scrpath = './';
    %% Pre and suffixes to the Fstat files and lalapps scripts
    % Example file: FstatValues_9_Nov-30-2015_daily.txt; FstatLoudest_9_Jan-6-2016_cumulative.txt
    % Example script: predict_pulsarx9_Dec-9-2015_daily; recover_pulsarx2_Dec-21-2015_daily
    if (compute == 1)
%        fileprefix = 'FstatLoudestResampOff_restricted_';
        fileprefix = getFstatComputeNamingConvention();
%	scriptprefix = 'recover_pulsar_restricted';
	    scriptprefix = getLALComputeNamingConvention();

    else
%        fileprefix = 'FstatPredicted_restricted_';
        fileprefix = getFstatPredictNamingConvention();
%        scriptprefix = 'predict_pulsar_restricted';
        scriptprefix = getLALPredictNamingConvention();
    end
    
    if (daily == 1)
        filesuffix = 'daily.txt';
        scriptsuffix = 'daily';
    else
        filesuffix = 'cumulative.txt';
        scriptsuffix = 'cumulative';
    end
    
    %% Looking for the unexecuted scripts
    d = startdate;
    i = 1;
    pulsars = [0:1:12, 14]; 
    while (d <= enddate)
        date = d.date2str_nospace();
        for ID = pulsars
%	    outPath = sprintf('%sPulsar%d/%s/', outBasePath, ID, date);
	    outPath = sprintf('%s/Pulsar%d/%s', outBasePath, ID, date);
            file = sprintf('%s/%s_%d_%s_%s', outPath, fileprefix, ID, date, filesuffix);
            if (~exist(file, 'file'))
%                script = sprintf('%s%s_%d%s%s_%s', scrpath, scriptprefix, ID, '_', date, scriptsuffix);
                script = sprintf('./%s_%d_%s_%s', scriptprefix, ID, date, scriptsuffix);
                list{i} = script;
                i = i + 1;
            end
        end
        d = d.next_day();
    end
    % If no scripts are unexecuted
    if (i == 1)
        temp = sprintf('%s', 'echo "All scripts previously executed: ', ...
            scriptprefix, scriptsuffix, '"');
        list{1} = temp;
    end
end
