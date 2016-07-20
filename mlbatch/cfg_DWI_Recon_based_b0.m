function RecPro2 = cfg_DWI_Recon_based_b0

DTFile = cfg_files;
DTFile.name = 'DT image';
DTFile.tag = 'DT_file';
DTFile.filter = {'nii'};
DTFile.num = [0, 1];
DTFile.help = {'choose the DT image', 'a 4-D image storing diffusion tensor elements.'};

b0File = cfg_files;
b0File.name = 'b0 image';
b0File.tag = 'b0_file';
b0File.filter = {'image'};
b0File.num = [0, 1];
b0File.help = {'choose an b0 image'};

bvalFile = cfg_files;
bvalFile.name = 'bval image';
bvalFile.tag = 'bval_file';
bvalFile.filter = {'bval'};
bvalFile.num = [0, 1];
bvalFile.help = {'choose an bval file'};

bvecFile = cfg_files;
bvecFile.name = 'bvec image';
bvecFile.tag = 'bvec_file';
bvecFile.filter = {'bvec'};
bvecFile.num = [0, 1];
bvecFile.help = {'choose an bvec file'};


outFile = cfg_entry;
outFile.name = 'Output file name';
outFile.tag = 'out_file';
outFile.strtype = 's';
outFile.num = [1, 100];
outFile.help = {'give a name for the output image', 'no need for extentional name'};

RecPro2 = cfg_exbranch;
RecPro2.name = 'DWI Reconstruction based on b0';
RecPro2.tag = 'Rec_exb2';
RecPro2.val = {DTFile, b0File, bvalFile, bvecFile, outFile};
RecPro2.prog = @cfg_DWI_run_Recon_based_b0;
RecPro2.help = {'from DT image to DWIs', 'If you find the gradient direction with something wrong', ...
    'it may be for we predefined the gradient adjust plan'};