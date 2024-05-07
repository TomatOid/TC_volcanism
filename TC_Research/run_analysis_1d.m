% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3) or aod
test_var_name = 'frequency';
% reigions to include
% n stands for north, t for tropics, and s for south
% northern hemisphere eruptions produce interesting results
reigions = 'n';
before = 3;
after = 8;

thresholds = [0.07, 0.13, 0.22, 0.4]
threshold = 0.13;
control_threshold = 0.007;

%%

clf;
for i = 1 : 5
    nexttile;
    analysis(test_var_name, before, after, true, 'sea', threshold, control_threshold, reigions, i);
end

%%  

before = 3;
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
n_bins = 8;
[counts_before, centers_before] = ksdensity(before_all);
[counts_after, centers_after] = ksdensity(after_all);

plot(centers_before, counts_before);
hold on;
plot(centers_after, counts_after);

fprintf('before mean: %f\n', mean(before_all));
fprintf('after mean: %f\n', mean(after_all));

%% CERA

test_var_name = 'duration';
before = 3;
after = 8;

eruptions_nh = [1902, 1912, 1982, 1991];
eruptions_sh = [1932, 1963];
eruptions_all = [1902, 1912, 1932, 1963, 1982, 1991];
clf;
output_fig = analysis(test_var_name, before, after, true, 'cera20_standardized.mat', 1901 : 2010, eruptions_all);
