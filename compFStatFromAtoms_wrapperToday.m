% Wrapper for compFStatFromAtoms function. This script is designed to be used on an automated, daily basis. It
% will call compFStatFromAtoms with the current day's date, UNLESS the observation run has already ended, in which
% case, it will do nothing.

clear all;
close all;

includePaths;

firstDate = O2StartDate();
lastDate = O2EndDate();

today = todayDate();

if (today >= firstDate && today <= lastDate)
	compFStatFromAtoms(today);
else
	fprintf('Observation run 2 not in progress - exiting\n');
	compFStatFromAtoms(lastDate);
end
