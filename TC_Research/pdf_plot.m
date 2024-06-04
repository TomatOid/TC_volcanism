function plt = pdf_plot(before_all, after_all, varargin) % optionally add test_var_name
    [counts_before, centers_before] = ksdensity(before_all);
    median_before = mean(before_all);
    [counts_after, centers_after] = ksdensity(after_all);
    median_after = mean(after_all);

    colormap(redblue);
    h1 = area(centers_before, counts_before);
    h1.FaceAlpha = 0.2;
    xline(median_before, ':', 'LineWidth', 2);
    hold on;
    h2 = area(centers_after, counts_after);
    h2.FaceAlpha = 0.2;
    xline(median_after, ':', 'LineWidth', 2);

    mid_y = get(gca, 'YLim');
    mid_y = mean(mid_y);
    head_width = 5;
    head_length = 8;
    line_length = 1;
    [X, Y, U, V] = deal(median_before, mid_y, median_after - median_before, 0);
    q = quiver(X, Y, U, V, 0, 'color', 'k', 'ShowArrowHead', 0);
    ah = annotation('arrow', 'headstyle', 'cback1', 'HeadLength', head_length, 'HeadWidth', head_width)
    set(ah, 'parent', gca);
    set(ah, 'position', [X, Y, line_length * U, line_length * V]);

    legend([h1, h2, q], {'Before Eruption', 'After Eruption', ['p = ', num2str(ranksum(before_all, after_all), 3)]});

    if length(varargin) == 1
        [~, plot_str, y_str, ~] = get_title_and_data(varargin{1}, false, [], []);

        makepretty_axes(y_str, 'Probability Density');
    else if length(varargin) > 1
        fprintf('too many arguments, don''t know what to do\n');
    end
end
