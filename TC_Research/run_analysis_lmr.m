% TODO
% Isolate single eruptions completely : Done
% Make debug SEA plots of AOD to test the SEA code : Done


% === set your control variables ===
% can be duration, frequency, intensity, cluster(1,2,3) or aod
test_var_name = 'intensity';
% reigions to include
% n stands for north, t for tropics, and s for south
reigions = 'nts';
before = 3;
after = 8;

threshold = 0.13;
control_threshold = 0.007;

output_fig = analysis(test_var_name, before, after, threshold, control_threshold, reigions);

%% CERA

test_var_name = 'frequency';

eruptions_nh = [1902, 1912, 1982, 1991];
eruptions_sh = [1932, 1963];
eruptions_all = [1902, 1912, 1932, 1963, 1982, 1991];
output_fig = analysis(test_var_name, before, after, 'cera20_standardized.mat', 1901 : 2010, eruptions_sh)
