% Title:        Use cross-correlation analysis data
% Created by:   Leichen Dai
% Date:         June 25th,2017
% Notes:        This file read .mat file in ./resample_XXX folder and apply
% to cross-correlation algorithm to find similarity and delay.
% Then pot detected change for each pair

function [] = xcross_case(sample_base,case_name,sig)
ResampleDir = ['.\resamp_' sample_base];
pfile = [case_name '.mat'];
pfname = fullfile(ResampleDir, pfile);
load(pfname);

switch sig
    case 'a'
        sig_cmp = acc_sd;
        t_cmp = "ACC";
    case 'g'
        sig_cmp = gsr_sd;
        t_cmp = "GSR";
    case 'l'
        sig_cmp = light_sd;
        t_cmp = "LIGHT";
    otherwise
        disp('Sensor type not found');
        exit;
end

[acor,lag] = xcorr(hr_sd(:,2),sig_cmp(:,2));
[~,I] = max(abs(acor));
lagDiff = lag(I);

figure_name = [case_name '_' sample_base];
figure('name',figure_name);

subplot(3,1,1)
plot(sig_cmp(:,1),sig_cmp(:,2));
title(t_cmp);

subplot(3,1,2)
plot(hr_sd(:,1),hr_sd(:,2));
title('HR');

subplot(3,1,3)
plot(lag,acor);
title('xcor');

figure('name',[figure_name '_log']);

subplot(2,2,1)
plot(sig_cmp(:,1),log(sig_cmp(:,2)));
title('log_cmp');

subplot(2,2,2)
plot(sig_cmp(:,1),sig_cmp(:,2));
title('sig_cmp');

subplot(2,2,3)
plot(hr_sd(:,1),log(hr_sd(:,2)));
title('log_hr');

subplot(2,2,4)
plot(hr_sd(:,1),hr_sd(:,2));
title('hr');
