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

-> export CC=icc \
-> export FC=ifort \
-> export F90=ifort \
-> export CXX=icpc 

### 1. Installing zlib

mkdir wrf_install_intel
cd wrf_install_intel/
wget https://zlib.net/zlib-1.2.11.tar.gz

tar xvf zlib-1.2.11.tar.gz
cd zlib-1.2.11/

./configure --prefix=/home/wrf/wrf_libs_intel/
make
make install
