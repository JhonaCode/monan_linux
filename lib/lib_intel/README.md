# Setting up the environemnt for intel compilers

-> export CC=icx \
-> export FC=ifx \
-> export F90=ifx \
-> export CXX=icpx 

mkdir /home/users/lib \
cd /home/users/lib \
mkdir lib_intel   \
cd lib_intel/   

### 1. Installing curl

  wget https://curl.se/download/curl-8.9.1.tar.gz

rm -rf curl-8.9.1 bin include lib  share

tar -zxvf curl-8.9.1.tar.gz

cd curl-8.9.1

export CC=icx

./configure --prefix=/home/users/lib/lib_intel/curl --without-ssl

make

make install

### 2. Installing aec

wget https://swprojects.dkrz.de/redmine/attachments/453

rm -rf build 

rm -rf include

rm -rf bin

rm -rf lib

rm -rf libaec-v0.3.2

tar -zxvf libaec-v0.3.2.tar.gz

mkdir -p build 

cd build

cmake -DCMAKE_INSTALL_PREFIX=/home/users/lib/lib_intel/aec/libaec ../libaec-v0.3.2

make

make install

make clean

### 3. Installing zlib

wget https://zlib.net/zlib-1.3.1.tar.gz 

rm -rf zlib-1.3.1 include lib  share

tar -zxvf zlib-1.3.1.tar.gz

cd zlib-1.3.1

./configure --prefix=/home/users/lib/lib_intel/zlib 

make

make install


### 4. Installing libpng

wget https://onboardcloud.dl.sourceforge.net/project/libpng/libpng16/1.2.57/libpng-1.2.57.tar.gz \

rm -rf libpng-1.2.57

tar -zxvf libpng-1.2.57.tar.gz

cd  libpng-1.2.57

export CC=icx

export CPPFLAGS='-I/home/users/lib/lib_intel/zlib/include'

export LDFLAGS='-L/home/users/lib/lib_intel/zlib/lib'

./configure --prefix=/home/users/lib/lib_intel/libpng  

make

make install


### 5. Installing HDF5

wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_1/source/hdf5-1.12.1.tar.gz 

rm -rf  hdf5-1.12.1

tar -zxvf  hdf5-1.12.1.tar.gz

export CC=icx           

export LDFLAGS="-L/home/users/lib/lib_intel/zlib/lib"      
                            
export CPPFLAGS="-I/home/users/lib/lib_intel/zlib/include"     
                              
export FC=ifx       

export CXX=icpx    

export LD_LIBRARY_PATH=/home/users/lib/lib_intel/zlib/lib:${LD_LIBRARY_PATH}

cd hdf5-1.12.1

./configure --prefix=/home/users/lib/lib_intel/hdf5 --enable-fortran --enable-parallel --enable-shared=no --with-zlib=/home/users/lib/lib_intel/zlib/lib

make

make check

make install

cd hdf5/lib

ln -s libhdf5.a    libhdf5_fortran.a

ln -s libhdf5_hl.a libhdf5_hl_fortran.a

