% Eilam Morag
% November 27, 2016
% sft2symlink: Creates a symbolic link to a given sft file and returns the
% name of the link.
% The symbolic link's name will be the timestamp of the sft, which should
% uniquely identify each sft.
function symlink = sft2symlink(sft_name)
    symlink = sft_name(40:50);
    cmd = ['ln -s ', sft_name, ' ', symlink];
    status = system(cmd, '-echo');
    if (status ~= 0)
        error('%s\n%s%s\n%s%s', 'Symlink failed', 'sft filename: ', sft_name, 'symlink: ', symlink);
    end
end