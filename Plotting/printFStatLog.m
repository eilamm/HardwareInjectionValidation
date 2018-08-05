% Prints the cumulative and daily f-stats for a range of days to an output file

function printFStatLog(firstDay, lastDay, dailyData, cumulativeData, id)
	numDays = lastDay - firstDay;
	if (numDays ~= length(dailyData) || numDays ~= length(cumulativeData))
		error('Mismatch in array lengths; should be as many entries as there are days in the range');
	end
	text = cell(5, numDays);
	d = firstDay;
	for i = 1:numDays
		text{1, i} = d.date2str();
		text{2, i} = sprintf('%8.3f', dailyData(i, 1));
		text{3, i} = sprintf('%8.3f', dailyData(i, 2));
		text{4, i} = sprintf('%8.3f', cumulativeData(i, 1));
		text{5, i} = sprintf('%8.3f', cumulativeData(i, 2));
		d = d.next_day();
	end
    filename = sprintf('%s/Pulsar%02d/%s/FStatList_%s.txt', getWebsiteLocation(), id, lastDay.date2str_num(), lastDay.date2str_nospace());
	fileID = fopen(filename, 'w');
	if (fileID == -1)
		fprintf('Could not print log on %s\n', lastDay.date2str());
		return;
	end
	fprintf(fileID, 'Loudest F-stat values for Pulsar %02d between %s and %s\n', id, firstDay.date2str(), lastDay.date2str());
	fprintf(fileID, 'Date\t\t\tDaily\t\t\tPredicted Daily\t\tCumulative\t\tPredicted Cumulative\n');
	fprintf(fileID, '%s\t\t%+s\t\t%+s\t\t%+s\t\t%+s\n', text{:});
	fclose(fileID);

	recentFolder = sprintf('%s/Pulsar%02d/current/FStatList.txt', getWebsiteLocation(), id);
	copyfile(filename, recentFolder);
end 
