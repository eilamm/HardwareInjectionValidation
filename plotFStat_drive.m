% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
% O1
% A = Date([11, 25, 2015]);
% B = Date([1, 17, 2016]);

% O2
A = O2StartDate(); % O2 start date
% B = Date([1, 15, 2017]);
B = todayDate();

%% Call plotFStat for each pulsar
pulsars = [0:1:12, 14];
for i = pulsars
    fprintf('%s%d\n', 'Plotting pulsar: ', i);
    plotFStat(A, B, i);
end 

quit