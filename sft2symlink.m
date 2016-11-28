% Eilam Morag
% November 27, 2016
% sft2symlink: Creates a symbolic link to a given sft file and returns the
% name of the link.
% The symbolic link's name will be the timestamp of the sft, which should
% uniquely identify each sft.
function symlink = sft2symlink(sft_filepath, sft_name)
    timestamp = sft_name(40:50);
    symlink = ['/home/eilam.morag/hw_injection/Hardware_Injection_2016/', timestamp];
    cmd = ['ln -s ', sft_filepath, ' ', symlink];
    status = system(cmd, '-echo');
    if (status ~= 0)
        error('%s\n%s%s\n%s%s', 'Symlink failed', 'sft filename: ', sft_name, 'symlink: ', symlink);
    end
    % Make the return string just the timestamp, because we can call just
    % that in the scripts
    symlink = timestamp;
end