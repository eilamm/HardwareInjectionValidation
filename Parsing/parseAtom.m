% This script will parse an atom file for a, b, c, Fa, Fb values

clear;



%% Open the file
files = dir('/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/*.dat');
numFreqBins = length(files);
twoF = zeros(numFreqBins, 1);
for k  = 1:numFreqBins

%	filename = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/Prefix_tRef751680013_RA0.652645832_DEC-0.514042406_Freq849.083308009024_f1dot-3e-10.dat';
	filename = sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/%s', files(k).name);
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
	
	A = sum(a_sqr);
	B = sum(b_sqr);
	C = sum(ab);
	Fa_t = sum(Fa);
	Fb_t = sum(Fb);
	
	%% Close file
	fclose(fileID);
	
	%% Calculate Fstat
	D = A*B - C^2;
	D_inv = 1.0/D;
	Fa_re = real(Fa_t);
	Fa_im = imag(Fa_t);
	Fb_re = real(Fb_t);
	Fb_im = imag(Fb_t);
	
	F = D_inv*( B*abs(Fa_t)^2 + A*abs(Fb_t)^2 - 2*C*real(Fa_t*conj(Fb_t)) );
	twoF(k) = 2*F;
end	




%% Open the FstatValues file
filename = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/FstatValues_1_Apr-4-2017_daily.txt';
fileID = fopen(filename);
if (fileID == -1)
	error('File does not exist: %s', filename);
else
%		fprintf('File exists\n');
end

%% Discard header by reading lines until we find the number of SFTs in this file
line = ''; % Create an empty string to initialize the variable
pattern = '%% freq alpha';
while (isempty(strfind(line, pattern)))
	line = fgetl(fileID);
end

% Get 2F values
for i = 1:numFreqBins	
	line = fgetl(fileID);
	values = strsplit(line);
	freq = values{1};
	twoF_actual = values{7};
	
	fprintf('Frequency: %s\nCalculated 2F = %f\nExpected 2F = %s\n\n', freq, twoF(i), twoF_actual);
end

fclose(fileID);




