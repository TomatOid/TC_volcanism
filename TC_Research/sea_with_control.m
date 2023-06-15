function [test_seas, control_seas] = sea_with_control(time_series, event_times, control_indices, subsample_size, before, after)
    event_times = sort(event_times);
    event_indices = find_nearest(event_times, time_series(:, 1));
    event_indices = event_indices(event_indices > before & event_indices + after < length(time_series(:, 1)));

    % remove events where the window will fall outside of the dataset
    control_indices = control_indices(control_indices > before & control_indices + after < length(time_series(:, 1)));
    
    num_resample = 1000;
    window = before + after + 1;
    control_seas = zeros(window, num_resample);
    test_seas = zeros(window, num_resample);
    sampled_indices = zeros(1, subsample_size);

    for i = 1 : num_resample
        sampled_indices = randsample(control_indices, subsample_size);
        [~, control_seas(:, i)] = coral_sea(time_series, sampled_indices, before, after);
        sampled_indices = randsample(event_indices, subsample_size);
        [~, test_seas(:, i)] = coral_sea(time_series, sampled_indices, before, after);
    end
end
