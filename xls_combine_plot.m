% Title:        Smart Watch Sensor data parse and plot
% Created by:   Leichen Dai
% Date:         July 5th,2017
% Notes:        This file read excel file in data-dir folder. And plot wave
%               form for every sensor data


function [] = xls_combine_plot(data_dir,sample_base)
%# get all XLS files in source directory
dirName = data_dir;
files = dir( fullfile(dirName,'*.xlsx') );
files = {files.name};                      %
disp(files);

%# for each input file, adjust time stamp, should be only one sheet per file
for i=1:numel(files)
    fname = fullfile(dirName, files{i});    %# absolute-path filename
    [~,f] = fileparts(fname);               %# used to name sheets in output

    [sheetdata] = xlsread(fname);    
    switch f
    case 'acc'
        acc_sd = sheetdata;
    case 'gsr'
        gsr_sd = sheetdata;
    case 'hr'
        hr_sd = sheetdata;
    case 'light'
        light_sd = sheetdata;
    otherwise
        disp('Unknow sensor data type found!')
    end

    %# write to output file as new sheet
    %outfile = fullfile(DirName,[f '.mat']);
    %disp(outfile);
    %save(outfile, 'sheetdata');
end    

%# resample sheet data based on sample_base
data_type = {'acc','gsr','hr','light'};

[ r_hr c_hr ] = size(hr_sd);
[ r_acc c_acc ] = size(acc_sd);
[ r_gsr c_gsr ] = size(gsr_sd);
[ r_light c_light ] = size(light_sd);

% Get resample target number
for b=1:numel(data_type)
    if strcmp(data_type{b},sample_base)
        target_type = ['r_' data_type{b}];
        target_num = eval(target_type);
    end
end

%resample and clean resample errors
acc_sd = resample(acc_sd, target_num, r_acc);
acc_sd = clean_data(acc_sd);

gsr_sd = resample(gsr_sd, target_num, r_gsr);
%disp(gsr_sd);
gsr_sd = clean_data(gsr_sd);
%disp(gsr_sd);

hr_sd = resample(hr_sd, target_num, r_hr);
hr_sd = clean_data(hr_sd);

light_sd = resample(light_sd, target_num, r_light);
light_sd = clean_data(light_sd);

function sheet = clean_data(sheet)
[r c] = size(sheet);

if sheet(1,1) < 0
    sheet(1,:) = [];
end
for j=2:r
    if sheet(j,1) < 0
        sheet(j,:) = [];
        break;
    end
    if sheet(j-1,1) > sheet(j,1)
        sheet(j,:) = [];
        break;
    end    
end

end

% Plot all four sensor data out
ptitle = [dirName ' based on sample rate of ' sample_base];
yleftlable = 'ACC\_GSR\_LIGHT';
yrightlable = 'HR';
figure_name = [dirName '_' sample_base '_sub'];

figure('name',figure_name);
subplot(4,1,1)
plot(acc_sd(:,1),abs(log(acc_sd(:,2))),'b',acc_sd(:,1),abs(log(acc_sd(:,3))),'b',acc_sd(:,1),abs(log(acc_sd(:,4))),'b');
title('Acc');

subplot(4,1,2)
plot(gsr_sd(:,1),log(gsr_sd(:,2)));
title('Gsr');

subplot(4,1,3)
plot(hr_sd(:,1),log(hr_sd(:,2)));
title('HR');

subplot(4,1,4)
plot(light_sd(:,1),log(light_sd(:,2)));
title('Light');

figure_name = [dirName '_' sample_base '_all'];
figure('name',figure_name);
yyaxis left
plot(acc_sd(:,1),abs(log(acc_sd(:,2))),'b',acc_sd(:,1),abs(log(acc_sd(:,3))),'b',acc_sd(:,1),abs(log(acc_sd(:,4))),'b');
hold on;

yyaxis left
plot(gsr_sd(:,1),log(gsr_sd(:,2)),'g');
hold on;

yyaxis left
plot(light_sd(:,1),log(light_sd(:,2)),'c');
hold on;

yyaxis right
plot(hr_sd(:,1),log(hr_sd(:,2)),'r');
hold on;

yyaxis left
title(ptitle);
ylabel(yleftlable);

yyaxis right
ylabel(yrightlable);
hold off

end
    