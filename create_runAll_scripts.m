% Eilam Morag
% December 2, 2016
% Creates four scripts that will run all the lalapps-calling scripts
function create_runAll_scripts(startdate, enddate)
%     base = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/';
%     % Cumulative Compute
%     inputFile = [base, 'recover_pulsarx*cumulative'];
%     outputFile = 'ComputeCumulativeRunAllScripts';
%     create_runAll_scripts_helper(inputFile, outputFile);
%     
%     % Daily Compute
%     inputFile = [base, 'recover_pulsarx*daily'];
%     outputFile = 'ComputeDailyRunAllScripts';
%     create_runAll_scripts_helper(inputFile, outputFile);
%     
%     % Cumulative Predict
%     inputFile = [base, 'predict_pulsarx*cumulative'];
%     outputFile = 'PredictCumulativeRunAllScripts';
%     create_runAll_scripts_helper(inputFile, outputFile);
%     
%     % Daily Predict
%     inputFile = [base, 'predict_pulsarx*daily'];
%     outputFile = 'PredictDailyRunAllScripts';
%     create_runAll_scripts_helper(inputFile, outputFile);
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
    
    base = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/';
    
    outpath = [base, outputFile];
    fileID = fopen(outpath, 'w');
    
    script_beginning = sprintf('%s\n\n%s\n%s\n\n', '#!/bin/bash',...
        'start_time=$(date +%s)', ...
        'echo "Running scripts of type: ', list{1}, '... "');
    
    fprintf(fileID, '%s', script_beginning);


    % Print the scripts to the file, period is for ./script
    for i = 1:nrows
        fprintf(fileID, '%s%s\n', '.', list{i});
    end
    
    script_ending = sprintf('\n\n%s\n\n%s\n%s\n%s\n', 'echo "Finished running all scripts"', ...
        'end_time=$(date +%s)', 'runtime=$((end_time-start_time))', ...
        'echo "Runtime: $runtime"');

    fprintf(fileID, '%s', script_ending);
    
    fclose(fileID);
    
    system(['chmod u+x ', outpath]);
end




%% Local function listUnexecutedScripts
% Returns a list of scriptnames that fall within the constraints and have
% not yet been executed
function list = listUnexecutedScripts(startdate, enddate, compute, daily)
    outpath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/';
    scrpath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/';
    %% Pre and suffixes to the Fstat files and lalapps scripts
    % Example file: FstatValues_9_Nov-30-2015_daily.txt; FstatLoudest_9_Jan-6-2016_cumulative.txt
    % Example script: predict_pulsarx9_Dec-9-2015_daily; recover_pulsarx2_Dec-21-2015_daily
    if (compute == 1)
        fileprefix = 'FstatLoudest_';
        scriptprefix = 'recover_pulsarx';
    else
        fileprefix = 'FstatValues_';
        scriptprefix = 'predict_pulsarx';
    end
    
    if (daily == 1)
        filesuffix = '_daily.txt';
        scriptsuffix = '_daily';
    else
        filesuffix = '_cumulative.txt';
        scriptsuffix = '_cumulative';
    end
    
    %% Looking for the unexecuted scripts
    d = startdate;
    i = 1;
    pulsars = [0:1:12, 14]; 
    while (d <= enddate)
        date = d.date2str_nospace();
        for ID = pulsars
            file = sprintf('%s%s%d%s%s%s', outpath, fileprefix, ID, '_', date, filesuffix);
            if (~exist(file, 'file'))
                script = sprintf('%s%s%d%s%s%s', scrpath, scriptprefix, ID, '_', date, scriptsuffix);
                list{i} = script;
                i = i + 1;
            end
        end
        d = d.next_day();
    end
end