cp /home/users/lib/lib_intel/zlib/lib/* .

### 6. Installing NetCDF-CC

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.8.1.tar.gz \

rm -rf bin include lib share netcdf-c-4.8.1

tar -zxvf netcdf-c-4.8.1.tar.gz

cd netcdf-c-4.8.1

export CC=icx

export CXX=icpx

export CPPFLAGS="-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_intel/zlib/include -I/home/users/lib/lib_intel/curl/include -I/home/users/lib/lib_intel/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib -L/home/users/lib/lib_intel/zlib/lib -L/home/users/lib/lib_intel/curl/lib  -L/home/users/lib/lib_intel/netcdf/lib"

export LD_LIBRARY_PATH=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:${LD_LIBRARY_PATH}

./configure --prefix="/home/users/lib/lib_intel/netcdf" --enable-hdf5 --enable-netcdf-4 

make

make check

make install

### 7. Installing NetCDF-C++

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.1.tar.gz \

rm -rf netcdf-cxx4-4.3.1

tar -zxvf netcdf-cxx4-4.3.1.tar.gz

cd netcdf-cxx4-4.3.1

export CC=icx

export CXX=icpx

export CPPFLAGS="-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_intel/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib      -L/home/users/lib/lib_intel/netcdf/lib"

export LD_LIBRARY_PATH=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_intel/netcdf/lib:${LD_LIBRARY_PATH}

./configure --prefix="/home/users/lib/lib_intel/netcdf" --enable-hdf5 --enable-netcdf-4 --with-hdf5="/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5"

make

make check

make install

### 8. Installing NetCDF-Fortran

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.4.tar.gz \

rm -rf netcdf-fortran-4.5.4

tar -zxvf netcdf-fortran-4.5.4.tar.gz

cd netcdf-fortran-4.5.4

export CC=icx

export FC=ifx

export F77=ifx

export CXX=icpx

export FFLAGS="-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include   -I/home/users/lib/lib_intel/netcdf/include" 

export FCFLAGS="-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include  -I/home/users/lib/lib_intel/netcdf/include"    

export CPPFLAGS="-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_intel/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib      -L/home/users/lib/lib_intel/netcdf/lib"

export LIBS='-lhdf5 -lhdf5_hl  -lnetcdf'

export LD_LIBRARY_PATH=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_intel/netcdf/lib:${LD_LIBRARY_PATH}

./configure  --prefix="/home/users/lib/lib_intel/netcdf"  --enable-large-file-tests 

make

make check

make install  

### 9. Installing PnetCDF

wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz

rm -rf pnetcdf-1.12.3

tar -zxvf pnetcdf-1.12.3.tar.gz

cd pnetcdf-1.12.3

mkdir -p /home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF

./configure --prefix=/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF MPICC='mpicc -cc=icx'   MPICXX='mpicxx=icpx'  MPIF77='mpif77 -fc=ifx' MPIF90='mpif90 -f90=ifx' CC=icx CXX=icpx F77=ifx FC=ifx 

make

make check

make install

### 10. Installing metis

wget https://altushost-swe.dl.sourceforge.net/project/openfoam-extend/foam-extend-3.0/ThirdParty/metis-5.1.0.tar.gz

rm -rf metis-5.1.0 bin lib include

tar -zxvf metis-5.1.0.tar.gz

cd metis-5.1.0

make config shared=0 cc=icx prefix=/home/users/lib/lib_intel/metis

make

make install

### 11. Installing pio

netcdf_prefix=/home/users/lib/lib_intel/netcdf
pnetcdf_prefix=/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF

url=https://github.com/NCAR/ParallelIO.git
build=/home/users/lib/lib_intel/pio/ParallelIO-master
prefix=/home/users/lib/lib_intel/pio

rm -rf pio-2.5.4
tar -zxvf pio-2.5.4.tar.gz
cd pio-2.5.4

export CPPFLAGS='-I/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF/include  -I/home/users/lib/lib_intel/netcdf/include  -I/home/users/lib/lib_intel/netcdf/include'
export LDFLAGS=' -L/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib     -L/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF/lib      -L/home/users/lib/lib_intel/netcdf/lib '
export LIBS='-lhdf5 -lhdf5_hl -lnetcdf  -lnetcdff -lpnetcdf'
export CC='mpicc -cc=icx'
export FC='mpif90 -f90=icx'
export CFLAGS=' -fpermissive'
make clean
./configure  --prefix=${prefix}   --enable-fortran   --enable-shared=no
make check
make install

### 12. Installing Openjpeg

wget https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz
 
rm -rf build   lib64   include  bin  lib

rm -rf openjpeg-2.5.2

tar -zxvf v2.5.2.tar.gz

mkdir -p build 

cd build

cmake -DCMAKE_INSTALL_PREFIX=/home/users/lib/lib_intel/openjpeg ../openjpeg-2.5.2

make

make install

make clean


### 13. Installing JasPer

wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz \
tar xvf jasper-1.900.29.tar.gz \
./configure --prefix=/home/users/lib/lib_intel/ \
make \
make install

### 14. Installing eccodes

wget eccodes-2.26.0-Source.tar.gz

rm -f eccodes-2.26.0-Source

rm -rf build include lib   lib64   share  bin

tar -zxvf  eccodes-2.26.0-Source.tar.gz

mkdir -p build 

cd build

export AEC_LIBRARY='/home/users/lib/lib_intel/aec/libaec/lib'   \
export AEC_INCLUDE_DIR='/home/users/lib/lib_intel/aec/libaec/include' \
export JASPER_LIBRARY='/home/users/lib/lib_intel/grib/grib2/lib' \
export JASPER_INCLUDE_DIR='/home/users/lib/lib_intel/grib/grib2/include/jasper' \
export OPENJPEG_LIBRARY='/home/users/lib/lib_intel/openjpeg/lib'  \
export OPENJPEG_INCLUDE_DIR='/home/users/lib/lib_intel/openjpeg/include/openjpeg-2.5'  \
export ZLIB_LIBRARY='/home/users/lib/lib_intel/zlib/lib' \
export ZLIB_INCLUDE_DIR='/home/users/lib/lib_intel/zlib/include'  \
export PNG_LIBRARY='/home/users/lib/lib_intel/libpng/lib'   \
export PNG_PNG_INCLUDE_DIR='/home/users/lib/lib_intel/libpng/include'  \
export NetCDF_C_LIBRARY='/home/users/lib/lib_intel/netcdf/lib' \
export NetCDF_C_INCLUDE_DIR='/home/users/lib/lib_intel/netcdf/include'  
cmake -DCMAKE_CXX_COMPILER=icpx -DCMAKE_CXX_FLAGS="-O2 -Wall" -DCMAKE_C_COMPILER=icx  \ \
      -DCMAKE_Fortran_FLAGS=ifx  \  \
      -DCMAKE_C_FLAGS="-O2 -Wall"  \ \
      -DCMAKE_Fortran_FLAGS="-g -O1 " \ \
      -DENABLE_NETCDF=ON              \ \
      -DENABLE_JPG=ON                \ \
      -DENABLE_JPG_LIBOPENJPEG=ON    \ \
      -DENABLE_JPG_LIBJASPER=ON    \ \
      -DENABLE_PNG=OFF                \ \
      -DENABLE_FORTRAN=ON             \ \
      -DAEC_PATH=/home/users/lib/lib_intel/aec/libaec/         \ \
      -DJASPER_PATH=/home/users/lib/lib_intel/grib/grib2/      \ \
      -DZLIB_PATH=/home/users/lib/lib_intel/zlib/              \ \
      -DPNG_ROOT=/home/users/lib/lib_intel/libpng/             \ \
      -DNETCDF_PATH=/home/users/lib/lib_intel/netcdf/          \ \
      -DOPENJPEG_PATH=/home/users/lib/lib_intel/openjpeg/      \ \
      -DHDF5_PATH=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/  \ \
      -DCMAKE_INSTALL_PREFIX=/home/users/lib/lib_intel/eccodes ../eccodes-2.26.0-Source

make

ctest 

make install

### 15. Installing cdo

wget  https://code.mpimet.mpg.de/attachments/download/29616/cdo-2.4.3.tar.gz

rm -rf cdo-2.4.3 \
tar -zxvf cdo-2.4.3.tar.gz 

cd cdo-2.4.3 

export CC=icx \
export CFLAGS= \
export LDFLAGS= \
export CXX=icpx \
export CXXFLAGS= \
export CXXCPP= \
export F77=ifx \
export FFLAG= \
export CPP= 

./configure --prefix=/home/users/lib/lib_intel/cdo  --with-netcdf=/home/users/lib/lib_intel/netcdf --with-hdf5=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5 \
make \
make install


### 16. Installing grib2

wget https://github.com/NOAA-EMC/wgrib2/archive/refs/tags/v3.1.0.tar.gz

rm -rf grib2

tar -zxvf wgrib2.tgz.v3.1.0

cd grib2

export FC=ifx

export CC="icx "

export CXX="icpx "

make clean

make 

make lib

cd lib

ln -s libpng12.a libpng.a 

### 17. Installing ncl

wget https://www.earthsystemgrid.org/dataset/ncl.662.dap/file/ncl_ncarg-6.6.2-Debian8.11_64bit_intel492.tar.gz

or

####### Installation via conda

The current version of NCL is [6.6.2](http://www.ncl.ucar.edu/current_release.shtml), which can be installed via [conda](http://www.ncl.ucar.edu/Download/conda.shtml).

```
conda create -n ncl_stable -c conda-forge ncl

ls -a

check directory .conda/

~/.conda$ ls /
aau_token  environments.txt

more environments.txt /
/home/paulo_kubota/anaconda3 /
/home/paulo_kubota/anaconda3/envs/ncl_stable 

### 18. Installing grads
wget https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-intel-glibc_2.11.3.tar.gz/download
