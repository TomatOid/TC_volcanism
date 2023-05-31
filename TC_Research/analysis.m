load 'volcano_data.mat'

threshold = 0.022;
eruption_times = time(find(diff(aod550 >= threshold) == 1));

% Do a merge-sort-like pass to find closest matches between datasets
j = 1;
dir_indexes = zeros(length(eruption_times), 1);

while (j <= length(eruption_times) && eruption_times(j) <= event_time(1))
    dir_indexes(j) = 1;
    j = j + 1;
end

for i = 1 : length(event_time) - 1
    if (j > length(eruption_times))
        break
    end

    while ((j <= length(eruption_times)) && (eruption_times(j) >= event_time(i)) && (eruption_times(j) <= event_time(i + 1)))
        dir_indexes(j) = i + (abs(eruption_times(j) - event_time(i)) > abs(eruption_times(j) - event_time(i + 1)));
        j = j + 1;
    end 
end

while (j <= length(eruption_times))
    dir_indexes(j) = length(event_time);
    j = j + 1;
end

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

filtered_events = sort([tropics north]);
diff_filter = [diff(filtered_events) inf] > 8;
filtered_events = filtered_events(diff_filter);

figure(1);
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

fy_time_series = [storm_years; freqyear];

[fy_events, fy_comp] = coral_sea(transpose(fy_time_series), round(filtered_events) - 849, 3, 8);

figure(2);
plot(-3 : 8, fy_comp);
