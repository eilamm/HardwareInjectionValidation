% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

%% Clear variables, close figures, and add directories to path
clear
close

addpath('Classes');
addpath('Functions');
addpath('Plotting');
addpath('Scripts');
addpath('Website');

%% Set the end and start date for plotting (will only plot days that have not yet been plotted)
% O1
% A = Date([11, 25, 2015]);
% B = Date([1, 17, 2016]);

% O2
A = O2StartDate(); % O2 start date
% B = Date([1, 15, 2017]);
% B = todayDate();
% B = O2EndDate();
B = Date([8, 22, 2017]);

%% Call plotFStat for each pulsar
pulsars = [0:1:12, 14];
for i = pulsars
    fprintf('%s%d\n', 'Plotting pulsar: ', i);
    plotFStat(A, B, i);
end 

quit
