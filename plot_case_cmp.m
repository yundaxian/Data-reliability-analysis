% Title:        Use CUSUM analysis data
% Created by:   Leichen Dai
% Date:         Apr 25th,2017
% Notes:        This file read .mat file in ./resample_XXX folder and apply
% to CUSUM algorithm. Then pot detected change for each data type

function [] = plot_case_cmp(sample_base,case_name)
ResampleDir = ['.\resamp_' sample_base];
pfile = [case_name '.mat'];
pfname = fullfile(ResampleDir, pfile);
load(pfname);

[acc_s,gsr_s,hr_s,light_s] = preprocess(acc_sd,gsr_sd,hr_sd,light_sd);
 
[alarms_acc, nc_acc] = CUSUM( acc_s, 0.1, 1, 10, 0.1 );
[alarms_gsr, nc_gsr] = CUSUM( gsr_s, 0.15, 1, 10, 0.15);
[alarms_hr, nc_hr]   = CUSUM( hr_s,0.05, 1, 10, 0.06 );
[alarms_light, nc_light] = CUSUM( light_s,0.1, 1, 10, 0.1 );

figure_name = [case_name '_' sample_base];

figure('name',[figure_name '_acc'])
subplot(2,1,1)
plot(acc_sd(:,1),acc_sd(:,2),'b',acc_sd(:,1),acc_sd(:,3),'r',acc_sd(:,1),acc_sd(:,4),'g');
subplot(2,1,2)
plot(acc_sd(:,1),acc_s);

figure('name',[figure_name '_gsr'])
subplot(2,1,1)
plot(gsr_sd(:,1),gsr_sd(:,2));
subplot(2,1,2)
plot(gsr_sd(:,1),gsr_s);

figure('name',[figure_name '_hr'])
subplot(2,1,1)
plot(hr_sd(:,1),hr_sd(:,2));
subplot(2,1,2)
plot(hr_sd(:,1),hr_s);

figure('name',[figure_name '_light'])
subplot(2,1,1)
plot(light_sd(:,1),light_sd(:,2));
subplot(2,1,2)
plot(light_sd(:,1),light_s);

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

figure('name',[figure_name '_alarms'])
subplot(4,1,1)
plot(acc_sd(:,1),alarms_acc);
title('Acc');

subplot(4,1,2)
plot(gsr_sd(:,1),alarms_gsr);
title('Gsr');

subplot(4,1,3)
plot(hr_sd(:,1),alarms_hr);
title('HR');

subplot(4,1,4)
plot(light_sd(:,1),alarms_light);
title('Light');
