function [pa,pg,ph,pl] = preprocess(a,g,h,l)
acc_sd = a;
gsr_sd = g;
hr_sd  = h;
light_sd = l;

function [y] = flipx(x)
    x_mean = mean(x);
    x_std = std(x);
    y = abs(x_mean + x_std - x);
end

for n = 1:numel(acc_sd(:,1))
    acc_new(n,:) = sqrt(acc_sd(n,2)*acc_sd(n,2)+acc_sd(n,3)*acc_sd(n,3)+acc_sd(n,4)*acc_sd(n,4));
end
%Preprocess acc data: log/abs/combine/smooth
 %acc_x = log(flipx(acc_sd(:,2)));
 %acc_y = log(flipx(acc_sd(:,3)));
 %acc_z = log(flipx(acc_sd(:,4)));
 pa =  acc_new;
 %pa = SMOOTH(log(acc_sd(:,2)), 5, 9);
 
%Preprocess gsr data: log/smooth
 pg = log(gsr_sd(:,2));
 
%Preprocess hr data: log/smooth
 ph = SMOOTH(log(hr_sd(:,2)), 5, 9);
 
%Preprocesslight data: log/abs/smooth
 pl = SMOOTH(log(flipx(light_sd(:,2))), 5, 9);
% light_m = mean(light_a);
% pl = 2*light_m - light_a;
end