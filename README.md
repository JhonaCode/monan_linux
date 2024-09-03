# monan_linux
MONAN - Model for Ocean-laNd-Atmosphere predictioN

# Required Libraries
1. zlib
2. libpng (if required)
3. HDF5
4. NetCDF
5. JasPer

Generally, these libraries should be their (except for Jasper). If you do not have those then install using the steps below or you directly start from Step 5:

## Setting up the environemnt for Intel compilers

export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc

