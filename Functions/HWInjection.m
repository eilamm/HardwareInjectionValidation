% Eilam Morag
% October 29, 2016
% This file will generate scripts that call the lalapps compute and predict
% functions on injected pulsars 0-14. It does so by calling the
% genScript_compute() and genScript_predict() functions. 
% This is the matlab version of the original C++ file, genScript.cpp.

function HWInjection(today, server) 
    %% Load pulsars, create output folder if necessary, and initialize the date range
    load('Pulsar-parameters/pulsars.mat', 'pulsar_list');
    today = todayDate();
    start = observationRunStartDate();
    for id = 0:14
        outputFolder = sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/output/Pulsar%d/%s', id, today.date2str_nospace()); 
        if (~exist(outputFolder, 'dir'))
            fprintf('Creating output folder:\n\t%s\n', outputFolder);
            mkdir(outputFolder);
        end
    end
    fprintf('%s%s\n', 'Creating scripts for ', today.date2str());

    num_days = today - start;

    %%%%%%%%%%%%%%%%%%%%% Create links to today's SFTs if none exist %%%%%%%%%%%%%%%%
    SFTdirToday = sprintf('scripts/_%s', today.date2str_num()); % Folder for symlinks for today's SFTs
    if (~exist(SFTdirToday))
        fprintf('Creating folder\n\t%s\n', SFTdirToday);
        mkdir(SFTdirToday);
        path = '';
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
    
        y = sprintf('%d', today.year);
        m = sprintf('%02d', today.month);
        d = sprintf('%02d', today.day);

        folder = dir(sprintf('%sfscans_%d_%02d_%02d*', path, today.year, today.month, today.day));
        path = sprintf('%s%s/%s/sfts/tmp/', path, folder.name, chan);
        filetype = [path, '*.sft'];

        folder = dir(filetype); % Structure containing all the sfts in directory
        numSFTs = length(folder);
        SFTduration = 1800;     % SFTs cover 30 min each (1800 seconds)
        % If there's no SFTs in a folder, or if there's too many (e.g. Feb 23,
        % 2017), then don't make a symlink for that folder
        if (numSFTs == 0 || numSFTs > 1000)
            % Do nothing
        fprintf('No sfts for date %02d/%02d/%d\n', today.month, today.day, today.year);
        else
            % Open Prof. Riles' injection timespan file for this day, get all injection timespans into an array
        fileID = fopen(sprintf('/home/pulsar/public_html/fscan/CWINJ_segs/%d_%02d_%02d_CWINJ_segments.txt', today.year, today.month, today.day));
        if (fileID == -1)
                fprintf('No injections on %s\n', today.date2str());
        else
            injections = cell2mat(textscan(fileID, '%d %d'));
            fclose(fileID);
            % Iterate through SFTs in the folder
            for i = 1:numSFTs
                % Read timespan of SFT (in name)
            % L-1_L1_1800SFT_Pulsar00-1165752380-1800.sft
                SFT = folder(i).name;
            timespan = str2double(SFT(41:50));
                
                    % If timespan is within range of any of the injection timespans, then create a symlink to it in the directory for this data
                        if (any((timespan >= injections(:, 1)) & ((timespan + SFTduration) <= injections(:, 2))))
                SFT_path = sprintf('%s%s', path, SFT);
                            symlink_path = sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/%s/%s', SFTdirToday, SFT);
                            cmd = ['ln -s ', SFT_path, ' ', symlink_path, ' >/dev/null 2>&1'];
                            status = system(cmd);
                        end
            end
        end
        end

    end

    %%%%%%%%%%%%%%%%%%%%% Gather the relevant SFTs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    date = start;
    sfts_cumulative = '';   % initialize string of SFT subdirectories
    sfts_daily = '';
    for ii = 1:num_days
        % Symlinks to SFTs for a specific date are stored in subdirectories named after said date.
    % sfts_cumulative is a string that concatenates the names for each of these directories, separated by a semicolon
    % Note that the scripts that end up using this string are in the same directory as the subdirectories, so
    % don't need to get their path, just their filenames

    % Check that there are SFTs for this date
    if (~isempty(dir(sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/_%s/*.sft', date.date2str_num()))))
        SFTs_current_date = sprintf('_%s/*.sft', date.date2str_num());
        % Check if this is the first non-empty SFT directory
        if (strcmp(sfts_cumulative, '' ) == 1)
            sfts_cumulative = SFTs_current_date;
        else
            sfts_cumulative = sprintf('%s;%s', sfts_cumulative, SFTs_current_date);
        end
    end
    
        % Increment the date
        date = date.next_day();
    end

    if (~isempty(dir(sprintf('/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/_%s/*.sft', today.date2str_num()))))
        sfts_daily = sprintf('_%s/*.sft', today.date2str_num());
    else
        sfts_daily = '';
    end

    


    %%%%%%%%%%%%%%%%%%%%% Create the LAL scripts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    sfts_cumulative = cumulativePoint(start, today, pulsar_list, server);
    for pulsar = pulsar_list
        lalapps_compute(pulsar, sfts_cumulative, today, 1, num_days, server);
        lalapps_predict(pulsar, sfts_cumulative, today, 1, server);
    end

%    sfts_daily = dailyPoint(today, pulsar_list, server);
    for pulsar = pulsar_list
        lalapps_compute(pulsar, sfts_daily, today, 0, 1, server);
        lalapps_predict(pulsar, sfts_daily, today, 0, server);
    end
    
end
