function ResPro = cfg_DTI_Resample

refFile = cfg_files;
refFile.name = 'Reference image';
refFile.tag = 'ref_file';
refFile.filter = {'image'};
refFile.num = [0, 1];
refFile.help = {'choose an image', 'like fa image in reference space.'};


srcFile = cfg_files;
srcFile.name = 'Source image';
srcFile.tag = 'src_file';
srcFile.filter = {'image'};
srcFile.num = [0, 1];
srcFile.help = {'choose an image', 'like fa image in source space.'};

DTFile = cfg_files;
DTFile.name = 'DT image';
DTFile.tag = 'DT_file';
DTFile.filter = {'nii'};
DTFile.num = [0, 1];
DTFile.help = {'choose the DT image', 'a 4-D image storing diffusion tensor elements.'};

DefFile = cfg_files;
DefFile.name = 'Deformation Field';
DefFile.tag = 'Def_file';
DefFile.filter = {'nii'};
DefFile.num = [0, 1];
DefFile.help = {'choose the Deformation image', 'The stored element should be same with spm type.'};

outFile = cfg_entry;
outFile.name = 'Output file name';
outFile.tag = 'out_file';
outFile.strtype = 's';
outFile.num = [1, 100];
outFile.help = {'give a name for the output image', 'no need for extentional name'};

ResPro = cfg_exbranch;
ResPro.name = 'DTI Resample';
ResPro.tag = 'Res_exb';
ResPro.val = {refFile, srcFile, DTFile, DefFile, outFile};
ResPro.prog = @cfg_DTI_run_Resample;
ResPro.vout = @cfg_DTI_vout_Resample;
ResPro.help = {'This is a batch to resample the DTI image with deformation field'};

function vout = cfg_DTI_vout_Resample(job)

vout = cfg_dep;
vout.sname = 'Resampled Diffusion Tensor';
vout.src_output = substruct('()', {1});
