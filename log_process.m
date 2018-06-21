% This script will open the most recent log.txt file created by the DRIVE
% script, and save its output to 'Logs/log_<date>.txt'
clear;
close all;
includePaths;
if (~exist('Logs', 'dir'))
    mkdir('Logs');
end

today = todayDate();
newFile = sprintf('Logs/log_%s.txt', today.date2str_num()); 
status = copyfile('log', newFile);
if (status == 1)
    fprintf('%s\n\n', 'Successfully saved log to ', newFile);
else
    fprintf('%s\n\n', 'Failed to save log to ', newFile);
end

quit;
