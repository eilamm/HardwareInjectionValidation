% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
A = Date([11, 25, 2015]);
B = Date([12, 3, 2015]);

%% If the HWInjection folder does not exist, create it
folder = 'home/eilam.morag/public_html/HWInjection';
if (~exist(folder, 'dir'))
    disp(['Creating the folder: ', folder]);
    mkdir(folder);
end
clear folder

%% Call plotFStat for each pulsar
for i=0:14
    plotFStat(A, B, i);
end