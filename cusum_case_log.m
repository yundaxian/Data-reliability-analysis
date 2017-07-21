% Title:        Use CUSUM analysis data
% Created by:   Leichen Dai
% Date:         Apr 25th,2017
% Notes:        This file read .mat file in ./resample_XXX folder and apply
% to CUSUM algorithm. Then pot detected change for each data type

function [] = cusum_case_log(sample_base,case_name)
ResampleDir = ['.\resamp_' sample_base];
pfile = [case_name '.mat'];
pfname = fullfile(ResampleDir, pfile);
load(pfname);

figure_name = [case_name '_' sample_base];
%acc_s = sgolayfilt(acc_sd(:,2), 5, 9);
%acc_r = abs(log(acc_s));
acc_s = abs(log(acc_sd(:,2)));
acc_r = sgolayfilt(acc_s, 5 ,9);
[alarms_acc, nc_acc] = CUSUM( acc_r, 0.1, 1, 5, 0.2 );
[alarms_gsr, nc_gsr] = CUSUM( log(gsr_sd(:,2)), 0.1, 1, 5, 0.15);
[alarms_hr, nc_hr] = CUSUM(log(hr_sd(:,2)),0.05, 1, 5, 0.06 );
[alarms_light, nc_light] = CUSUM( log(light_sd(:,2)),0.1, 5, 5, 0.1 );

figure('name',[figure_name '_all'])
subplot(4,1,1)
plot(acc_sd(:,1),nc_acc);
title('Acc');

subplot(4,1,2)
plot(gsr_sd(:,1),nc_gsr);
title('Gsr');

subplot(4,1,3)
plot(hr_sd(:,1),nc_hr);
title('HR');

subplot(4,1,4)
plot(light_sd(:,1),nc_light);
title('Light');

figure('name',[figure_name '_gsr'])
subplot(4,1,1)
plot(gsr_sd(:,1),log(gsr_sd(:,2)));
title('gsr');

subplot(4,1,2)
plot(gsr_sd(:,1),nc_gsr);
title('Gsr');

subplot(4,1,3)
plot(hr_sd(:,1),nc_hr);
title('HR');

subplot(4,1,4)
plot(hr_sd(:,1),log(hr_sd(:,2)));
title('hr');