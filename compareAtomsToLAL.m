% This script will compare the F-stat values computed by my atoms method with the values computed by LAL's method

clear all;
close all;

includePaths;

firstDate = O2StartDate();
% lastDate = Date([1 1 2017]);
lastDate = O2EndDate();
date = firstDate;
numDays = lastDate - firstDate;
days = 1:numDays;

pulsars = [0:12, 14];

fstatValues = zeros(numDays, 4);		% Columns 1-4 are atom daily, lal daily, atom cumulative, lal cumulative, respectively

projPath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016'; 
for p = pulsars
	date = firstDate;
	for i = days
		% Path to folder
		inputPath = sprintf('%s/output/Pulsar%d/%s', projPath, p, date.date2str_nospace());
		% Open atom output file
		% Parse daily and cumulative loudest f-stat, save to fstatValues in cols 1 and 3
		% Close atom output file
		filename = sprintf('%s/FStatFromAtoms_Pulsar%d_%s.txt', inputPath, p, date.date2str_nospace());
		[daily2F, cumulative2F] = parseFStatFromAtoms(filename);
		fstatValues(i, 1) = daily2F;
		fstatValues(i, 3) = cumulative2F;
		% Open lal daily output file
		% Parse and put into fstatValues col 2
		% Close lal daily output file
		fstatValues(i, 2) = parseFstatLoudest(p, date, 0);
		% Open lal cumulative output file
		% Parse and put into fstatValues col 4
		% Close lal cumulative ouput file
		fstatValues(i, 4) = parseFstatLoudest(p, date, 1);

		date = date.next_day();
	end 
	h = figure;
	% Plot atom daily vs days
	scatter(days, fstatValues(:, 1), 'MarkerFaceColor', 'blue');
	hold on;
	% Plot lal daily vs days on same plot
	scatter(days, fstatValues(:, 2), 'MarkerFaceColor', 'none');
	xTickDateLabels(firstDate, lastDate, h);
	title('Loudest Daily F-stat Candidate');
	xlabel(sprintf('Days since %s', firstDate.date2str()));
	ylabel('F-stat');
	legend('Atoms', 'LAL', 'Location', 'eastoutside');
	grid;
	plotFilename = sprintf('/home/eilam.morag/public_html/HWInjection/Pulsar%02d/dailyPulsar%d_%s_%s', p, p, firstDate.date2str_nospace(), lastDate.date2str_nospace());
	saveas(gcf, plotFilename, 'png');
	close(gcf);

	hold off;
	h = figure;
	% Plot atom cumulative vs days
	% scatter(days, fstatValues(:, 3), 'MarkerFaceColor', 'blue');
	plot(days, fstatValues(:, 3));
	hold on;
	% Plot lal cumulative vs days on same plot
	% scatter(days, fstatValues(:, 4), 'MarkerFaceColor', 'none');
	plot(days, fstatValues(:, 4), '--');
	xTickDateLabels(firstDate, lastDate, h);
	title('Loudest Cumulative F-stat Candidate');
	xlabel(sprintf('Days since %s', firstDate.date2str()));
	ylabel('F-stat');
	legend('Atoms', 'LAL', 'Location', 'eastoutside');
	grid;
	plotFilename = sprintf('/home/eilam.morag/public_html/HWInjection/Pulsar%02d/cumulativePulsar%d_%s_%s', p, p, firstDate.date2str_nospace(), lastDate.date2str_nospace());
	saveas(gcf, plotFilename, 'png');
	close(gcf);
end
