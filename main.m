% load nc toolbox for reading grb2 and netCDF - files
setup_nctoolbox;

% parameters
latitude  = 54;
longitude =  8;
nameOfCSVFile = 'csvDump.csv';

% excecute conversion
grb2ToCSV(latitude, longitude, nameOfCSVFile);