function mask = get_landmask(lon, lat)
    % read file
    fname = 'WorldLandBitMap.dat'; % little endian case
    fid = fopen(fname,'r');
    bmap = fread(fid,[36000/32 18000], '*uint32'); % for little endian machine
    fclose(fid);
    [LAT, LON] = meshgrid(lat, lon);

    % read file
    fname = 'WorldLandBitMap.dat'; % little endian case
    fid = fopen(fname,'r');
    bmap = fread(fid,[36000/32 18000], '*uint32'); % for little endian machine
    fclose(fid);

    NSX1 = 36000 / 32;
    NSX = NSX1 * 32;
    NSY = 18000;

    % vectorized
    lon180 = mod(LON + 360, 360);
    lon180(lon180 > 0) = lon180(lon180 > 0) - 360;
    ix = round((lon180 + 180)*100);
    ix(ix < 0) = ix(ix < 0) + NSX;
    ix(ix >= NSX) = ix(ix >= NSX) - NSX;
    ix1 = floor(ix / 32);
    ix2 = ix - ix1 * 32;
    iy = round((LAT + 90)*100);
    iy(iy < 0) = 0;
    iy(iy >= NSY) = NSY - 1;

    land_bit = ~bitget(bmap(ix1 + iy * NSX1 + 1), ix2, 'uint32');

    mask = cast(reshape(land_bit, [length(lon), length(lat)]), 'single');
end
