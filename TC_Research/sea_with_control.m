function [alligned, avg, control_seas] = sea_with_control(time_series, event_times, control_indices, before, after)
    event_times = sort(event_times);
    event_indices = find_nearest(event_times, time_series(:, 1));

    % remove events where the window will fall outside of the dataset
    control_indices = control_indices(control_indices > before & control_indices + after < length(time_series(:, 1)));
    
    [alligned, avg] = coral_sea(time_series, event_indices, before, after);

    num_resample = 1000;
    n_events = length(event_times);
    window = before + after + 1;
    control_seas = zeros(window, num_resample);
    sampled_indices = zeros(1, n_events);

    for i = 1 : num_resample
        sampled_indices = randsample(control_indices, n_events);
        [~, control_seas(:, i)] = coral_sea(time_series, sampled_indices, before, after);
    end
end
