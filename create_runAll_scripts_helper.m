% Eilam Morag
% December 2, 2016
% Creates a script to run all files of format inputFiles. Script name will
% be outputFile.

function create_runAll_scripts_helper(inputFiles, outputFile)
    folder = dir(inputFiles);
    file_list = {folder.name}';
    nrows = length(file_list);
    
    fullpath = ['/home/eilam.morag/hw_injection/Hardware_Injection_2016/', outputFile];
    fileID = fopen(outputFile, 'w');
    
    script_beginning = sprintf('%s\n\n%s\n%s\n\n', '#!/bin/bash',...
        'start_time=$(date +%s)', ...
        'echo "Running all ', inputFiles, ' scripts... "');
    
    fprintf(fileID, '%s', script_beginning);


    for row = 1:nrows
        fprintf(fileID, '%s%s\n', './', file_list{row, :});
    end
    
    script_ending = sprintf('\n\n%s\n\n%s\n%s\n%s\n', 'echo "Finished running all scripts"', ...
        'end_time=$(date +%s)', 'runtime=$((end_time-start_time))', ...
        'echo "Runtime: $runtime"');

    fprintf(fileID, '%s', script_ending);
    
    fclose(fileID);
    
    system(['chmod u+x ', fullpath]);
end