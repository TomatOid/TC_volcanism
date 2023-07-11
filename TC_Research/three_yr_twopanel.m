function [change, p_value] = three_yr_diff(time, map_series, event_times, control_indices)
    % event_times is assumed to be sorted
    event_indices = find_nearest(event_times, time);
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

    p_value = squeeze(sum(control_ens < repmat(reshape(change, [1, size(map_series(:, :, 1))]), n_runs, 1, 1), 1)) / n_runs;
end
