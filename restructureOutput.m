% This script is meant for one-time use, to restructure the output directory; it was not designed to be easily perused by users
% , although I often find myself looking through it for output files. The new structure will be a series of branching subdirectories
% based on pulsar# and date.

clear all;
close all;
includePaths();

base = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/output'; 

s = O2StartDate();
e = O2EndDate();

% Iterate over pulsars
for pulsar = 0:14
	d = s;				% Initialize day counter for loop
	fprintf('\n\n\t\t\tPulsar %d\n\n\n', pulsar);
	pulsar_path = sprintf('%s/Pulsar%d', base, pulsar);
	mkdir(pulsar_path);
	while (d <= e)
		path = sprintf('%s/%s', pulsar_path, d.date2str_nospace());
		mkdir(path);
		files = sprintf('%s/*_%i_%s*', base, pulsar, d.date2str_nospace());
		status = copyfile(files, path);
		if (status == 0)
			fprintf('Problem copying files for pulsar %d on day %s\n', pulsar, d.date2str_nospace());
		end
		disp(d.date2str());
		d = d.next_day();
	end
end
