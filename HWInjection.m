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

% Use the list of IDs to create pulsar objects
pulsar_list@Pulsar = [];
for i = 1:1:length(pulsar_list_IDs)
    pulsar_list(i) = Pulsar(pulsar_list_IDs(i));
end

% Find all the relevant datafiles
datafiles = findDatafiles();

% Run the lalapps compute and predict functions on these pulsars
for pulsar = pulsar_list
    lalapps_compute(pulsar, datafiles);
    lalapps_predict(pulsar, datafiles);
end