% Eilam Morag
% February 21, 2016
% Reads in the frequency data for a given day, month, year and frequency
% range (give the first frequency in the range). Returns the data in vector data
function [filenames, file_exists, folder_path] = read_data(day, month, ...
                                        year)
    path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_HANN/',...
           'H1_DUAL_ARM_HANN/'];
       
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
%     temp = [path, 'spec_', num2str(first_val), '.00_', ...
%             num2str(first_val + 100), '.00_*.txt'];
%         
    folder_path = path; % Return directory where the files are.
        
    folder = dir(filetype); % YOU WERE HERE - NOVEMBER 20, 2016 8:51 PM
    if (isempty(folder))
        file_exists = 0;
        
    else
        filenames = '';
        for i = folder
            filenames = [filenames folder_path folder(i).name ';' ];
        end
        
    end
    
end