load 'volcano_data.mat'

threshold = 0.04;
eruption_times = time(find(diff(aod550 >= threshold) == 1));

dir_indexes = find_nearest(eruption_times, event_time);

unfiltered_times = eruption_times;

% remove eruptions that are shortly followed by another eruption
% this should remove noise from the SEA analysis
diff_filter = [diff(transpose(eruption_times)) inf] > 8;
eruption_times = eruption_times(diff_filter);

% now use the matched datasets to bin eruption times into three
% lattitude reigions
south = [];
tropics = [];
north = [];

for i = 1 : length(eruption_times)
    if (lat(dir_indexes(i)) < -10)
        south = [south eruption_times(i)];
    elseif (lat(dir_indexes(i)) > 10)
        north = [north eruption_times(i)];
    else
        tropics = [tropics eruption_times(i)];
    end
end

% only include the tropics and the north to reduce noise
filtered_events = sort([tropics north]);

figure(1);
clf;
hold on;
plot(time, aod550)
%sl = xline(south, 'r');
%tl = xline(tropics, 'g');
%nl = xline(north, 'm');
yline(threshold, '--');
%xlabel('Year');
%ylabel('Optical Aerosol Depth');
%set(gca, 'Yscale', 'log');
%legend([sl(1) tl(1) nl(1)], 'Southern Eruption', 'Tropical Eruption', 'Northern Eruption');
xline(filtered_events);
makepretty_axes('Year', 'Optical Aerosol Depth');
print('figure1','-dpng', '-r300');

load '../Storm Sets/LMR21_Atl_storms.mat';
storm_years = 850 : 1900;

freqyear = freqyear_LMR21_all(1 : length(storm_years));

vmax_LMR21_all = mean(reshape(vmax_LMR21_all .^ 2, [100, length(vmax_LMR21_all) / 100]));

fy_time_series = [storm_years; vmax_LMR21_all(1 : length(storm_years))];

before = 3;
after = 8;

[fy_events, fy_comp] = coral_sea(transpose(fy_time_series), round(filtered_events) - 849, before, after);

figure(2);
clf;
plot(-before : after, fy_comp);
