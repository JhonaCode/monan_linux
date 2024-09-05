# Listing of options that are usually independent of machine type.

WRF_DIR = /home/users/monan_project/monan_regional/pre/sources/intel/WRF/WRF

# 
#
#   Settings for Linux x86_64
#
#   19.  Linux x86_64, Intel oneAPI compilers    (dmpar)
#
SFC                 = ifort \
SCC                 = icc \
DM_FC               = mpif90 -fc=ifort \
DM_CC               = mpicc -cc=icc \
FC                  = $(DM_FC) \
CC                  = $(DM_CC) \
LD                  = $(FC)
