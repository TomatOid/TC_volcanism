clear
load 'SST_LMR21_AM21.mat'

varnames = { 'SST' };
month_start = 8;
month_end = 10;

for name = varnames
    name = char(name);
    monthly = eval(name);
    
    % assumes data is lon x lat x time

    shape = size(monthly);
    seasonal = zeros([shape(1), shape(2), shape(3) / 12]);
    for i = 1 : shape(3) / 12
        seasonal(:, :, i) = mean(monthly(:, :, (i - 1) * 12 + month_start : (i - 1) * 12 + month_end), 3);
    end
    eval(sprintf('%s_seasonal = seasonal;', name));
    %monthly = reshape(monthly, [shape(1), shape(2), shape(3) / 12, 12]);
    %eval(sprintf('%s_seasonal = mean(monthly(:, :, :, month_start : month_end), 4);', name));
    eval(sprintf('clear %s', name));
end

clear('monthly', 'varnames', 'month_start', 'month_end', 'shape', 'name', 'seasonal', 'i')
