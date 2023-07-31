function [change, u_value] = three_yr_diff_wcontrol(time, map_series, event_times, control_indices)
    % event_times is assumed to be sorted
    event_indices = find_nearest(event_times, time);
    % remove all events where either a before or after window cannot be defined
    event_indices = event_indices(event_indices > 2 & event_indices + 2 < length(time));

    smoothed = movmean(map_series, 3, 3);
    before = smoothed(:, :, 1 : end - 3);
    after  = smoothed(:, :, 4 : end);

    delta = after - before;
    event_indices = event_indices - 2;

    change = mean(delta(:, :, event_indices), 3);

    % remove events where the window will fall outside of the dataset
    control_indices = control_indices(control_indices > 2 & control_indices + 2 < length(time));
    control_indices = control_indices - 2;

    n_runs = 250;
    control_ens = zeros([n_runs, size(map_series(:, :, 1))]);

    for i = 1 : n_runs
        rand_indices = randsample(control_indices, length(event_indices));
        control_ens(i, :, :) = mean(delta(:, :, rand_indices), 3);
    end

    shape = size(map_series(:, :, 1));
    u_value = NaN(shape);
    for x = 1 : shape(1)
        for y = 1 : shape(2)
            if (~all(isnan(map_series(x, y, :))))
                [u_value(x, y), h] = ranksum(squeeze(delta(x, y, event_indices)), squeeze(control_ens(x, y, :)));
            end
        end
    end
end
