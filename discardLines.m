% Eilam Morag
% October 29, 2016
% discardLines: discards n numberr of lines while reading a
% text file
function discardLines(fileID, n)
    for i=1:1:n
        fgetl(fileID);
    end
end