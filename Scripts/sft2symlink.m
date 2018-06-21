% Eilam Morag
% November 27, 2016
% sft2symlink: Creates a symbolic link to a given sft file and returns the
% name of the link.
% The symbolic link's name will be the timestamp of the sft, which should
% uniquely identify each sft.
function symlink = sft2symlink(sft_filepath, sft_name)
%     timestamp = sft_name(41:50);
%     symlink = timestamp;
    symlink = sft_name;
    symlink_path = ['/home/eilam.morag/hw_injection/Hardware_Injection_2016/scripts/', symlink];
    cmd = ['ln -s ', sft_filepath, ' ', symlink_path, ' >/dev/null 2>&1'];
    status = system(cmd);
end
