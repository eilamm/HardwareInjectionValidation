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
        iota = -1;
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
        
        % getData: grabs the relevant injection data for O2 from Professor 
        % Riles' files, opened by init
        function p = getData_O2(p, fileID)
            % Each injection has 20 lines of data, starting at line 25. sod
            % is start of useful data
            sod = 24 + p.id*20;
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
            discardLines(fileID, 3);
            p.iota = parseData(fileID);
            p.psi = parseData(fileID);
            discardLines(fileID, 2);
            p.delta = parseData(fileID);
            p.alpha = parseData(fileID);
        end        
        
        % getData: grabs the relevant injection data for O1 from Professor 
        % Riles' files, opened by init. The reason two functions are needed
        % is because the parameter file for O2 and O1 is formatted slightly
        % differently.
        function p = getData_O1(p, fileID)
            % Each injection has 20 lines of data, starting at line 25. sod
            % is start of useful data
            sod = 22 + p.id*18;
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
            discardLines(fileID, 2);
            p.psi = parseData(fileID);
            discardLines(fileID, 2);
            p.delta = parseData(fileID);
            p.alpha = parseData(fileID);
        end        
        % init: initializes the pulsar injection parameters. 
        % TO RETURN TO O2 DATA:
        function p = init(p)
            basepath = '/home/eilam.morag/hw_injection/Hardware_Injection_2016/Pulsar-parameters';
            file = [basepath, 'O2_H1_test1_injection_params_O2_H1_test1.html'];
%             file = [basepath, 'ER8B_injection_params_ER8B.html'];
            fileID = fopen(file);
            if (fileID == -1)
                error(['file could not be opened: ', file]);
            end
            p = p.getData_O2(fileID);
%             p = p.getData_O1(fileID);
            fclose(fileID);
        end
        
        %% Print functions
        % returns string of info on pulsar, for webpages
        function str = pulsar2strWebpage(p)
            i = p.id;
            if (i < 10)
                pulsar = ['Pulsar 0', num2str(i)];
            else
                pulsar = ['Pulsar ', num2str(i)];
            end
            t = cos(p.iota);
            str = sprintf('%s%s%.4f%s%.4e%s%.3f', pulsar, ' - Frequency: ', ...
                p.f0, '; Spindown: ', p.fdot, '; cos(iota): ', t);
             
        end
    end
end