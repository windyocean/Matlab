function [] = name2dropbox(direction)
%% Reminder
% << 0 >> 
% if you want to deal with jpg, bmp and other else, please add the name of
% the type into the vector below
Check = string('jpg');
Check(2) = 'bmp';
% Check(3) = 'tiff';

% << 1 >>
% please write down the folder directory that has jpg files to be changed.
% For example, 
% >> name2dropbox('C:\Users\birdh\Desktop\hello')

% << 2 >>
% If jpg files are in the child-folder which is in the parent-folder,
% just type down the directory of the parent-folder into the input of the
% function. it will automatically find the all jpg files in the folder you
% designated as the input of the function 'name2dropbox'.

%% Coding
file_dir = dir(direction);
file_num  = length(file_dir);

for i = 1: file_num % for each image 
    
    % Only choose jpg files to change their names
    % If file exists, go into the files and re-change its jpg files name
    
    file_name = file_dir(i).name;
    
    if file_name ~= '.' % it means it is a folder so that recursively it will find the jpg/bmp/etc files.
        name2dropbox([file_dir(i).folder, '\', file_dir(i).name])
    % elseif length(file_name) >= 4 && strcmp(file_name((length(file_name)-2):length(file_name)),'jpg')
    elseif length(file_name) >= 3
        file_type = strsplit(file_name,'.');
        file_type = file_type(length(file_type));
        
        % To check whether format is jpg/bmp or not.
        flag = 0;
        for j = 1 : length(Check)
            if strcmp(Check(j), file_type)
                flag = 1;
            end
        end
        
        if flag == 1 % other formats(.pdf .word ... ) will not be processed.
            file_info = imfinfo([file_dir(i).folder, '\', file_dir(i).name]);

            if isfield(file_info, 'DateTime')
                photo_taken_time = file_info.DateTime;
                for j = 1 : length(photo_taken_time)
                    num = 0;
                    if num <= 2 && photo_taken_time(j) == ':'
                        photo_taken_time(j) = '-';
                        num = num + 1;
                    elseif num > 2 && photo_taken_time(j) == ':'
                        photo_taken_time(j) = '.';
                        num = num + 1;
                    end
                end

                cd(file_dir(i).folder);
                if strcmp(file_dir(i).name, [photo_taken_time, '.jpg'])
                    disp('No change. it is already corrected.')
                else
                    movefile(file_dir(i).name, [photo_taken_time, '.jpg']);
                end

            else
                display(file_dir(i).name, 'Fail because of non-existance of DateTime')
            end
        end
    end
end