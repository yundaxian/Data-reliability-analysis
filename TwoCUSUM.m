function [alarms, nc] = TwoCUSUM( x, h, k, window, d )
%CUSUM Uses CUmulative SUM approach to detect change in a series or signal.
%   [alarms, nc] = CUSUM( x, h, k, window, d ) takes the signal x, the
%   detection threshold h, the change magnitude d, the window size window
%   and the no. of change points to set an alarm, k as arguments.
%
%   The function returns a change point vector nc, containing ones 
%   where there is a change point. Similarly, an alarms vector, containing 
%   the alarm positions depending on the value of k is also returned.
%	
%	h: set the detection threshold h > 0
%	k: Minimum No. ST Elevations to detect for an alarm
%	window: Sliding window size for CUSUM algorithm
%   d: set d to the most likely change magnitude

%//////////////////////////////////////////////////////////////////////////

alarms = zeros(length(x), 1);
nc = zeros(length(x), 1);       % Change points in x[n]
start = 1;

%   initialization
new_min = zeros(length(x), 1);
%   end initialization

%//////////////////////////////////////////////////////////////////////////

%   main loop
while start < length(x)
G1 = zeros(length(x), 1);        % Decision Function
s1 = zeros(length(x), 1);        % Instantaneous Log-Liklihood Ratio
S1 = zeros(length(x), 1);        % Comulative Sum

G2 = zeros(length(x), 1);        % Decision Function
s2 = zeros(length(x), 1);        % Instantaneous Log-Liklihood Ratio
S2 = zeros(length(x), 1);        % Comulative Sum

start = start + 1;
for n = start : 1 : length(x)
    sigma = std(x(start:n));    % Current Standard deviation
    mu = mean(x(start:n));      % Current Mean for hypothesis H0
    
    % Calculate the instantaneous log-liklihood ratio, s[n]
    s1(n) = (d/(sigma*sigma))*(x(n)-mu-(d/2));
    s2(n) = -(d/(sigma*sigma))*(x(n)-mu+(d/2));
    
    % Calculate the Decision Function, G[n] and Cumulative Sum, S[n]
    if n == 1
        S1(n) = s1(n);
        G1(n) = max(s1(n), 0);
        S2(n) = s2(n);
        G2(n) = max(s2(n), 0);
    else
        S1(n) = S1(n-1) + s1(n);
        G1(n) = max((G1(n-1) + s1(n)), 0);
        
        S2(n) = S2(n-1) + s2(n);
        G2(n) = max((G2(n-1) + s2(n)), 0);
        
        min_array1 = find(S1(1:n-1) == min(S1(1:n-1)));
        min_array2 = find(S2(1:n-1) == min(S2(1:n-1)));
        min_array = union(min_array1,min_array2);
        if not(isempty(min_array))
            new_min(min_array(length(min_array))) = min_array(length(min_array));
        end
    end
    
    % Find the change point, nc, when hypothesis switches from H0 to H1, 
    % characterized by G[n] being greater than the threshold value h
    if G1(n) > h || G2(n) > h 
        nc(find(new_min, 1, 'last')) = 1;
        
        if n > window
            if sum(nc(n-window:n)) >= k
                alarms(find(nc(n-window:n), 1, 'first') + n - window - 1) = 1;
            end
        end
        
        % Reset the algorithm/ main loop
        start = n;
        break
    end
end
end
%   end main loop

%//////////////////////////////////////////////////////////////////////////

% Find the alarm positions in signal x[n] from change point vector nc
% alarm_pos = find(nc);
% 
% plot(x(:, 1));
% hold on
% for i = 1 : 1 : length(alarm_pos)
%     line([alarm_pos(i) alarm_pos(i)], get(gca,'YLim'), 'Color', [1 0 0])
% end
% hold off
% title('CUSUM Alarms in Signal x[n]');
% legend('x[n]', 'CUSUM Alarms');
% xlabel('n');
% ylabel('x[n]', 'fontweight', 'light');
% 
% subplot(111)

end