% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
A = Date([11, 25, 2015]);
B = Date([12, 31, 2015]);


%% Call plotFStat for each pulsar
pulsars = [0:1:12, 14];
for i = pulsars
    fprintf('%s%d\n', 'Plotting pulsar: ', i);
    plotFStat(A, B, i);
end 