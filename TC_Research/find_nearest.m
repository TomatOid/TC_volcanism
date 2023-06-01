function dir_indexes = find_nearest_matches(search_for, base)
    % Do a merge-sort-like pass to find closest matches between datasets
    j = 1;
    dir_indexes = zeros(size(search_for));
    while (j <= length(search_for) && search_for(j) <= base(1))
        dir_indexes(j) = 1;
        j = j + 1;
    end

    for i = 1 : length(base) - 1
        if (j > length(search_for))
            break
        end

        while ((j <= length(search_for)) && (search_for(j) >= base(i)) && (search_for(j) <= base(i + 1)))
            dir_indexes(j) = i + (abs(search_for(j) - base(i)) > abs(search_for(j) - base(i + 1)));
            j = j + 1;
        end 
    end

    while (j <= length(search_for))
        dir_indexes(j) = length(base);
        j = j + 1;
    end
end
