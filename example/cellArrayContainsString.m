function contains = cellArrayContainsString(cellArray, string)
    contains = 0;
    for i=1:length(cellArray)
        if (strcmp(cellArray{i},string) == 1) 
            contains = 1;
        end
    end
end