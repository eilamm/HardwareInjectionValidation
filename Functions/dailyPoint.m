% Eilam Morag
% November 19, 2016
% Creates lalapps predict and compute scripts that use only sfts from the
% selected date. 

function sfts = dailyPoint(date, pulsar_list, server)
    sfts = cumulativePoint(date, date, pulsar_list, server);
end