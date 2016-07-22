%% function grb2ToCSV
%  This function can convert all grib2 files within the same directory 
%  like this file to one CSV-file (comma-separated-value text file). 
%  The CSV-file is named like the parameter "nameOfCSVFile_" and is created
%  in the same folder like this file.
%  
%  The CSV-file only contains the data of the coordinates "latitude_" and 
%  "longitude_" and only prints values of the variables which are defined 
%  at "relevantVars" in line 65.
%  
%  The CSV-file has the structure : 
%  timestamp, nameOfVariable, value
%
%  The timestamp is automatically retrieved from the file-name. 
%  A file name like : gfs_4_20140819_0000_006.grb2 leads to a 
%  time stamp like  : 19-Aug-2014 06:00:00
%
%  PLEASE NOTICE THAT THE NAMING OF THE GRB2 MUST HAVE THE STRUCTURE
%  gfs_4_20140819_0000_006.grb2
%  with 
%    gfs_4_   = just an unimportant string
%    20140819 = date of forecast in YYYYMMDD
%    _        = unimportant char
%    0000     = hours, when forecast was created
%    _        = unimportant char
%    006      = hour of forecast (number of hours after hours, when
%                                 forecast was created)
%  
%  FOR EXAMPLE : 
%  if latitude_ = 54 and longitude_ = 8 and
%     relevantVars = [{'Temperature_height_above_ground';
%                 'Relative_humidity_height_above_ground'}]
%     and the current directory contains the following grb2 files:
%       gfs_4_20140819_0000_000.grb2
%       gfs_4_20140819_0000_003.grb2
%       gfs_4_20140819_0000_006.grb2
%       gfs_4_20140819_0000_009.grb2
%       gfs_4_20140819_0000_012.grb2
%       gfs_4_20140819_0000_015.grb2
%       gfs_4_20140819_0000_018.grb2
%
%  a CSV-file is created like 
%  19-Aug-2014 00:00:00, Temperature_height_above_ground      ,     289.30
%  19-Aug-2014 00:00:00, Relative_humidity_height_above_ground,      70.80
%  19-Aug-2014 03:00:00, Temperature_height_above_ground      ,     288.70
%  19-Aug-2014 03:00:00, Relative_humidity_height_above_ground,      70.20
%  19-Aug-2014 06:00:00, Temperature_height_above_ground      ,     288.20
%  19-Aug-2014 06:00:00, Relative_humidity_height_above_ground,      73.00
%  19-Aug-2014 09:00:00, Temperature_height_above_ground      ,     288.20
%  19-Aug-2014 09:00:00, Relative_humidity_height_above_ground,      75.60
%  19-Aug-2014 12:00:00, Temperature_height_above_ground      ,     288.50
%  19-Aug-2014 12:00:00, Relative_humidity_height_above_ground,      74.00
%  19-Aug-2014 15:00:00, Temperature_height_above_ground      ,     289.30
%  19-Aug-2014 15:00:00, Relative_humidity_height_above_ground,      66.50
%  19-Aug-2014 18:00:00, Temperature_height_above_ground      ,     288.80
%  19-Aug-2014 18:00:00, Relative_humidity_height_above_ground,      72.20
function grb2ToCSV(latitude_, longitude_, nameOfCSVFile_)  
    % init
    lat  = latitude_ 
    long = longitude_ 
    nameOfCSVFile = nameOfCSVFile_ %'dump.csv'

    relevantVars = [{'Temperature_height_above_ground';
                     'Relative_humidity_height_above_ground'}]

    % get current path
    pathOfFile = mfilename('fullpath');
    [pathOfFolder,name,ext] = fileparts(pathOfFile);

    % iterate through all files in directory
    path = strcat(pathOfFolder, '/*.grb2');

    % create csv - file
    fileID = fopen(strcat(pathOfFolder,strcat('/',nameOfCSVFile)),'w');

    files = dir(path);
    size = length(files);
    filenumber = 0;
    for file = files'
        % extract date-time from file-name
        file_name = file.name;
        [pathFile,name,ext] = fileparts(file_name);
        date  = name(7:14); 
        hours = name(21:23);
        dateAndHourString = strcat(date,hours);
        timeStamp = datetime(dateAndHourString,'InputFormat','yyyyMMddHHH');

        % get geo-datasets (data arrays for all variables)
        nc=ncgeodataset(strcat(strcat(pathOfFolder,'/'),file_name));    

        % iterate through variables
        vars = nc.variables;
        for i=1:length(vars)
            var = vars{i};

            % check if variable is relevant
            if (cellArrayContainsString(relevantVars, var) == 1) 

                % get data array for variable
                data = nc.data(var);
                % get dataPoint of needed coordinates
                [y,x] = calcArrayCoordinates(lat,long);
                dataPoint = data(:,:,y,x); 
                % merge data into matrix
                timeStampString = char(timeStamp);
                fprintf(fileID,'%s, %s, %10.2f\n',timeStampString,var,dataPoint);
            end
        end
        filenumber = filenumber + 1;
        fprintf('processed file %u/%u \n',filenumber, size) 
    end

    fclose(fileID);
    deleteTemporaryFiles;
end