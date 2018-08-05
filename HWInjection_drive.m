% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

%% Clear variables, close figures, and add directories to path
clear 
close all

includePaths;

%% Initialize if this is the first run
firstRunInit();

%% Set the end and start date for script-creation
startDate = observationRunStartDate();
finalDate = observationRunFinalDate();
%% Create LAL scripts for all days between the start and end dates
date = startDate;
server = getServerName();

while (date <= finalDate)
    HWInjection(date, server);
    date = date.next_day();
end

%% Create the scripts to automatically execute the LAL scripts
create_runAll_scripts(startDate, finalDate);
fprintf('%s%s%s%s%s\n', 'Finished creating LAL scripts. Navigate to the "scripts" ', ...
    'directory and execute the script "runAllScripts" to ', ...
    'run all the LAL scripts. This may take awhile. Once the scripts ', ...
    'have finished running, navigate back to this directory ', ...
    'and run the MATLAB script "plotFStat_drive" to generate plots.');

quit
