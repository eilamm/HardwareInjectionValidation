% makes sure y-axis ticks are not in scientific notation

function yTicksDecimalNotation(fig)
	axes = fig.CurrentAxes;
	tickValues = get(axes, 'YTick');
	set(axes, 'YTickLabel', num2str(tickValues'));	
end
