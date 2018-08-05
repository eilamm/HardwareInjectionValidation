function firstRunInit()
    %% If the scripts folder does not exist, create it, along with all the scripts inside it
    folder = getLALScriptsLocation();
    if (~exist(folder, 'dir'))
        disp('First time initializations...');
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
        % Add the functions for creating the runAll scripts
    end
    clear folder
    %% If the output folder does not exist, create it
    folder = getFstatFileLocation();
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
    end
    clear folder
    %% If the atoms folder does not exist, create it
    folder = sprintf('%s/Atoms', getProjectHomeLocation());
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
	subdir = sprintf('%s/daily', folder);
        disp(['Creating the folder: ', subdir]);
	mkdir(subdir);
	for i = 0:14
		pulsar = sprintf('%s/Pulsar%d', subdir, i);
        	disp(['Creating the folder: ', pulsar]);
		mkdir(pulsar);
	end
	subdir = sprintf('%s/cumulative', folder);
        disp(['Creating the folder: ', subdir]);
	mkdir(subdir);
	for i = 0:14
		pulsar = sprintf('%s/Pulsar%d', subdir, i);
        	disp(['Creating the folder: ', pulsar]);
		mkdir(pulsar);
	end
    end
    clear folder subdir pulsar
    %% If the HWInjection folder does not exist, create it and pulsar subdirs
    folder = getWebsiteLocation();
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
        for i = 0:1:14
            if (i < 10)
                pulsar = sprintf('%s%s%d%s', folder, '/Pulsar0', i);
            else
                pulsar = sprintf('%s%s%d%s', folder, '/Pulsar', i);
            end
            mkdir(pulsar, 'current');
        end
    end
    clear folder pulsar
    %% If the main webpage does not exist, create it
    homepage = sprintf('%s/HWInjection.html', getWebsiteLocation());
    if (~exist(homepage, 'file'))
        disp(['Creating the homepage: ', homepage]);
        homepageHTML2();
        homepageCSS();
    end
    if (~exist('Pulsar-parameters/pulsars.mat'))
    	disp('Saving pulsar information to variable pulsar_list in Pulsar-parameters/pulsars.mat');
        for i = 0:14
	        pulsar_list(i + 1) = Pulsar(i);
        end
        save('Pulsar-parameters/pulsars.mat', 'pulsar_list');    
    end

    if (~exist('Logs', 'dir'))
        disp('Creating Logs directory')
        mkdir('Logs');
    end
    updateWebpages();
end
