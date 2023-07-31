function [change, u_value] = three_yr_diff_wilcoxon(time, map_series, event_times)
    % event_times is assumed to be sorted
    event_indices = find_nearest(event_times, time);
    % remove all events where either a before or after window cannot be defined
    event_indices = event_indices(event_indices > 2 & event_indices + 2 < length(time));

    smoothed = movmean(map_series, 3, 3);
    before = smoothed(:, :, 1 : end - 3);
    after  = smoothed(:, :, 4 : end);

    delta = after - before;
    event_indices = event_indices - 2;

    change = mean(delta(:, :, event_indices), 3, 'omitnan');

    shape = size(map_series(:, :, 1));
    u_value = NaN(shape);
    for x = 1 : shape(1)
        for y = 1 : shape(2)
            if (~all(isnan(map_series(x, y, event_indices))))
                [u_value(x, y), h] = ranksum(squeeze(before(x, y, event_indices)), squeeze(after(x, y, event_indices)));
            end
        end
    end
end
