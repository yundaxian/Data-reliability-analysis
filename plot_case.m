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
yrightlable = '';
figure_name = [case_name '_' sample_base '_' a '_' g '_' h '_' l];

figure('name',figure_name,'NumberTitle','off');
if strcmp(a,'a')
    yyaxis left
 %   plot(acc_sd(:,1),abs(log(acc_sd(:,2))),'b',acc_sd(:,1),abs(log(acc_sd(:,3))),'b',acc_sd(:,1),abs(log(acc_sd(:,4))),'b');
 acc_x = abs(log(acc_sd(:,2)));
 acc_y = abs(log(acc_sd(:,3)));
 acc_z = abs(log(acc_sd(:,4)));
 acc_s = sgolayfilt(acc_x+acc_y+acc_z, 5, 9);
 
 acc_x = abs(log(sgolayfilt(acc_sd(:,2),5,9)));
 acc_y = abs(log(sgolayfilt(acc_sd(:,3),5,9)));
 acc_z = abs(log(sgolayfilt(acc_sd(:,4),5,9)));
 acc_s = acc_x + acc_y + acc_z;
% acc_r = abs(log(acc_s(:,2))) + abs(log(acc_s(:,3))) + abs(log(acc_s(:,4)));
% acc_s = smooth(acc_new);
% acc_r = reshaple(acc_s,length(acc_new),1);
 plot(acc_sd(:,1),acc_s,'b');   
 yleftlable = 'ACC';
    hold on;
end

if strcmp(h,'h')
    yyaxis left
    hr_s = sgolayfilt(hr_sd(:,2),5,9);
    plot(hr_sd(:,1),log(hr_s),'r');
    hold on
    plot(hr_sd(:,1),log(hr_sd(:,2)),'b');
    yleftlable = [yleftlable ' ' 'HR'];
    hold on;
end

if strcmp(g,'g')
    yyaxis right
    gsr_s = sgolayfilt(gsr_sd(:,2),5 ,9);
    gsr_p = log(gsr_s);
    plot(gsr_sd(:,1),gsr_p,'g');
    yrightlable = 'GSR';
    hold on;
end

if strcmp(l,'l')
    yyaxis left
    plot(light_sd(:,1),log(light_sd(:,2)),'c');
    yleftlable = [yleftlable ' ' 'LIGHT'];
    hold on;
end
    
yyaxis left
title(ptitle);
ylabel(yleftlable);

yyaxis right
ylabel(yrightlable);
hold off

%legend('acc_x','acc_y','acc_z','hr');

end
