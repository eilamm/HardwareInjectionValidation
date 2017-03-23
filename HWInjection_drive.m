% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

clear
close

firstRunInit();

pulsar_list_IDs = inputPulsars();
disp('Inputted pulsars: ');
disp(pulsar_list_IDs);

% start_today = Date([11, 25, 2015]); % Start of O1
% end_today = Date([12, 31, 2015]);
% end_today = Date([1, 17, 2016]); % End of O1

start_today = Date([12, 31, 2016]);
% end_today = Date([1, 15, 2017]);
end_today = todayDate();

date = start_today;

server = getServerName();

while (date <= end_today)
    HWInjection(pulsar_list_IDs, date, server);
    date = date.next_day();
end

create_runAll_scripts(start_today, end_today);
fprintf('%s%s%s%s%s\n', 'Finished creating LAL scripts. Navigate to the "scripts" ', ...
    'directory and execute the script "runAllScripts" to ', ...
    'run all the LAL scripts. This may take awhile. Once the scripts ', ...
    'have finished running, navigate back to this directory ', ...
    'and run the MATLAB script "plotFStat_drive" to generate plots.');

quit