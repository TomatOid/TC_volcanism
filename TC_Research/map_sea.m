% map_series has dimensions [lon, lat, time]
function [test_sea, p_score] = map_sea(time, map_series, event_times, control_indices, before, after)
    % event_times is assumed to be sorted
    event_indices = find_nearest(event_times, time);
    event_indices = event_indices(event_indices > before & event_indices + after < length(time));
    
    event_indices
    % remove events where the window will fall outside of the dataset
    control_indices = control_indices(control_indices > before & control_indices + after < length(time));
    %length(control_indices)

    clips = zeros([length(event_indices), size(map_series(:, :, 1)), before + after + 1]);
    for i = 1 : length(event_indices)
        clips(i, :, :, :) = map_series(:, :, event_indices(i) - before : event_indices(i) + after);% - mean(map_series(:, :, event_indices(i) - before : event_indices(i) - 1), 3);
    end

    %clips(:, 132, 52, 1)
    test_sea = squeeze(mean(clips, 1));

    n_runs = 250;
    control_ens = zeros([n_runs, size(map_series(:, :, 1)), before + after + 1]);

    for i = 1 : n_runs
        %clips = zeros([length(event_indices), size(map_series(:, :, 1)), before + after + 1]);
        rand_indices = randsample(control_indices, length(event_indices));
        for j = 1 : length(event_indices)
            clips(j, :, :, :) = map_series(:, :, rand_indices(j) - before : rand_indices(j) + after);% - mean(map_series(:, :, rand_indices(j) - before : rand_indices(j) - 1), 3);
        end
        %clips(:, 132, 52, 1)
        control_ens(i, :, :, :) = squeeze(mean(clips, 1));
    end

    p_score = squeeze(sum(control_ens < repmat(reshape(test_sea, [1, size(map_series(:, :, 1)), before + after + 1]), n_runs, 1, 1, 1), 1)) / n_runs;
    hist(control_ens(:, 1, 1, 1));
    hold on;
    xline(test_sea(1, 1, 1));
end
