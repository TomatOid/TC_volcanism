% map_series has dimensions [lon, lat, time]
% varargin could be control_times
function [test_sea, p_score] = map_sea(time, map_series, event_times, before, after, varargin)
    % event_times is assumed to be sorted
    event_indices = find_nearest(event_times, time);
    event_indices = event_indices(event_indices > before & event_indices + after < length(time));
    
    %length(control_indices)

    clips = zeros([length(event_indices), size(map_series(:, :, 1)), before + after + 1]);
    for i = 1 : length(event_indices)
        clips(i, :, :, :) = map_series(:, :, event_indices(i) - before : event_indices(i) + after);% - mean(map_series(:, :, event_indices(i) - before : event_indices(i) - 1), 3);
    end

    test_sea = squeeze(mean(clips, 1, 'omitnan'));

    if length(varargin) > 0
        control_indices = varargin{1};
        % remove events where the window will fall outside of the dataset
        control_indices = control_indices(control_indices > before & control_indices + after < length(time));

        n_runs = 250;
        control_ens = zeros([n_runs, size(map_series(:, :, 1)), before + after + 1]);

        for i = 1 : n_runs
            %clips = zeros([length(event_indices), size(map_series(:, :, 1)), before + after + 1]);
            rand_indices = randsample(control_indices, length(event_indices));
            for j = 1 : length(event_indices)
                clips(j, :, :, :) = map_series(:, :, rand_indices(j) - before : rand_indices(j) + after);% - mean(map_series(:, :, rand_indices(j) - before : rand_indices(j) - 1), 3);
            end
            control_ens(i, :, :, :) = squeeze(mean(clips, 1, 'omitnan'));
        end

        p_score = squeeze(sum(control_ens < repmat(reshape(test_sea, [1, size(map_series(:, :, 1)), before + after + 1]), n_runs, 1, 1, 1), 1)) / n_runs;
    else
        p_score = zeros(size(test_sea)) + 0.5;
    end
end
