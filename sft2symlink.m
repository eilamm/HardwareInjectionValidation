% Eilam Morag
% November 27, 2016
% sft2symlink: Creates a symbolic link to a given sft file and returns the
% name of the link.
% The symbolic link's name will be the timestamp of the sft, which should
% uniquely identify each sft.
function symlink = sft2symlink(sft_filepath, sft_name)
    timestamp = sft_name(41:50);
    symlink = [timestamp, '.sft'];
    symlink_path = ['/home/eilam.morag/hw_injection/Hardware_Injection_2016/', symlink];
    cmd = ['ln -s ', sft_filepath, ' ', symlink_path];
%     status = system(cmd, '-echo');
    status = system(cmd);
%     if (status ~= 0)
%         error('%s\n%s%s\n%s%s', 'Symlink failed', 'sft filename: ', sft_filepath, 'symlink: ', symlink);
%     end
end