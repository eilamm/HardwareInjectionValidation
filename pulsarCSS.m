% Stylesheet for the Pulsars' HTML pages
function pulsarCSS(path)
    text = sprintf('%s', '' ,...
    '.header {\n', ...
            'text-align: center;\n', ...
            'font-family: Helvetica;\n', ...
    '}\n', ...
    'h1 {\n', ...
            'text-align: center;\n', ...
            'font-family: Helvetica;\n', ...
    '}\n', ...
    '.date {\n', ...
            'text-align: center;\n', ...
            'font-family: Helvetica;\n', ...
    '}\n');

    filename = [path, 'pulsar.css'];
    fileID = fopen(filename, 'w');
    fprintf(fileID, text);
    fclose(fileID);
end