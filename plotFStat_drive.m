% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
A = Date([12, 31, 2016]);
B = Date([1, 17, 2017]);

for i=0:14
    plotFStat(A, B, i);
end