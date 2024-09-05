# Listing of options that are usually independent of machine type.

WRF_DIR = /home/users/monan_project/monan_regional/pre/sources/gnu/WRF/WRF

# 
#
#   Settings for Linux x86_64
#
#   3.  Linux x86_64, Intel oneAPI compilers    (dmpar)
#
SFC                 = gfortran \
SCC                 = gcc \
DM_FC               = mpif90 \
DM_CC               = mpicc  \
FC                  = $(DM_FC) \
CC                  = $(DM_CC) \
LD                  = $(FC)

