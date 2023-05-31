load 'volcano_data.mat'

threshold = 0.015;
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

plot(time, aod550)
sl = xline(south, 'r');
tl = xline(tropics, 'g');
nl = xline(north, 'm');
yline(threshold, '--');
%xlabel('Year');
%ylabel('Optical Aerosol Depth');
%set(gca, 'Yscale', 'log');
legend([sl(1) tl(1) nl(1)], 'Southern Eruption', 'Tropical Eruption', 'Northern Eruption');
makepretty_axes('Year', 'Optical Aerosol Depth');
print('figure1','-dpng', '-r300');
