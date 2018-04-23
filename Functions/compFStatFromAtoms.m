% This function will compute the daily and cumulative F-stat values for the input 'date'
% and for all pulsars. It is not meant for direct use, but rather for use through the 
% wrapper functions compFStatFromAtoms_wrapperToday, compFStatFromAtoms_wrapperTotal 

function compFStatFromAtoms(date)
	pulsars = [0:12, 14]; 				% Skip pulsar 13
	projPath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016'; 
	for p = pulsars
		fprintf('Calculating F-stat for Pulsar %d, %s...\n', p, date.date2str());
		dailyAtomsPath = sprintf('%s/Atoms/daily/Pulsar%d/%s', projPath, p, date.date2str_nospace());
		cumulAtomsPath = sprintf('%s/Atoms/cumulative/Pulsar%d/%s', projPath, p, date.date2str_nospace());
			
		%% Parse the atoms and compute the F-stat values for pulsar 'p'
		fprintf('\tDaily F-stat -- ');
		dailyFStatsFromAtoms = compFStat(dailyAtomsPath);	% Need to modify parseAtoms so it's a func that returns 2F values
		fprintf('\tCumulative F-stat -- ');
		cumulFStatsFromAtoms = compFStat(cumulAtomsPath);

		% Get the loudest F-stat
		dailyLoudestFStat = max(dailyFStatsFromAtoms);
		cumulLoudestFStat = max(cumulFStatsFromAtoms);
	
		%% Output cumulative and daily F-stat to file
		outputPath = sprintf('%s/output/Pulsar%d/%s', projPath, p, date.date2str_nospace());
		filename = sprintf('%s/FStatFromAtoms_Pulsar%d_%s.txt', outputPath, p, date.date2str_nospace());
		fprintf('Outputting loudest F-stat candidates to %s... ', filename);
		fileID = fopen(filename, 'w');
		fprintf(fileID, 'Loudest F-stat for Pulsar %d on %s\n', p, date.date2str());
		fprintf(fileID, 'daily\tcumulative\n%f\t%f', dailyLoudestFStat, cumulLoudestFStat);
		fclose(fileID);
		fprintf('done\n\n');
		% create a file that contains the dailyFstat and another that contains the cumul Fstat (or maybe one file) and save it to the outputPath
	end

end

% Helper function that parses an atom file for a, b, c, Fa, and Fb values. Computes
% and returns the 2F value.
function twoF = compFStat(pathToAtoms)
	%% Gather all atom files in the path
	files = dir(sprintf('%s/*.dat', pathToAtoms));
	if (isempty(files))
		twoF = NaN;
		return;
	end
	numFreqBins = length(files);
	twoF = zeros(numFreqBins, 1);
	fprintf('%d frequency bins -- ', numFreqBins);
	for k  = 1:numFreqBins

%	filename = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/Prefix_tRef751680013_RA0.652645832_DEC-0.514042406_Freq849.083308009024_f1dot-3e-10.dat';
		filename = sprintf('%s/%s', pathToAtoms, files(k).name);
		fileID = fopen(filename);
		if (fileID == -1)
			error('File does not exist: %s', filename);
		else
	%		fprintf('File exists\n');
		end
	

		%% Discard header by reading lines until we find the number of SFTs in this file
		line = ''; % Create an empty string to initialize the variable
		pattern = 'Loaded SFTs:';
		while (isempty(strfind(line, pattern)))
			line = fgetl(fileID);
		end
		% The string 'line' will have the format '%% Loaded SFTs: [ H1:43 ]' where H1 and 43 may change
		temp = strfind(line, ':');
		leftmostDigit = temp(2) + 1;
		temp = line(leftmostDigit:end);
		temp = strsplit(temp);
		numSFTs = str2double(temp{1});
	
		% Initialize value vectors
		GPS = zeros(numSFTs, 1);
		a_sqr = zeros(numSFTs, 1);
		b_sqr = zeros(numSFTs, 1);
		ab = zeros(numSFTs, 1);
		Fa = zeros(numSFTs, 1);
		Fb = zeros(numSFTs, 1);
	
	
		%% Find total time spanned
		line = ''; % Create an empty string to initialize the variable
		pattern = 'Total time spanned';
		while (isempty(strfind(line, pattern)))
			line = fgetl(fileID);
		end
		% The string 'line' will have the format '%% Total time spanned    = 84681 s (23.52 hours)' where the numbers may change and the whitespaces may be arbitrarily long
		temp = strsplit(line, ' = ');
		temp = temp{2};
		temp = strsplit(temp, ' s ');
		temp = temp{1};
		timeSpanned = str2double(temp);
	
		%% Discard header by reading lines until we find the line that starts with GPS[s]
		line = '';
		pattern = 'GPS[s]';
		while (isempty(strfind(line, pattern)))
			line = fgetl(fileID);
		end	
	
		% Parse individual atoms
		for (i = 1:numSFTs)
			line = fgetl(fileID);
			values = strsplit(line);
			GPS(i) = str2double(values{1});
			a_sqr(i) = str2double(values{2});
			b_sqr(i) = str2double(values{3});
			ab(i) = str2double(values{4});
			Fa(i) = str2double(values{5}) + 1i*str2double(values{6});
			Fb(i) = str2double(values{7}) + 1i*str2double(values{8});
		end
		
		%% Close file
		fclose(fileID);

		%% Calculate Fstat
		A = sum(a_sqr);
		B = sum(b_sqr);
		C = sum(ab);
		Fa_t = sum(Fa);
		Fb_t = sum(Fb);
			
		D = A*B - C^2;
		D_inv = 1.0/D;
		
		F = D_inv*( B*abs(Fa_t)^2 + A*abs(Fb_t)^2 - 2*C*real(Fa_t*conj(Fb_t)) );
		twoF(k) = 2*F;

		if (k ~= numFreqBins)
			fprintf('%d/%d --', k, numFreqBins);
		else
			fprintf('%d/%d\n', k, numFreqBins);
		end
	end	
	
end
