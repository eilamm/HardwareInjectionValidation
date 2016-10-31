% Eilam Morag
% October 29, 2016
% Pulsar class. Contains info about the injection parameter.

classdef Pulsar
    properties 
        id = -1;
        reftime = -1;
        f0 = -1;
        fdot = -1;
        aplus = -1;
        across = -1;
        psi = -1;
        delta = -1; % Declination
        alpha = -1; % Ascension
    end
    methods
        % Constructor
        function p = Pulsar(id)
            % Assign the ID to the pulsar, if in range
            if (id > 14 || id < 0)
                error(['Pulsar ID is not in range: ', id]);
            end
            p.id = id;
            % Initialize the pulsar parameters 
            p = p.init();
        end
        
        % getData: grabs the relevant injection data from Professor Riles'
        % files, opened by init
        function p = getData(p, fileID)
            % Each injection has 20 lines of data, starting at line 25. sod
            % is start of useful data
            sod = 25 + p.id*20;
            discardLines(fileID, sod);
            id_in = parseData(fileID);
            if (id_in ~= p.id)
                error(['Retrieved pulsar ID is incorrect: ', ...
                        'Pulsar.getData() has read ', num2str(id_in), ...
                        ' instead of expected ', num2str(p.id), ...
                        '. Aborting.']);
            end
            p.reftime = parseData(fileID);
            p.f0 = parseData(fileID);
            p.fdot = parseData(fileID);
            discardLines(fileID, 2);
            p.aplus = parseData(fileID);
            p.across = parseData(fileID);
            discardLines(fileID, 4);
            p.psi = parseData(fileID);
            discardLines(fileID, 2);
            p.delta = parseData(fileID);
            p.alpha = parseData(fileID);
        end
        
        % parseData: grabs a line from the file, splits it by white space,
        % grabs the middle value (the data), and returns it as a double.
        function data = parseData(fileID)
            line = strsplit(fgetl(fileID));
            data = str2double(line(2));
        end
        
        % discardLines: discards n numberr of lines while reading a
        % text file
        function discardLines(fileID, n)
            for i=0:1:n
                fgetl(fileID);
            end
        end
        
        % init: initializes the pulsar injection parameters.  
        function p = init(p)
            file = '/home/keithr/public_html/cw/O2_H1_test1_injection_params_O2_H1_test1.html';
            fileID = fopen(file);
            p = p.getData(fileID);
            fclose(fileID);
        end
        
    end
end