%% calcArrayCoordinates
%  calcArrayCoordinates converts the geographic coordinates latitude and 
%  longitude to the y and x indexes in the data-array within the grib-file
%  
%  PLEASE NOTICE THE STRUCTURE OF THE GEOGRAPHIC COORDINATES AND THE 
%  STRUCTURE OF A GRIB2-DATA-ARRAY: 
% 
%  GEOGRAPHIC COORDINATES :
%  latitude :               NORTH   ( 90° )
%                	         ^
%       	    	         |	
%  longitude :  WEST <-------------> EAST
% 	                ( 0° )	 |      ( 360° )
% 	                         v	
%           	            SOUTH   ( -90° )
%
%  DATA-ARRAY:
% 
%  dimensions are [361x720] :
%                 [90° - -90°  x 0° - 360°] in half degree steps
%                 [index 1-361 x index 1 bis 720]
% 
% 
%   [temp0.0_+90.0 temp0.5_+90.0 ..... temp359.5_+90.0 temp360.0_+90.0]
%   [temp0.0_+89.5 temp0.5_+89.5 ..... temp359.5_+89.5 temp360.0_+89.5]
%   [      .              .                    .              .       ]
%   [      .              .                    .              .       ]
%   [temp0.0_+0.0  temp0.5_+0.0  ..... temp359.5_+0.0  temp360.0_+0.0 ]
%   [      .              .                    .              .       ]
%   [      .              .                    .              .       ]
%   [temp0.0_-89.5 temp0.5_-89.5 ..... temp359.5_-89.5 temp360.0_-89.5]
%   [temp0.0_-90.0 temp0.5_-90.0 ..... temp359.5_-90.0 temp360.0_-90.0]
%
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