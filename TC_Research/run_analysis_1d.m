% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3) or aod
test_var_name = 'intensity';
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 3;
after = 8;

thresholds = [0.07, 0.13, 0.22, 0.4]
threshold = 0.22;
control_threshold = 0.007;

clf;
for i = 1 : 5
    nexttile;
    analysis(test_var_name, before, after, false, threshold, control_threshold, reigions, i);
end


%% CERA

test_var_name = 'duration';
before = 3;
after = 8;

eruptions_nh = [1902, 1912, 1982, 1991];
eruptions_sh = [1932, 1963];
eruptions_all = [1902, 1912, 1932, 1963, 1982, 1991];
clf;
output_fig = analysis(test_var_name, before, after, true, 'cera20_standardized.mat', 1901 : 2010, eruptions_all);
