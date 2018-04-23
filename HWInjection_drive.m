% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

%% Clear variables, close figures, and add directories to path
clear
close

addpath('Classes');
addpath('Functions');
addpath('Plotting');
addpath('Pulsar-parameters');
addpath('Scripts');
addpath('Website');

%% Initialize if this is the first run
firstRunInit();

%% Get the pulsars of interest
pulsar_list_IDs = inputPulsars();
disp('Inputted pulsars: ');
disp(pulsar_list_IDs);

%% Set the end and start date for script-creation
% start_today = Date([11, 25, 2015]); % Start of O1
% end_today = Date([12, 31, 2015]);
% end_today = Date([1, 17, 2016]); % End of O1

start_today = O2StartDate(); %Start of O2
% end_today = Date([1, 15, 2017]);
% end_today = todayDate();
if (todayDate() <= O2EndDate())
	end_today = todayDate();
else
	% end_today = O2EndDate();
	disp('Observation run not in progress - cancelling injection run.');
	return;
end

%% Create LAL scripts for all days between the start and end dates
% The switch from 'date = start_today' to 'date = end_today' was done on
% June 1, 2017. Did it because otherwise all the recover/predict scripts 
% would be regenerated every day for no reason. 
date = start_today;
% date = end_today;

server = getServerName();

while (date <= end_today)
    HWInjection(pulsar_list_IDs, date, server);
    date = date.next_day();
end

%% Create the scripts to automatically execute the LAL scripts
create_runAll_scripts(start_today, end_today);
fprintf('%s%s%s%s%s\n', 'Finished creating LAL scripts. Navigate to the "scripts" ', ...
    'directory and execute the script "runAllScripts" to ', ...
    'run all the LAL scripts. This may take awhile. Once the scripts ', ...
    'have finished running, navigate back to this directory ', ...
    'and run the MATLAB script "plotFStat_drive" to generate plots.');

quit
