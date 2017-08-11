% Title:        Smart Watch Sensor data parse
% Created by:   Leichen Dai
% Date:         Aug 5th,2017
% Notes:        This file read csv file in data_dir folder. 
%               1. remove header line
%               2. convert date time to seconds
%               3. write to xlsx file and plot the data
%               4. resample data based on given base
% no error support, or excel data.

function [] = parsecsv(data_dir,sample_base)
%convert time to seconds. 24*60*60=86400
TIMESWITCH = 86400;
%# get all csv files in source directory
dirName = data_dir;

files = dir( fullfile(dirName,'*.csv') );
files = {files.name};                      %
disp(files);

%# for each input file
for i=1:numel(files)
    fname = fullfile(dirName, files{i});    %# absolute-path filename
    [~,f] = fileparts(fname);               %# used to name sheets in output
    fid = fopen(fname);
    xlsx_file = fullfile(dirName,[f '.xlsx']);
    if fid>0
        switch f
        case 'acc'
            acc_d = textscan(fid,'%d %s %s %f %f %f','Delimiter',',','HeaderLines',1); 
            ref = datenum([acc_d{1,2}{1,1} ' ' acc_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            acc_s = cell2mat([(datenum(strcat(acc_d{1,2},{' '},acc_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, acc_d(:,4:6)]);
            xlswrite(xlsx_file,acc_s);
        case 'gsr'
            gsr_d = textscan(fid,'%d %s %s %f','Delimiter',',','HeaderLines',1); 
            ref = datenum([gsr_d{1,2}{1,1} ' ' gsr_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            gsr_s = cell2mat([(datenum(strcat(gsr_d{1,2},{' '},gsr_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, gsr_d(:,4)]);
            xlswrite(xlsx_file,gsr_s);
        case 'hr'
            hr_d = textscan(fid,'%d %s %s %f %s','Delimiter',',','HeaderLines',1); 
            ref = datenum([hr_d{1,2}{1,1} ' ' hr_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            hr_s = cell2mat([(datenum(strcat(hr_d{1,2},{' '},hr_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, hr_d(:,4)]);
            xlswrite(xlsx_file,hr_s);
        case 'light'
            light_d = textscan(fid,'%d %s %s %f','Delimiter',',','HeaderLines',1);
            ref = datenum([light_d{1,2}{1,1} ' ' light_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            light_s = cell2mat([(datenum(strcat(light_d{1,2},{' '},light_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, light_d(:,4)]);
            xlswrite(xlsx_file,light_s);
        otherwise
            disp(['Skip file:' files{i}])
        end
 
     % close the file
     fclose(fid);
     % do stuff
    end
end

%# resample sheet data based on sample_base
data_type = {'acc','gsr','hr','light'};

[ r_hr c_hr ] = size(hr_s);
[ r_acc c_acc ] = size(acc_s);
[ r_gsr c_gsr ] = size(gsr_s);
[ r_light c_light ] = size(light_s);

% Get resample target number
for b=1:numel(data_type)
    if strcmp(data_type{b},sample_base)
        target_type = ['r_' data_type{b}];
        target_num = eval(target_type);
    end
end

%resample and clean resample errors
acc_sd = resample(acc_s, target_num, r_acc);
acc_sd = clean_data(acc_sd);

gsr_sd = resample(gsr_s, target_num, r_gsr);
%disp(gsr_sd);
gsr_sd = clean_data(gsr_sd);
%disp(gsr_sd);

hr_sd = resample(hr_s, target_num, r_hr);
hr_sd = clean_data(hr_sd);

light_sd = resample(light_s, target_num, r_light);
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

