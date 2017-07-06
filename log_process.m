% This script will open the most recent log.txt file created by the DRIVE
% script, and save its output to 'Logs/log_<date>.txt'
addpath('Functions');
clear;
close all;

if (~exist('Logs', 'dir'))
    mkdir('Logs');
end

today = todayDate();
newFile = sprintf('%s%s%s', 'Logs/log_', today.date2str_num(), '.txt'); 
status = copyfile('log', newFile);
if (status == 1)
    fprintf('%s\n\n', 'Successfully saved log to ', newFile);
else
    fprintf('%s\n\n', 'Failed to save log to ', newFile);
end

quit;