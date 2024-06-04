function varargout = analysis(test_var_name, before, after, do_title, out_type, varargin)
    output_fig = gobjects(0);
    if ((length(varargin) == 4) && ~isstr(varargin{1}))
        [threshold, control_threshold, reigions, ensamble] = varargin{:};
        % additional time before the window where no eruptions are allowed
        before_window_filter = 1;

        [filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, before_window_filter, after, threshold, control_threshold);
        storm_years = 850 : 1900;
        if (isnumeric(ensamble))
            dataset = ['../Storm Sets/LMR21_ens', num2str(ensamble), '_renamed.mat'];
            is_lmr = 1;
        elseif (strcmp(ensamble, 'all'))
            dataset = ['../Storm Sets/LMR21_combined.mat'];
            is_lmr = 1;
        else
            error('invalid ensamble');
        end
    elseif (length(varargin) == 4)
        [dataset, storm_years, filtered_events, hemi_str] = varargin{:};
        
        sparse_bool = zeros(length(storm_years));
        % sparse_bool is set to one on years when there is an eruption
        sparse_bool(filtered_events - storm_years(1) + 1) = 1;
        % eruption_lag represents the number of years since the last eruption
        eruption_lag = forward_distance(sparse_bool);
        eruption_duration = 3;
        control_index = find(eruption_lag > eruption_duration);
        is_lmr = 0;
    else
        error(['invalid use of analysis, args must be either analysis(test_var_name, before, after, do_title, out_type, threshold, control_threshold, reigions, ens) ' ...
            'or analysis(test_var_name, before, after, do_title, out_type, dataset, storm_years, filtered_events)']);
    end
    % SEA Analysis

    [test_var, plot_str, y_str, folder_name] = get_title_and_data(test_var_name, true, dataset, storm_years);

    if (out_type == 'sea')
        time_series = transpose([storm_years; test_var]);

        [test_sea, test_signif, control_seas] = sea_with_control(time_series, floor(filtered_events), control_index, before, after);

        % SEA plotting code

        time_window = -before : after;

        % compute 95% CI
        control_seas_ci = quantile(control_seas, [0.05, 0.95], 2);

        t_area = [time_window, time_window(end : -1 : 1)];
        lower_quint = control_seas_ci(:, 1).';
        upper_quint = control_seas_ci(:, 2).';
        y_area = [lower_quint, upper_quint(end : -1 : 1)];
        fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
        hold on;

        y_min = min(lower_quint);
        y_max = max(upper_quint);

        % compute inner 2 quartiles
        control_seas_ci = quantile(control_seas, [0.25, 0.75], 2);

        t_area = [time_window, time_window(end : -1 : 1)];
        lower_quint = control_seas_ci(:, 1).';
        upper_quint = control_seas_ci(:, 2).';
        y_area = [lower_quint, upper_quint(end : -1 : 1)];
        fill(t_area, y_area, 'k', 'FaceAlpha', 0.2, 'LineStyle', 'none');
        hold on;

        plot(time_window, test_sea, '.-', 'MarkerSize', 10, 'LineWidth', 1, 'Color', 'k');
        hold on;

        y_min = min(y_min, min(test_sea));
        y_max = max(y_max, max(test_sea));
        y_gap = y_max - y_min;

        ten_percent = test_signif <= 0.1 & test_signif > 0.05;
        five_percent = test_signif <= 0.05;
        scatter(time_window(ten_percent), test_sea(ten_percent), 'x', 'LineWidth', 1.75, 'MarkerEdgeColor', 'r');
        scatter(time_window(five_percent), test_sea(five_percent), '*', 'LineWidth', 1.75, 'MarkerEdgeColor', 'r');

        axis([-before, after, y_min - 0.02 * y_gap, y_max + 0.02 * y_gap]);
        makepretty_axes('Lag (Years)', y_str);
        if (do_title)
            title(['SEA of ' plot_str '; ' hemi_str]);
        end
        if (is_lmr)
            subtitle(['AOD threshold = ' num2str(threshold) ', N = ' num2str(length(filtered_events))]);
        else
            subtitle(['N = ' num2str(length(filtered_events))]);
        end
        xline(0, '--');
        %if ~isfolder(folder_name)
        %    mkdir(folder_name);
        %end
        %print([folder_name '/sea_' test_var_name '_fix_thr_' num2str(threshold) '.png'], '-dpng', '-r300');
        
        varargout{1} = gcf;
    elseif (out_type == 'pdf')
        sparse_bool = zeros(length(storm_years));
        sparse_bool(floor(filtered_events) - storm_years(1) + 1) = 1;
        after_distance = forward_distance(sparse_bool);
        before_distance = flip(forward_distance(flip(sparse_bool)));
        after_data = test_var((after_distance >= 0) & (after_distance <= after));
        before_data = test_var((before_distance > 0) & (before_distance <= before));

        varargout{1} = before_data;
        varargout{2} = after_data;
    end
end
