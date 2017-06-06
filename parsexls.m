% Title:        Smart Watch Sensor data parse
% Created by:   Leichen Dai
% Date:         Apr 5th,2017
% Notes:        This file read excel file in ./data folder. And read every 
%               worksheet as a seprate .mat file under ./case folder named as
%               filename_sheetname.mat
% no error support, or excel data.

TIMESWITCH = 86400;
%# get all XLS files in source directory
dirName = '.\data';
CaseDirName = '.\case';
if 7 ~= exist(CaseDirName,'dir')
    mkdir(CaseDirName);
end


files = dir( fullfile(dirName,'*.xlsx') );
files = {files.name};                      %
disp(files);

%# for each input file
for i=1:numel(files)
    fname = fullfile(dirName, files{i});    %# absolute-path filename
    [~,f] = fileparts(fname);               %# used to name sheets in output

    %# loop over each sheet in input file
    [~,sheets] = xlsfinfo(fname);
    outfile = fullfile(CaseDirName,'case.mat');
    if 2 ~= exist(outfile,'file')
        save(outfile,'sheets');
    end
    
    for s=1:numel(sheets)
        %# read content
        if strfind(sheets{s}, 'S')
            [sheetdata] = xlsread(fname, sheets{s});
            time_base = sheetdata(1,1)*TIMESWITCH;
            sheetdata(:,1) = sheetdata(:,1)*TIMESWITCH - time_base;        
            %# write to output file as new sheet
            outfile = fullfile(CaseDirName,[f '_' sheets{s} '.mat']);
            disp(outfile);
            save(outfile, 'sheetdata');
        end
    end
end

