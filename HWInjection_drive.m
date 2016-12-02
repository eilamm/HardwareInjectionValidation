% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

clear
close
pulsar_list_IDs = inputPulsars();
disp('Inputted pulsars: ');
disp(pulsar_list_IDs);

start_today = Date([11, 25, 2015]);
% end_today = Date([1, 17, 2016]);
end_today = start_today;

date = start_today;

while (date <= end_today)
    HWInjection(pulsar_list_IDs, date);
    date = date.next_day();
end
