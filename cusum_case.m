% Title:        Use CUSUM analysis data
% Created by:   Leichen Dai
% Date:         Apr 25th,2017
% Notes:        This file read .mat file in ./resample_XXX folder and apply
% to CUSUM algorithm. Then pot detected change for each data type

function [] = cusum_case(sample_base,case_name)
ResampleDir = ['.\resamp_' sample_base];
pfile = [case_name '.mat'];
pfname = fullfile(ResampleDir, pfile);
load(pfname);

[alarms_acc, nc_acc] = CUSUM( acc_sd(:,2), 1, 5, 10, 1 );
[alarms_gsr, nc_gsr] = CUSUM( gsr_sd(:,2), 2, 5, 40, 10 );
[alarms_hr, nc_hr] = CUSUM(hr_sd(:,2), 2, 5, 20, 1 );
[alarms_light, nc_light] = CUSUM( light_sd(:,2), 2, 5, 20, 2 );

figure
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
