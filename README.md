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

mkdir wrf_install_intel   \
cd wrf_install_intel/   \
wget https://zlib.net/zlib-1.2.11.tar.gz \

tar xvf zlib-1.2.11.tar.gz \
cd zlib-1.2.11/   \

./configure --prefix=/home/wrf/wrf_libs_intel/ \
make \
make install 


### 2. Installing libpng


wget https://onboardcloud.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz \

tar xvf libpng-1.6.37.tar.gz \
cd libpng-1.6.37/ \

./configure --prefix=/home/wrf/wrf_libs_intel/ \
make \
make install

### 3. Installing HDF5

cd ../ \
wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_0/source/hdf5-1.12.0.tar.gz \
./configure --prefix=/home/wrf/wrf_libs_intel/ --with-zlib=/home/wrf/wrf_libs_intel/ --enable-fortran \
make  \
make install

### 4. Installing NetCDF

cd ../ \
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz \
tar xvf netcdf-c-4.7.4.tar.gz \
cd netcdf-c-4.7.4/ 

export LD_LIBRARY_PATH=/home/wrf/wrf_libs_intel/lib:$LD_LIBRARY_PATH \
export LDFLAGS=-L/home/wrf/wrf_libs_intel/lib \
export CPPFLAGS=-I/home/wrf/wrf_libs_intel/include \
./configure --prefix=/home/wrf/wrf_libs_intel/ \
make \
make install 

cd ../ \
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz \
tar xvf netcdf-fortran-4.5.3.tar.gz \
cd netcdf-fortran-4.5.3/ \
./configure --prefix=/home/wrf/wrf_libs_intel/ \
make \
make install
