% Eilam Morag
% February 21, 2016
% Reads in the frequency data for a given day, month, year and frequency
% range (give the first frequency in the range). Returns the data in vector data
function filenames = read_data(day, month, year, server)
    % Uncomment below path for Hann-windowed SFTs
%     path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_HANN/',...
%            'H1_DUAL_ARM_HANN/'];
    % Below path for Tukey-windowed SFTS
    path = 'Nothing';
    if (strcmp(server, 'L1'))
        path = ['/home/pulsar/public_html/fscan/L1_DUAL_ARM/L1_DUAL_ARM_DCREADOUT_TUKEY/',...
           'L1_DUAL_ARM_DCREADOUT_TUKEY/'];
        chan = 'L1_GDS-CALIB_STRAIN';
    elseif (strcmp(server, 'H1'))
        path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_TUKEY/',...
           'H1_DUAL_ARM_TUKEY/'];
        chan = 'H1_GDS-CALIB_STRAIN';
    end
    
    filenames = '';   

    y = sprintf('%d', year);
    m = sprintf('%2d', month);
    d = sprintf('%2d', day);  
    
%     temp = [path, '/fscans_', y, '_', m, '_', d, '*'];
    folder = dir(sprintf('%sfscans_%d_%2d_%2d*', path, year, month, day));
%    folder = dir(temp);
    path = sprintf('%s%s/%s/sfts/tmp/', path, folder.name, chan);
    
%    path = [path, '/', chan, '/sfts/tmp/'];
    filetype = [path, '*.sft'];

    folder = dir(filetype); % Structure containing all the sfts in directory
    
    % if there's no SFTs in a folder, or if there's too many (e.g. Feb 23,
    % 2017), then don't make a symlink for that folder
    if (isempty(folder) || length(folder) > 1000)
        % Do nothing
        disp(['No sfts for date: ',  num2str(month), '/', num2str(day), '/', num2str(year)]);
    else
        name = Date([month, day, year]).date2str_num();
	% Open Prof. Riles' injection timespan file for this day, get all injection timespans into an array
	
	% Iterate through SFTs in the folder
	for sft = 1:length(folder)
		% Read timespan of SFT (in name)
		% If timespan is within range of injection timespans, then create a symlink to it in the directory for this date
	end 
	% Create a symlink to 
        symlink = sft2symlink(path, name);
        filenames = [symlink, '/*.sft;'];
    end
    
end
