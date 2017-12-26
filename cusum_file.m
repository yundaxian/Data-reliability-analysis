% Title:        Use CUSUM analysis data
% Created by:   Leichen Dai
% Date:         Apr 25th,2017
% Notes:        This file read .xlsx file in from data_dir folder and apply
% to CUSUM algorithm. Then pot detected change for each data type

function [] = cusum_file(data_dir)
%predefined CUSUM parameters
%CUSUM( x, h, k, window, d )
%CP_XXX = {'h','k','window','d'}
CP_acc = {0.5,  1, 5, 0.5};
CP_hr  = {0.1, 1, 5, 0.2}; 

%get all csv files in source directory
dirName = data_dir;

files = dir( fullfile(dirName,'*.xlsx') );
files = {files.name};                      
disp(files);

%# for each input file
for i=1:numel(files)
    fname = fullfile(dirName, files{i});    %# absolute-path filename
    [~,f] = fileparts(fname);               %# used to name sheets in output

    if strcmp('acc',f)
        acc_s = xlsread(fname);        
    elseif strcmp('hr',f)
        hr_s = xlsread(fname);
    end
end

%# Calculate CUSUM for givan signal
    [alarms_acc_x, nc_acc_x] = TwoCUSUM( log(acc_s(:,2)), CP_acc{1}, CP_acc{2}, CP_acc{3}, CP_acc{4});
    [alarms_acc_y, nc_acc_y] = TwoCUSUM( log(acc_s(:,3)),CP_acc{1}, CP_acc{2}, CP_acc{3}, CP_acc{4});
    [alarms_acc_z, nc_acc_z] = TwoCUSUM( log(acc_s(:,4)),CP_acc{1}, CP_acc{2}, CP_acc{3}, CP_acc{4});
    
    [alarms_acc, nc_hr] = TwoCUSUM( log(hr_s(1:10,2)), CP_hr{1}, CP_hr{2}, CP_hr{3}, CP_hr{4});
    
    figure
    subplot(4,1,1)
    plot(acc_s(:,1),nc_acc_x);
    title('Acc_X');

    subplot(4,1,2)
    plot(acc_s(:,1),nc_acc_y);
    title('Acc_Y');

    subplot(4,1,3)
    plot(acc_s(:,1),nc_acc_z);
    title('Acc_Z');

    subplot(4,1,4)
    plot(hr_s(:,1),nc_hr);
    title('HR');

figure
plot(hr_s(:,1), alarms_acc);
title('HR2');

