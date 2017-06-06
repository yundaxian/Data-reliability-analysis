% Title:        Resample sensor data based on input parameter
% Created by:   Leichen Dai
% Date:         Apr 6th,2017
% Notes:        This file read .mat file in ./case folder extract file with
%               same case name and resample to combine as one file
% no error support, or excel data.
function [] = resample_case(sample_base)
data_type = {'acc','gsr','hr','light'};
%# get all XLS files in case directory
CaseDirName = '.\case';
ResampleDir = ['.\resamp_' sample_base];
if 7 ~= exist(ResampleDir,'dir')
    mkdir(ResampleDir);
end

casefile = '.\case\case.mat';
casename = load(casefile);
for s=1:numel(casename.sheets)
    if strfind(casename.sheets{s}, 'S')
        casep = ['*' casename.sheets{s} '.mat'];
        cfiles = dir( fullfile(CaseDirName,casep) );
        cfiles = {cfiles.name};                      %
        %# for each input file
        for i=1:numel(cfiles)
            fname = fullfile(CaseDirName, cfiles{i});    %# absolute-path filename
            [~,f] = fileparts(fname);                    %# used to name sheets in output
            if strfind(f,'acc')
                acc = matfile(fname);
            elseif strfind(f,'gsr')
                gsr = matfile(fname);
            elseif strfind(f,'hr')
                hr = matfile(fname);
            elseif strfind(f,'light')
                light = matfile(fname);
            end
        end
        
        [ r_hr c_hr ] = size(hr.sheetdata);
        [ r_acc c_acc ] = size(acc.sheetdata);
        [ r_gsr c_gsr ] = size(gsr.sheetdata);
        [ r_light c_light ] = size(light.sheetdata);
        
        for b=1:numel(data_type)
            if strcmp(data_type{b},sample_base)
                target_type = ['r_' data_type{b}];
                target_num = eval(target_type);
            end
        end
        
        acc_sd = resample(acc.sheetdata, target_num, r_acc);
        acc_sd = clean_data(acc_sd);
        gsr_sd = resample(gsr.sheetdata, target_num, r_gsr);
        gsr_sd = clean_data(gsr_sd);
        hr_sd = resample(hr.sheetdata, target_num, r_hr);
        hr_sd = clean_data(hr_sd);
        light_sd = resample(light.sheetdata, target_num, r_light);
        light_sd = clean_data(light_sd);
        
        outfile = fullfile(ResampleDir,[casename.sheets{s} '.mat']);
        disp(outfile);
        save(outfile, 'acc_sd','gsr_sd','hr_sd','light_sd');
    end
end
end

function clean_sheet = clean_data(sheet)
last_row = 0;
clean_thr = 3;
[r c] = size(sheet);

for i=2:r
    if sheet(i-1,1) - sheet(i,1) > clean_thr 
        last_row = i - 1;
        break;
    end    
end

if last_row ~= 0
    clean_sheet = sheet(1:last_row,:);
else
    clean_sheet = sheet;
end

end
    