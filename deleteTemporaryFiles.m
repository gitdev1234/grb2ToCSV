%% deleteTemporaryFiles
%  deletes all (by MATLAB created) .grb2.*-files, which are only need 
%  temporaryly. 
%  For example files like :
%    gfs_4_20140819_0000_000.grb2.gbx9
%    gfs_4_20140819_0000_000.grb2.ncx
%
function deleteTemporaryFiles
    % get current path
    pathOfFile = mfilename('fullpath');
    [pathOfFolder,name,ext] = fileparts(pathOfFile);

    % iterate through all files in directory
    path = strcat(pathOfFolder, '/*.grb2.*');

    files = dir(path);
    for file = files'
        file_name = file.name;
        completePathOfFile = strcat(pathOfFolder,strcat('/',file_name));
        delete(completePathOfFile);
    end
end