function  meanDT = cfg_DT_mean

DTFiles = cfg_files;
DTFiles.name = 'choose the DT files';
DTFiles.tag = 'DT_file';
DTFiles.filter = {'^DT'};
DTFiles.help = {'choose the DT files resampled from template space'};

outFile = cfg_entry;
outFile.name = 'output file name';
outFile.tag = 'outFile';
outFile.strtype = 's';
outFile.num = [1, 100];
outFile.help = {'input the name of the output DT'};

meanDT = cfg_exbranch;
meanDT.name = 'to mean DTs';
meanDT.tag = 'meanDT';
meanDT.val = {DTFiles, outFile};
meanDT.prog = @cfg_DT_run_mean;
meanDT.vout = @cfg_DT_vout_mean;
meanDT.help = {'This is used to mean DTs'};

function vout = cfg_DT_vout_mean(job)

vout = cfg_dep;
vout.sname = 'mean DT';
vout.src_output = substruct('()', {1});







