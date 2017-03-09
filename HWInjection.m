% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

function HWInjection(pulsar_list_IDs, today, server)
    
    fprintf('%s%s\n', 'Creating scripts for ', today.date2str());
    % Use the list of IDs to create pulsar objects. Initialize pulsar list with
    % pulsar ID 0 everytime just to give it a data type. This pulsar will be
    % overwritten anyway.
    pulsar_list = [Pulsar(0)];
    for i = 1:1:length(pulsar_list_IDs)
        pulsar_list(i) = Pulsar(pulsar_list_IDs(i));
    end

    % start is the first day of the data range (Nov 25, 2015 for O1)
%     start = Date([11, 25, 2015]); % Uncomment for O1

    % start is the first day of the data range (Oct 20, 2016 for O2)
    start = Date([12, 31, 2016]); % Uncomment for O2
    
    num_days = today - start;

    sfts_cumulative = cumulativePoint(start, today, pulsar_list, server);
    for pulsar = pulsar_list
        lalapps_compute(pulsar, sfts_cumulative, today, 1, num_days, server);
        lalapps_predict(pulsar, sfts_cumulative, today, 1, server);
    end

    sfts_daily = dailyPoint(today, pulsar_list, server);
    for pulsar = pulsar_list
        lalapps_compute(pulsar, sfts_daily, today, 0, 1, server);
        lalapps_predict(pulsar, sfts_daily, today, 0, server);
    end
    
end
