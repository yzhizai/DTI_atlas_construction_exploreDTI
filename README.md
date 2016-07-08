# DTI_atlas_construction_exploreDTI
This module is based on matlabbatch and spm, used to construct the DTI Template. Now I just finished the first step, with deformation field to transform **diffusion tensor** to other space, which I called DTI resample.

## DTI Resample

### Prerequisites

* [Matlab](http://cn.mathworks.com/index.html?s_tid=gn_logo)
* [spm12](http://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
* [ExploreDTI](http://www.exploredti.com/)

### Data Preparation

* reference FA image.
* source FA image.
* reference DTI matfile in exploreDTI datatype.
* a deformation field generated from spm normalization

### Flowpath

