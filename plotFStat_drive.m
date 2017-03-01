% Eilam Morag
% November 28, 2016
% Calls plotFStat for all pulsars

clear
close
A = Date([11, 25, 2015]);
B = Date([12, 3, 2015]);

%% If the HWInjection folder does not exist, create it
temp = 'home/eilam.morag/public_html/HWInjection';
folder = dir(temp);
if (isempty(folder))
    disp(['Creating the folder: ', temp]);
    mkdir(temp);
end
clear temp folder

%% Call plotFStat for each pulsar
for i=0:14
    plotFStat(A, B, i);
end