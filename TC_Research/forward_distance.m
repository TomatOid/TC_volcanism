function out = compute_forward_distance(in)
    % =========
    % `in` is a boolean array, `out` is the distance from the last falling edge of in

    out = zeros(size(in));
    start_idx = find(in, 1);
    out(1 : start_idx) = inf;
    distance = 0;

    for i = start_idx : length(in)
        distance = (distance + 1) * ~in(i);
        out(i) = distance;
    end
end
