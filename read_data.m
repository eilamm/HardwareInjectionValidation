% Eilam Morag
% February 21, 2016
% Reads in the frequency data for a given day, month, year and frequency
% range (give the first frequency in the range). Returns the data in vector data
function filenames = read_data(day, month, ...
                                        year)
    path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_HANN/',...
           'H1_DUAL_ARM_HANN/'];
    filenames = '';   
       
    y = num2str(year);
    if (month < 10)
        m = ['0', num2str(month)];
    else
        m = num2str(month);
    end
    if (day < 10)
        d = ['0', num2str(day)];
    else
        d = num2str(day);
    end
    
    temp = [path, '/fscans_', y, '_', m, '_', d, '*'];
    folder = dir(temp);
    path = [path, folder.name];
    
    chan = 'H1_CAL-DELTAL_EXTERNAL_DQ';
        
    path = [path, '/', chan, '/sfts/tmp/'];
    filetype = [path, '*.sft'];

    folder_path = path; % Return directory where the files are.        
    folder = dir(filetype); % Structure containing all the sfts in directory
    
    if (isempty(folder))
        % Do nothing
        disp(['No sfts for date: ', num2str(day), '/', num2str(month), '/', num2str(year)]);
    else
        for i = 1:length(folder)
            filenames = [filenames, folder_path, folder(i).name, ';' ];
        end
        
    end
    
end