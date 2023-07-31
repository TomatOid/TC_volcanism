data_struct = load('../Storm Sets/LMR21_Atl_storms.mat');

old_names = fieldnames(data_struct);
new_names = strrep(old_names, '_LMR21_all', '');

new_struct = matfile('../Storm Sets/LMR21_renamed.mat', 'Writable', true);

for i = 1 : length(old_names)
    new_struct.(new_names{i}) = data_struct.(old_names{i});
end
