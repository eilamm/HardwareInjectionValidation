% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
A = Date([1, 1, 2016]);
B = Date([1, 17, 2016]);

for i=0:14
    plotFStat(A, B, i);
end