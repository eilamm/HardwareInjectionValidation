% Eilam Morag
% November 28, 2016
% Calls plotFStat for different dates

clear
close

A = Date([1, 17, 2016]);

for i=0:14
    plotFStat(A, A, i);
end