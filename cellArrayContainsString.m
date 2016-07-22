%% cellArrayContainsString
%  iterates through 'cellArray' and returns 1 if 'string' is one of the
%  elements, otherwise it returns 0
function contains = cellArrayContainsString(cellArray, string)
    contains = 0;
    for i=1:length(cellArray)
        if (strcmp(cellArray{i},string) == 1) 
            contains = 1;
        end
    end
end