% Takes in two dates and a figure handle, and marks the x axis tick labels with readable dates.

function xTickDateLabels(firstDate, lastDate, fig)
	numDays = lastDate - firstDate;
	% numTicks = round(numDays/spacing);
	if (numDays < 15)   % 15 was arbitrarily chosen for visual clarity
		numTicks = numDays;
	else
		numTicks = 15;
	end
	xTicks = round(linspace(1, numDays, numTicks));
	xTickLabels = cell(numTicks, 1);
	day = firstDate;					
	index = 1;						% For indexing into the xTickLabels cell array
	for i = 1:numDays
%		if (isFirstDayOfMonth(day))
%			xTickLabels{index} = day.date2str();
%			index = index + 1;
%			counter = 1;
%		elseif (counter == spacing)
%			xTickLabels{index} = day.day;
%			index = index + 1;
%			counter = 1;
%		else
%			counter = counter + 1;
%		end
		if (i == xTicks(index))
			xTickLabels{index} = day.date2str();
			index = index + 1;
		end
		day = day.next_day();
	end
	
	axes = fig.CurrentAxes;
	set(axes, 'XTick', xTicks, 'XTickLabel', xTickLabels, 'XTickLabelRotation', 45);
	xlim([1 numDays]);
end
