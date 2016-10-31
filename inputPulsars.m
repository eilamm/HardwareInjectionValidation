% Eilam Morag
% October 29, 2016
% Input pulsars (0-14) to generate scripts for. An empty input (just
% pressing enter) will be interpreted as inputting all of the pulsars
% (0-14).
% Takes a vector input.
function pulsars = inputPulsars()
    pulsars = input('Pulsars: ');
    if (isempty(pulsars) == 1)
        pulsars = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14];        
    end
    % If any pulsar IDs are not in the range 0-14, reprompt for input
    while (all(pulsars <= 14) == 0 || all(pulsars >= 0) == 0)
       pulsars = input(['Pulsar IDs must be between 0 and 14. Please ', ...
           'enter again: ']);
    end
    % Gets rid of duplicates
    pulsars = unique(pulsars);
end