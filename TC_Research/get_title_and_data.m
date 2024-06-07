function [test_var, plot_str, y_str, folder_name] = get_title_and_data(test_var_name, load_data, dataset, storm_years)
    test_var = [];
    folder_name = test_var_name;
    switch test_var_name
        case 'duration'
            if (load_data)
                load(dataset, 'duration');
                test_var = duration(1 : length(storm_years));
            end
            plot_str = 'Storm Duration';
            y_str = 'Storm Duration (hours)';
        case 'frequency'
            if (load_data)
                load(dataset, 'freqyear');
                test_var = freqyear(1 : length(storm_years));
            end
            plot_str = 'Storm Frequency';
            y_str = 'Storm Frequency';
        case 'intensity'
            if (load_data)
                load(dataset, 'vnetmax');
                storms_per_year = length(vnetmax) / length(storm_years);
                test_var = mean(reshape(vnetmax, [storms_per_year, length(vnetmax) / storms_per_year]));
                %test_var = test_var(1 : length(storm_years));
            end
            plot_str = 'Storm Intensity';
            y_str = 'Average Max Wind Velocity (knots)';
        case 'aod'
            if (load_data)
                load('volcano_data.mat');
                test_var = max(reshape(aod550, [12, length(aod550) / 12]));
            end
            plot_str = 'Optical Aerosol Depth';
            y_str = 'Change in AOD';
        case {'cluster1', 'cluster2', 'cluster3', 'cluster4'}
            if (load_data)
                clust_file = '../Storm Sets/LMR_Clust.mat';
                load(clust_file);

                % check if old or new format
                if (~any(strcmp(who('-file', clust_file), 'yearstore')))
                    load(dataset, 'yearstore');
                    LMR_cluster = eval(sprintf('LMR_%s', test_var_name));
                else
                    LMR_cluster = clust_LMR(:, end);
                    LMR_cluster = round(LMR_cluster) == str2num(test_var_name(end));
                end

                test_var = hist(yearstore(LMR_cluster), 850 : 1999);
                test_var = test_var(1 : length(storm_years));
            end

            plot_str = sprintf('Cluster %s Membership', test_var_name(end));
            y_str = 'Cluster Membership (storms / year)';
            folder_name = 'cluster';
        case 'genlat'
            if (load_data)
                load(dataset, 'latstore');
                genesis_lats = latstore(:, 1);
                clear latstore;
                test_var = mean(reshape(genesis_lats, [100, length(genesis_lats) / 100]));
                test_var = test_var(1 : length(storm_years));
            end
            
            plot_str = 'Genesis Lattitudes';
            y_str = 'Average Genisis Lattitude';
        case 'genlon'
            if (load_data)
                load(dataset, 'longstore');
                genesis_lons = longstore(:, 1);
                clear longstore;
                test_var = mean(reshape(genesis_lons, [100, length(genesis_lons) / 100]));
                test_var = test_var(1 : length(storm_years));
            end

            plot_str = 'Genesis Longitudes';
            y_str = 'Average Genesis Longitudes';
        case 'relsst'
            if (load_data)
                load 'SST_aso.mat'
                SST = SST_seasonal;
                % 1D version is same box - (30S to 30N) range
                mask = get_landmask(lon, lat);
                mask(mask == 1) = NaN;
                SST_relative = SST + repmat(mask, 1, 1, length(SST));
                lat_window = find_nearest([7.5, 22.5], lat);
                lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
                MDR_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');

                lat_window = find_nearest([-30, 30], lat);
                lon_window = find_nearest(mod([-70, -20] + 360, 360), lon);
                tropical_mean = mean(SST_relative(lon_window(1) : lon_window(2), lat_window(1) : lat_window(2), :), [1, 2], 'omitnan');

                test_var = squeeze(MDR_mean - tropical_mean).';
                test_var = test_var(1 : length(storm_years));
            end
            
            plot_str = 'Relative SSTs';
            y_str = 'MDR mean - tropical mean';
        case 'n_tc'
            if (load_data)
                load(dataset, 'n_tc');

                test_var = n_tc(1 : length(storm_years));
            end
            plot_str = 'Number of Emulated Chenoweth TCs';
            y_str = 'Mean emulated Chenoweth storms';
        case 'n_bh'
            if (load_data)
                load(dataset, 'n_bh');

                test_var = n_bh(1 : length(storm_years));
            end
            plot_str = 'Number of Emulated Chenoweth TCs';
            y_str = 'Mean emulated Chenoweth storms';

        case 'n_ts'
            if (load_data)
                load(dataset, 'n_ts');

                test_var = n_ts(1 : length(storm_years));
            end
            plot_str = 'Number of Emulated Chenoweth Tropical Stormss';
            y_str = 'Mean emulated Chenoweth storms';

        otherwise
            error([test_var_name, ' is not a valid test_var_name']);
    end

