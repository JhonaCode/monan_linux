# Setting up the environemnt for gnu compilers

-> export CC=gcc \
-> export FC=gfortran \
-> export F90=gfortran \
-> export CXX=g++ 

mkdir /home/users/lib \
cd /home/users/lib \
mkdir lib_gnu   \
cd lib_gnu/   

### 1. Installing curl

  wget https://curl.se/download/curl-8.9.1.tar.gz

rm -rf curl-8.9.1 bin include lib  share

tar -zxvf curl-8.9.1.tar.gz

cd curl-8.9.1

export CC=gcc

./configure --prefix=/home/users/lib/lib_gnu/curl --without-ssl

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

cmake -DCMAKE_INSTALL_PREFIX=/home/users/lib/lib_gnu/aec/libaec ../libaec-v0.3.2

make

make install

make clean

### 3. Installing zlib

wget https://zlib.net/zlib-1.3.1.tar.gz 

rm -rf zlib-1.3.1 include lib  share

tar -zxvf zlib-1.3.1.tar.gz

cd zlib-1.3.1

./configure --prefix=/home/users/lib/lib_gnu/zlib 

make

make install


### 4. Installing libpng

wget https://onboardcloud.dl.sourceforge.net/project/libpng/libpng16/1.2.57/libpng-1.2.57.tar.gz \

rm -rf libpng-1.2.57

tar -zxvf libpng-1.2.57.tar.gz

cd  libpng-1.2.57

export CC=gcc

export CPPFLAGS='-I/home/users/lib/lib_gnu/zlib/include'

export LDFLAGS='-L/home/users/lib/lib_gnu/zlib/lib'

./configure --prefix=/home/users/lib/lib_gnu/libpng  

make

make install

### 5. Installing Open MPI

wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.gz

rm -rf openmpi-5.0.5

tar -zxvf openmpi-5.0.5.tar.gz

export CC=gcc	      

export CXX=g++	      

export FC=gfortran	  

cd openmpi-5.0.5

./configure  --prefix=/home/users/lib/lib_gnu/openmpi  

make

make install

### 6. Installing HDF5

wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_1/source/hdf5-1.12.1.tar.gz 

rm -rf  hdf5-1.12.1

tar -zxvf  hdf5-1.12.1.tar.gz

export CC=gcc           

export LDFLAGS="-L/home/users/lib/lib_gnu/zlib/lib"      
                            
export CPPFLAGS="-I/home/users/lib/lib_gnu/zlib/include"     
                              
export FC=gfortran       

export CXX=g++    

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/zlib/lib:${LD_LIBRARY_PATH}

cd hdf5-1.12.1

./configure --prefix=/home/users/lib/lib_gnu/hdf5 --enable-fortran --enable-parallel --enable-shared=no --with-zlib=/home/users/lib/lib_gnu/zlib/lib

make

make check

make install

cd hdf5/lib

ln -s libhdf5.a    libhdf5_fortran.a

ln -s libhdf5_hl.a libhdf5_hl_fortran.a

