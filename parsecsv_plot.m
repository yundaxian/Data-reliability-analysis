% Title:        Smart Watch Sensor data parse
% Created by:   Leichen Dai
% Date:         Aug 5th,2017
% Notes:        This file read csv file in data_dir folder. 
%               1. remove header line
%               2. convert date time to seconds and start with zero
%               3. write to xlsx file and plot the data
%               4. resample data based on given base
% no error support, or excel data.

%@Param: data_dir: Directory of folder to be processed
%@Param: sample_base: Sample base of all data type
%@Param: rhr: Real heart rate data to be plot

function [] = parsecsv_plot(data_dir,sample_base,rhr)
%convert time to seconds. 24*60*60=86400
TIMESWITCH = 86400;
%get all csv files in source directory
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
            acc_d = textscan(fid,'%s %s %s %f %f %f','Delimiter',',','HeaderLines',1); 
            ref = datenum([acc_d{1,2}{1,1} ' ' acc_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            acc_s = cell2mat([(datenum(strcat(acc_d{1,2},{' '},acc_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, acc_d(:,4:6)]);
            xlswrite(xlsx_file,acc_s);
        case 'gsr'
            gsr_d = textscan(fid,'%s %s %s %f','Delimiter',',','HeaderLines',1); 
            ref = datenum([gsr_d{1,2}{1,1} ' ' gsr_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            gsr_s = cell2mat([(datenum(strcat(gsr_d{1,2},{' '},gsr_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, gsr_d(:,4)]);
            xlswrite(xlsx_file,gsr_s);
        case 'hr'
            hr_d = textscan(fid,'%s %s %s %f %s','Delimiter',',','HeaderLines',1); 
            ref = datenum([hr_d{1,2}{1,1} ' ' hr_d{1,3}{1,1}],'mm/dd/yyyy HH:MM:SS.FFF');
            hr_s = cell2mat([(datenum(strcat(hr_d{1,2},{' '},hr_d{1,3}),'mm/dd/yyyy HH:MM:SS.FFF')-ref)*TIMESWITCH, hr_d(:,4)]);
            xlswrite(xlsx_file,hr_s);
        case 'light'
            light_d = textscan(fid,'%s %s %s %f','Delimiter',',','HeaderLines',1);
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

%# unique all data
acc_s = unique(acc_s,'rows');
gsr_s = unique(gsr_s,'rows');
hr_s = unique(hr_s,'rows');
light_s = unique(light_s,'rows');

%# resample sheet data based on sample_base
data_type = {'acc','gsr','hr','light'};

% Get resample target number
for b=1:numel(data_type)
    if strcmp(data_type{b},sample_base)
        target_type = [data_type{b} '_s'];        
        target_intp = eval([target_type '(:,1)']);
    end
end

%resample and clean resample errors
acc_sd = interp1(acc_s(:,1), acc_s, target_intp);

gsr_sd = interp1(gsr_s(:,1), gsr_s, target_intp);

hr_sd = interp1(hr_s(:,1), hr_s, target_intp);

light_sd = interp1(light_s(:,1), light_s, target_intp);

%if real heart rate is include
if strcmp(rhr,'rhr')
    rhr_file = fullfile(dirName, 'real_hr.xlsx');
    rhr_s = xlsread(rhr_file);
    rhr_sd = interp1(rhr_s(:,1), rhr_s,target_intp);
end

ptitle = [dirName ' based on sample rate of ' sample_base];
yleftlable = 'ACC\_GSR\_LIGHT';
yrightlable = 'HR';
figure_name = [dirName '_' sample_base '_sub'];

% Plot ACC and HR in one figure
figure('name',figure_name);
subplot(2,1,1)
plot(acc_sd(:,1),abs(log(acc_sd(:,2))),'b',acc_sd(:,1),abs(log(acc_sd(:,3))),'b',acc_sd(:,1),abs(log(acc_sd(:,4))),'b');
title('Acc');

% subplot(4,1,2)
% plot(gsr_sd(:,1),log(gsr_sd(:,2)));
% title('Gsr');

subplot(2,1,2)
plot(hr_sd(:,1),hr_sd(:,2));
title('HR');

% subplot(4,1,4)
% plot(light_sd(:,1),log(light_sd(:,2)));
% title('Light');

% Plot all four sensor data out in one figure
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
plot(hr_sd(:,1),hr_sd(:,2),'r');
hold on;

if strcmp(rhr,'rhr')
    yyaxis right
    plot(rhr_sd(:,1),rhr_sd(:,2),'k');
    hold on;
end

yyaxis left
title(ptitle);
ylabel(yleftlable);

yyaxis right
ylabel(yrightlable);
hold off

end

