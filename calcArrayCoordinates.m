function [y, x] = calcArrayCoordinates(latitude, longitude)
    if (latitude == 0)
        y = 181;
    elseif (latitude > 0) 
        y = ((90-latitude)*2)+1;
    elseif (latitude < 0)
        y = 181 + (latitude * -1 * 2);
    end
    x = (longitude * 2) + 1;
        
 end