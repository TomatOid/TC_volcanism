combined_struct = matfile(['../Storm Sets/LMR21_combined.mat'], 'Writable', true);

%%
num_files = 5;

for i = 1 : num_files 
    % use new bias corrected storms
    fname = [ 'LMR21_ens', num2str(i), '_renamed.mat' ];
    data_struct = matfile(['./', fname]);

    small_names = who(data_struct);
    if (i == 1)
        for j = 1 : length(small_names)
            fprintf('Making var (%d / %d)\n', j, length(small_names)); 
            combined_struct.(small_names{j}) = repmat(zeros(size(data_struct.(small_names{j})), 'like', data_struct.(small_names{j})), [1, 1, num_files]);
        end
    end

    fprintf('combining file (%d / %d)\n', i, num_files); 
    for j = 1 : length(small_names)
        combined_struct.(small_names{j})(:, :, i) = data_struct.(small_names{j});
    end

    clear data_struct
end

%%
% find n_storms, n_years, and n_points

n_years = max(size(combined_struct.freqyear));
n_points = size(combined_struct.yearstore);
n_points = n_points(2);
n_storms = max(size(combined_struct.yearstore));


%% flatten arrays

fprintf('flattening...\n');

for j = 1 : length(small_names)
    item = combined_struct.(small_names{j});
    shape = size(item);
    if (shape(2) == n_years)
        combined_struct.(small_names{j}) = reshape(mean(item, 3), 1, []);
        combined_struct.([small_names{j}, '_std']) = reshape(std(item, 0, 3), 1, []);
    elseif (shape(1) == n_storms)
        item = permute(item, [3, 1, 2]);
        combined_struct.(small_names{j}) = reshape(item, [], shape(2));
    elseif (shape(1) == 1)
        item = permute(item, [1, 3, 2]);
        combined_struct.(small_names{j}) = reshape(item, 1, []);
    else
        fprintf('error: anomolous length');
    end
end


