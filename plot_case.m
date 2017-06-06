% Title:        Resample sensor data based on input parameter
% Created by:   Leichen Dai
% Date:         Apr 6th,2017
% Notes:        This file read .mat file in ./case folder extract file with
%               same case name and resample to combine as one file
% no error support, or excel data.
function [] = plot_case(sample_base,case_name,a,g,h,l)
gsr_scale = 15;
light_scale = 3;
ResampleDir = ['.\resamp_' sample_base];
pfile = [case_name '.mat'];
pfname = fullfile(ResampleDir, pfile);
load(pfname);
ptitle = [case_name ' based on sample rate of ' sample_base];
yleftlable = '';

figure;
if strcmp(a,'a')
    plot(acc_sd(:,1),acc_sd(:,2),'b',acc_sd(:,1),acc_sd(:,3),'b',acc_sd(:,1),acc_sd(:,4),'b');
    yleftlable = 'ACC';
    hold on;
end

if strcmp(h,'h')
    plot(hr_sd(:,1),hr_sd(:,2),'r');
    yleftlable = [yleftlable ' ' 'HR'];
    hold on;
end

if strcmp(g,'g')
    plot(gsr_sd(:,1),gsr_sd(:,2)/gsr_scale,'g');
    yleftlable = [yleftlable ' ' 'GSR'];
    hold on;
end

if strcmp(l,'l')
    plot(light_sd(:,1),light_sd(:,2)/light_scale,'c');
    yleftlable = [yleftlable ' ' 'LIGHT'];
    hold on;
end
    
title(ptitle);
ylabel(yleftlable);
hold off

%legend('acc_x','acc_y','acc_z','hr');

end