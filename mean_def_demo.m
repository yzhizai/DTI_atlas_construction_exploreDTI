function mean_def_demo
filenames = spm_select(Inf, '^y.*nii$');
filenames = cellstr(filenames);

mean_def(filenames, 'HQW');