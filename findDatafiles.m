% Eilam Morag
% October 29, 2016
% Searches for all the relevant sfts. CURRENTLY DOES NOT DISCRIMINATE BASED
% ON DATE (or anything...)
% Note that 'datafiles' is a vector of strings: each string is a path to a
% file
function datafiles = findDatafiles()
    path_to_folders = '/archive/frames/O1/pulsar/sfts/tukeywin/LHO_C01/H-1_H1_1800SFT_O1_C01-';
    datafiles = '';
    first_folder = 11324;
    last_folder = 11360;    
    
    for i = first_folder:1:last_folder
        folder_name = sprintf('%s%i%s', path_to_folders, i, '/');
        if (exist(folder_name, 'dir'))
            if (i ~= last_folder)
                datafiles = [datafiles, folder_name, '*.sft;'];
            else
                datafiles = [datafiles, folder_name, '*.sft'];
            end
        else
            fprintf('%s%s%s\n', 'Folder ', folder_name, ' does not exist');
        end
    end
end