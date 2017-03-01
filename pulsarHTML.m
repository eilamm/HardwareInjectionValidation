% Generates the webpage for a given pulsar 
function pulsarHTML(date, i)
    %% Initializing variables
    if (i < 10)
        pulsar = ['Pulsar 0', num2str(i)];
        nospace = ['Pulsar0', num2str(i)];        
    else
    	pulsar = ['Pulsar ', num2str(i)];
        nospace = ['Pulsar', num2str(i)];
    end
    
    server = getServerName();
    if (strcmp(server, 'L1'))
        host = 'LLO';
    else
        host = 'LHO';
    end
    
    title = [pulsar, ': ', host];
    
    path = sprintf('%s', '/home/eilam.morag/public_html/HWInjection/', ...
        nospace, '/');
    current = sprintf('%s', path, 'current/');
    plot_c = sprintf('%s', current, date, '_c.png');
    plot_d = sprintf('%s', current, date, '_d.png');
    
    %% HTML text
    text = sprintf('%s', '<!DOCTYPE html>\n', ...
            '<html>\n', ...
            '<head>\n', ...
            '    <title>', title, '</title>\n', ...
            '    <meta charset="utf-8"/>\n', ...
            '</head>\n', ...
            '<body>\n', ...
            '    <h1>\n', ...
            '    ', title, '\n', ...
            '    </h1>\n', ...
            '    <div class="date">\n', ...
            '        <h2>\n', ...
            '            Dates\n', ...
            '        </h2>\n', ...
            '        <ul>\n', ...
            '            <?php\n', ...
            '                $dirs = scandir("', path, '");\n', ...
            '                foreach ($dirs as $key => $folder) {\n', ...  
            '                if ($key > 1 && fnmatch("*.css", $folder) == ', ...
                                'FALSE && fnmatch("*.php", $folder) == FALSE) {\n', ...
            '                        echo "<p onclick=\\"changeDate(''$folder'')\\">$folder</p>";\n', ...
            '                }\n', ...
            '            ?>\n', ...
            '        </ul>\n', ...
            '    </div>\n', ...
            '    <div class = "data">\n', ...
            '        <img id="plot_c" src="', plot_c, '"/>\n', ...
            '        <img id="plot_d" src="', plot_d, '"/>\n', ...
            '    </div>\n', ...
            '<script type="text/javascript">\n', ...
            '    function changeDate(date) {\n', ...
            '        var folder = base.concat(date, "/", date);\n', ...
            '        var plot_c = folder.concat("_c.png");\n', ...
            '        var plot_d = folder.concat("_d.png");\n', ...
            '        document.getElementById("plot_c").src = plot_c;\n', ...
            '        document.getElementById("plot_d").src = plot_d;\n', ...
            '    };\n', ...
            '</script>', ...
            '</body>\n', ...
            '</html>' );
    
    %% Saving the file
    filename = sprintf('%s', path, nospace, '.php');
    fileID = fopen(filename, 'w');
    fprintf(fileID, text);
    fclose(fileID);
end