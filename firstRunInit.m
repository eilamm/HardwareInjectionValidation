function firstRunInit()
    %% If the scripts folder does not exist, create it, along with all the scripts inside it
    folder = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts';
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
        % Add the functions for creating the runAll scripts
    end
    clear folder
    %% If the output folder does not exist, create it
    folder = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/output';
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
    end
    clear folder
    %% If the HWInjection folder does not exist, create it and pulsar subdirs
    folder = '/home/eilam.morag/public_html/HWInjection';
    if (~exist(folder, 'dir'))
        disp(['Creating the folder: ', folder]);
        mkdir(folder);
        for i = 0:1:13
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
    homepage = '/home/eilam.morag/public_html/HWInjection/HWInjection.php';
%     if (~exist(homepage, 'file'))
        disp(['Creating the homepage: ', homepage]);
        homepageHTML();
        homepageCSS();
%     end
end