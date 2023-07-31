% Distance between two points in nautical miles
function d = haversine_delta(lat_1, lon_1, lat_2, lon_2)
    % use spherical law of cosines as a reasonable approximation
    phi_1 = lat_1 * pi / 180;
    phi_2 = lat_2 * pi / 180;
    del_lambda = (lon_2 - lon_1) * pi / 180;
    R = 3440; % radius of the earth in nautical miles
    d = R * acos(sin(phi_1) .* sin(phi_2) + cos(phi_1) .* cos(phi_2) .* cos(del_lambda));
end
