for i = 5 : 5 
    fname = [ 'LMR21_ens', num2str(i), '_Atl_storms.mat' ];
    data_struct = load(['../Storm Sets/', fname]);

    old_names = fieldnames(data_struct);
    expected_name = ['_LMR21_ens', num2str(i), '_all'];
    if (contains(old_names, expected_name))
        new_names = strrep(old_names, expected_name, '');
    else
        new_names = strrep(old_names, '_LMR21_all', '');
    end

    new_struct = matfile(['../Storm Sets/LMR21_ens', num2str(i), '_renamed.mat'], 'Writable', true);

    for j = 1 : length(old_names)
        new_struct.(new_names{j}) = data_struct.(old_names{j});
    end

    clearvars -except i
end