cp /home/users/lib/lib_gnu/zlib/lib/* .

### 7. Installing NetCDF-CC

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.8.1.tar.gz \

rm -rf bin include lib share netcdf-c-4.8.1

tar -zxvf netcdf-c-4.8.1.tar.gz

cd netcdf-c-4.8.1

export CC=gcc

export CXX=g++

export CPPFLAGS="-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_gnu/zlib/include -I/home/users/lib/lib_gnu/curl/include -I/home/users/lib/lib_gnu/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib -L/home/users/lib/lib_gnu/zlib/lib -L/home/users/lib/lib_gnu/curl/lib  -L/home/users/lib/lib_gnu/netcdf/lib"

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:${LD_LIBRARY_PATH}

./configure --prefix="/home/users/lib/lib_gnu/netcdf" --enable-hdf5 --enable-netcdf-4 

make

make check

make install

### 8. Installing NetCDF-C++

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.1.tar.gz \

rm -rf netcdf-cxx4-4.3.1

tar -zxvf netcdf-cxx4-4.3.1.tar.gz

cd netcdf-cxx4-4.3.1

export CC=gcc

export CXX=g++

export CPPFLAGS="-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_gnu/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib      -L/home/users/lib/lib_gnu/netcdf/lib"

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_gnu/netcdf/lib:${LD_LIBRARY_PATH}

./configure --prefix="/home/users/lib/lib_gnu/netcdf" --enable-hdf5 --enable-netcdf-4 --with-hdf5="/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5"

make

make check

make install

### 9. Installing NetCDF-Fortran

wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.4.tar.gz \

rm -rf netcdf-fortran-4.5.4

tar -zxvf netcdf-fortran-4.5.4.tar.gz

cd netcdf-fortran-4.5.4

export CC=gcc

export FC=gfortran

export F77=gfortran

export CXX=g++

export FFLAGS="-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include   -I/home/users/lib/lib_gnu/netcdf/include" 

export FCFLAGS="-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include  -I/home/users/lib/lib_gnu/netcdf/include"    

export CPPFLAGS="-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_gnu/netcdf/include"

export LDFLAGS="-L/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib      -L/home/users/lib/lib_gnu/netcdf/lib"

export LIBS='-lhdf5 -lhdf5_hl  -lnetcdf'

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_gnu/netcdf/lib:${LD_LIBRARY_PATH}

./configure  --prefix="/home/users/lib/lib_gnu/netcdf"  --enable-large-file-tests 

make

make check

make install  

### 10. Installing PnetCDF

wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz

rm -rf pnetcdf-1.12.3

tar -zxvf pnetcdf-1.12.3.tar.gz

cd pnetcdf-1.12.3

mkdir -p /home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF

./configure --prefix=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF MPICC=mpicc   MPICXX=mpicxx  MPIF77=mpif77 MPIF90=mpif90 CC=gcc CXX=g++ F77=gfortran FC=gfortran 

make

make check

make install

### 11. Installing metis

wget https://altushost-swe.dl.sourceforge.net/project/openfoam-extend/foam-extend-3.0/ThirdParty/metis-5.1.0.tar.gz

rm -rf metis-5.1.0 bin lib include

tar -zxvf metis-5.1.0.tar.gz

cd metis-5.1.0

make config shared=0 cc=gcc prefix=/home/users/lib/lib_gnu/metis

make

make install

### 12. Installing pio

netcdf_prefix=/home/users/lib/lib_gnu/netcdf
pnetcdf_prefix=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF

url=https://github.com/NCAR/ParallelIO.git
build=/home/users/lib/lib_gnu/pio/ParallelIO-master
prefix=/home/users/lib/lib_gnu/pio

rm -rf pio-2.5.4
tar -zxvf pio-2.5.4.tar.gz
cd pio-2.5.4

export CPPFLAGS='-I/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/include -I/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF/include  -I/home/users/lib/lib_gnu/netcdf/include  -I/home/users/lib/lib_gnu/netcdf/include'
export LDFLAGS=' -L/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib     -L/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF/lib      -L/home/users/lib/lib_gnu/netcdf/lib '
export LIBS='-lhdf5 -lhdf5_hl -lnetcdf  -lnetcdff -lpnetcdf'
export CC=mpicxx
export FC=mpif90
export CFLAGS=' -fpermissive'
make clean
./configure  --prefix=${prefix}   --enable-fortran   --enable-shared=no
make check
make install

### 13. Installing Openjpeg

wget https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz
 
rm -rf build   lib64   include  bin  lib

rm -rf openjpeg-2.5.2

tar -zxvf v2.5.2.tar.gz

mkdir -p build 

cd build

cmake -DCMAKE_INSTALL_PREFIX=/home/users/lib/lib_gnu/openjpeg ../openjpeg-2.5.2

make

make install

make clean


### 14. Installing JasPer

wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz \
tar xvf jasper-1.900.29.tar.gz \
./configure --prefix=/home/users/lib/lib_gnu/ \
make \
make install

### 15. Installing eccodes

wget eccodes-2.26.0-Source.tar.gz

rm -f eccodes-2.26.0-Source

rm -rf build include lib   lib64   share  bin

tar -zxvf  eccodes-2.26.0-Source.tar.gz

mkdir -p build 

cd build

export AEC_LIBRARY='/home/paulo_kubota/lib/lib_gnu/aec/libaec/lib'   \
export AEC_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/aec/libaec/include' \
export JASPER_LIBRARY='/home/paulo_kubota/lib/lib_gnu/grib/grib2/lib' \
export JASPER_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/grib/grib2/include/jasper' \
export OPENJPEG_LIBRARY='/home/paulo_kubota/lib/lib_gnu/openjpeg/lib'  \
export OPENJPEG_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/openjpeg/include/openjpeg-2.5'  \
export ZLIB_LIBRARY='/home/paulo_kubota/lib/lib_gnu/zlib/lib' \
export ZLIB_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/zlib/include'  \
export PNG_LIBRARY='/home/paulo_kubota/lib/lib_gnu/libpng/lib'   \
export PNG_PNG_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/libpng/include'  \
export NetCDF_C_LIBRARY='/home/paulo_kubota/lib/lib_gnu/netcdf/lib' \
export NetCDF_C_INCLUDE_DIR='/home/paulo_kubota/lib/lib_gnu/netcdf/include'  
cmake -DCMAKE_CXX_COMPILER=g++ -DCMAKE_CXX_FLAGS="-O2 -Wall" -DCMAKE_C_COMPILER=gcc  -DCMAKE_Fortran_FLAGS=gfortran \  \
      -DCMAKE_C_FLAGS="-O2 -Wall" \ \
      -DCMAKE_Fortran_FLAGS="-g -O1 " \
      -DENABLE_NETCDF=ON              \ \
      -DENABLE_JPG=ON                \ \
      -DENABLE_JPG_LIBOPENJPEG=ON    \ \
      -DENABLE_JPG_LIBJASPER=ON    \ \
      -DENABLE_PNG=OFF                \ \
      -DENABLE_FORTRAN=ON             \ \
      -DAEC_PATH=/home/paulo_kubota/lib/lib_gnu/aec/libaec/         \ \
      -DJASPER_PATH=/home/paulo_kubota/lib/lib_gnu/grib/grib2/      \ \
      -DZLIB_PATH=/home/paulo_kubota/lib/lib_gnu/zlib/              \ \
      -DPNG_ROOT=/home/paulo_kubota/lib/lib_gnu/libpng/             \ \
      -DNETCDF_PATH=/home/paulo_kubota/lib/lib_gnu/netcdf/          \ \
      -DOPENJPEG_PATH=/home/paulo_kubota/lib/lib_gnu/openjpeg/      \ \
      -DHDF5_PATH=/home/paulo_kubota/lib/lib_gnu/hdf5/hdf5-1.12.1/  \ \
      -DCMAKE_INSTALL_PREFIX=/home/paulo_kubota/lib/lib_gnu/eccodes ../eccodes-2.26.0-Source

make

ctest 

make install




