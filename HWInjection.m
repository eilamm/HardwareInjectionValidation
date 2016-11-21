% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

clear;
pulsar_list_IDs = inputPulsars();
disp('Inputted pulsars: ');
disp(pulsar_list_IDs);

% Use the list of IDs to create pulsar objects. Initialize pulsar list with
% pulsar ID 0 everytime just to give it a data type. This pulsar will be
% overwritten anyway.
pulsar_list = [Pulsar(0)];
for i = 1:1:length(pulsar_list_IDs)
    pulsar_list(i) = Pulsar(pulsar_list_IDs(i));
end

start = Date([11, 25, 2015]);
today = Date([1, 17, 2016]);

sfts_cumulative = cumulativePoint(start, today, pulsar_list);
for pulsar = pulsar_list
    lalapps_compute(pulsar, sfts_cumulative, today, 1);
    lalapps_predict(pulsar, sfts_cumulative, today, 1);
end

sfts_daily = dailyPoint(today, pulsar_list);
for pulsar = pulsar_list
    lalapps_compute(pulsar, sfts_daily, today, 0);
    lalapps_predict(pulsar, sfts_daily, today, 0);
end
% Find all the relevant datafiles
% datafiles = findDatafiles();

% % Run the lalapps compute and predict functions on these pulsars
% for pulsar = pulsar_list
%     lalapps_compute(pulsar, datafiles);
%     lalapps_predict(pulsar, datafiles);
% end