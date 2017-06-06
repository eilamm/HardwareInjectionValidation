% Returns today's date as a Date object
function today = todayDate()
    str = date;
    components = strsplit(str, '-');
    d = str2num(components{1});
    m = components{2};
    y = str2num(components{3});
    
    if (strcmp(m, 'Jan'))
        m = 1;
    elseif (strcmp(m, 'Feb'))
        m = 2;
    elseif (strcmp(m, 'Mar'))
        m = 3;
    elseif (strcmp(m, 'Apr'))
        m = 4;
    elseif (strcmp(m, 'May'))
        m = 5;
    elseif (strcmp(m, 'Jun'))
        m = 6;
    elseif (strcmp(m, 'Jul'))
        m = 7;
    elseif (strcmp(m, 'Aug'))
        m = 8;
    elseif (strcmp(m, 'Sep'))
        m = 9;
    elseif (strcmp(m, 'Oct'))
        m = 10;
    elseif (strcmp(m, 'Nov'))
        m = 11;
    elseif (strcmp(m, 'Dec'))
        m = 12;
    else
        m = -1;
    end
    
    today = Date([m, d, y]);
end