function [test_sea, test_signif, control_seas] = sea_with_control(time_series, event_times, control_indices, before, after)
    event_times = sort(event_times);
    event_indices = find_nearest(event_times, time_series(:, 1));
    event_indices = event_indices(event_indices > before & event_indices + after < length(time_series(:, 1)));

    % remove events where the window will fall outside of the dataset
    control_indices = control_indices(control_indices > before & control_indices + after < length(time_series(:, 1)));

    [test_seas, test_sea] = coral_sea(time_series, event_indices, before, after);
    
    num_resample = 1000;
    window = before + after + 1;
    control_seas = zeros(window, num_resample);
    control_singles = zeros(window, num_resample * length(event_times));

    for i = 1 : num_resample
        sampled_indices = randsample(control_indices, length(event_times));
        [control_singles(:, (i - 1) * length(event_times) + 1 : i * length(event_times)), control_seas(:, i)] = coral_sea(time_series, sampled_indices, before, after);
    end

    test_signif = zeros([window, 1]);
    for i = 1 : window
        test_signif(i) = ranksum(test_seas(i, :), control_singles(i, :));
    end
end
