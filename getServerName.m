% Checks current host server (either Livingston or Hanford). 
% Returns either 'L1' or 'H1' as a string. This is used with the -IFO tag
% in the lalapps scripts
function server = getServerName()
    [~, temp] = system('dnsdomainname');
    if (temp == 'ligo-la.caltech.edu')
        server = 'L1';
    elseif  (temp== 'ligo-wa.caltech.edu')
        server = 'H1';
    else
        server = 'INVALID SERVER NAME';
    end
end