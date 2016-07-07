function RecPro = cfg_DWI_Recon

DTFile = cfg_files;
DTFile.name = 'DT image';
DTFile.tag = 'DT_file';
DTFile.filter = {'nii'};
DTFile.num = [0, 1];
DTFile.help = {'choose the DT image', 'a 4-D image storing diffusion tensor elements.'};

refFile = cfg_files;
refFile.name = 'Reference image';
refFile.tag = 'ref_file';
refFile.filter = {'image'};
refFile.num = [0, 1];
refFile.help = {'choose an image', 'like fa image in reference space.'};

refmat = cfg_files;
refmat.name = 'exploreDTI mat file';
refmat.tag = 'ref_mat';
refmat.filter = {'mat'};
refmat.num = [0, 1];
refmat.help = {'choose a mat file of exploreDTI software', 'the reference DTI recon mat file'};

outFile = cfg_entry;
outFile.name = 'Output file name';
outFile.tag = 'out_file';
outFile.strtype = 's';
outFile.num = [1, 100];
outFile.help = {'give a name for the output image', 'no need for extentional name'};

RecPro = cfg_exbranch;
RecPro.name = 'DWI Reconstruction';
RecPro.tag = 'Rec_exb';
RecPro.val = {DTFile, refFile, refmat, outFile};
RecPro.prog = @cfg_DWI_run_Recon;
RecPro.help = {'from DT image to DWIs'};
