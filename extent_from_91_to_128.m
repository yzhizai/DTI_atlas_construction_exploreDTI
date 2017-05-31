function extent_from_91_to_128(V, fname)

Y = spm_read_vols(V);
Y_to_write = zeros(128, 128, 128, numel(V));

Y_to_write(20:end - 18, 11:end - 9, 20:end - 18, :) = Y;

N    = cat(1,V.private);
dt = V(1).dt(1);
sf  = V(1).pinfo(1);
off = V(1).pinfo(2);


ni = nifti;
ni.dat = file_array(fname,...
                        [128, 128, 128, numel(V)],...
                        [dt spm_platform('bigend')],...
                        0,...
                        sf,...
                        off);
ni.mat = N(1).mat;
ni.mat0 = N(1).mat;
ni.descrip = 'extend to 128';

create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = Y_to_write(:, :, :, i);
    spm_get_space([ni.dat.fname ',' num2str(i)], V(i).mat);
end

