% Wrapper for compFStatFromAtoms function. This script is designed to be used once, to retroactively compute the
% F-stat values from the atoms. This script will call compFStatFromAtoms for every day in O2.

clear all;
close all;

includePaths;

%firstDate = O2StartDate();
firstDate = Date([1 2 2017]);
lastDate = O2EndDate();
% lastDate = Date([1 1 2017]);

today = firstDate;
fprintf('Retroactively computing F-stat from atoms for all of O2 -- number of days: %d\n', lastDate - firstDate);
while (today <= lastDate)
	compFStatFromAtoms(today);
	today = today.next_day();
end
