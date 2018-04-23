function [daily, cumul] = parseFStatFromAtoms(filename)
	fileID = fopen(filename);
	if (fileID == -1)
		daily = NaN;
		cumul = NaN;
		return;
	end
	discardLines(fileID, 2);
	line = strsplit(fgetl(fileID));
	if (isempty(line))
		daily = NaN;
		cumul = NaN;
	elseif (length(line) == 1)
		daily = NaN;
		cumul = str2double(line{1});
	else
		daily = str2double(line{1});
		cumul = str2double(line{2});
	end
	fclose(fileID);	
end
