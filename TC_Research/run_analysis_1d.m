% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3,4) or aod
test_var_name = 'duration';
% reigions to include
% n stands for north, t for tropics, and s for south
% northern hemisphere eruptions produce interesting results
reigions = 'nts';
before = 3;
after = 5;

thresholds = [0.07, 0.13, 0.22, 0.4]
threshold = 0.13;
control_threshold = 0.007;

%%

clf;

nexttile;
analysis(test_var_name, before, after, true, 'sea', thresholds(1), control_threshold, reigions, 'all');

title_str = get(get(gca, 'title'), 'string');
title('');
for i = 2 : length(thresholds)
    nexttile;
    analysis(test_var_name, before, after, false, 'sea', thresholds(i), control_threshold, reigions, 'all');
end

sgt = sgtitle(title_str);
sgt.FontSize = 18;

%% combined dataset


test_var_name = 'duration';
reigions = 'nts';
before = 3;
after = 5;

[filtered_events, control_index, hemi_str] = extract_eruption_data(reigions, before, 1, after, threshold, control_threshold);

storm_years = 850 : 1999;

figure(1);
clf;

analysis(test_var_name, before, after, true, 'sea', threshold, control_threshold, reigions, 'all');


figure(2);
clf;
before = 5;
after = 3;
[before_all, after_all] = analysis(test_var_name, before, after, true, 'pdf', threshold, control_threshold, reigions, 'all');
pdf_plot(before_all, after_all, test_var_name);

%%  

before = 5;
after = 3;
before_all = [];
after_all = [];
for i = 1 : 5
    [before_single, after_single] = analysis(test_var_name, before, after, false, 'pdf', threshold, control_threshold, reigions, i);

    before_all = [before_all before_single];
    after_all = [after_all after_single];
end

clf;
%before is purple
%hist(vertcat([before_all], [after_all]).');

pdf_plot(before_all, after_all, test_var_name);

fprintf('before mean: %f\n', mean(before_all));
fprintf('after mean: %f\n', mean(after_all));

%% Chenoweth

storm_years = 850 : 1999;
volc_years_gao = [1693, 1719, 1729, 1755, 1760, 1783, 1796, 1808, 1815, 1831, 1835, 1883, 1912, 1925, 1943, 1963, 1982, 1991];

figure(1);
clf;

test_var_name = 'n_tc'
before = 5;
after = 5;

analysis(test_var_name, before, after, true, 'sea', 'chenoweth_combined.mat', storm_years, volc_years_gao);

figure(2);
clf;

[before_single, after_single] = analysis(test_var_name, 5, 3, false, 'pdf', 'chenoweth_combined.mat', storm_years, volc_years_gao);

pdf_plot(before_single, after_single, test_var_name);

fprintf('before mean: %f\n', mean(before_single));
fprintf('after mean: %f\n', mean(after_single));

figure(1);

%% CERA

test_var_name = 'intensity';
before = 3;
after = 5;

eruptions_nh = [1902, 1912, 1982, 1991];
eruptions_sh = [1932, 1963];
eruptions_all = [1902, 1912, 1932, 1963, 1982, 1991];
eruptions = eruptions_all;
hemi_str = 'Global';

clf;
tiledlayout(2, 2);
ax = subplot(2, 2, 1);
analysis(test_var_name, before, after, true, 'sea', 'cera20_standardized.mat', 1901 : 2010, eruptions, [hemi_str, ' (CERA20)']);
[before_all, after_all] = analysis(test_var_name, 5, 3, true, 'pdf', 'cera20_standardized.mat', 1901 : 2010, eruptions, hemi_str);
subplot(2, 2, 2);
pdf_plot(before_all, after_all, test_var_name);
ax = subplot(2, 2, 3);
analysis(test_var_name, before, after, true, 'sea', 'lmr21_combined.mat', 850 : 1999, eruptions, [hemi_str, ' (LMR21)']);
[before_all, after_all] = analysis(test_var_name, 5, 3, true, 'pdf', 'lmr21_combined.mat', 850 : 1999, eruptions, hemi_str);
subplot(2, 2, 4);
pdf_plot(before_all, after_all, test_var_name);
