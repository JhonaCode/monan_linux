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

### 1. Installing zlib

wget https://zlib.net/zlib-1.3.1.tar.gz 

rm -rf zlib-1.3.1 include lib  share

tar -zxvf zlib-1.3.1.tar.gz

cd zlib-1.3.1

./configure --prefix=/home/paulo_kubota/lib/lib_gnu/zlib 

make

make install


### 2. Installing libpng


wget https://onboardcloud.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz \

tar xvf libpng-1.6.37.tar.gz \
cd libpng-1.6.37/ 

./configure --prefix=/home/users/lib/lib_gnu/ \
make \
make install

### 3. Installing HDF5

cd ../ \
wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_0/source/hdf5-1.12.0.tar.gz \
./configure --prefix=/home/users/lib/lib_gnu/ --with-zlib=/home/users/lib/lib_gnu/ --enable-fortran \
make  \
make install

### 4. Installing NetCDF

cd ../ \
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz \
tar xvf netcdf-c-4.7.4.tar.gz \
cd netcdf-c-4.7.4/ 

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/lib:$LD_LIBRARY_PATH \
export LDFLAGS=-L/home/users/lib/lib_gnu/lib \
export CPPFLAGS=-I/home/users/lib/lib_gnu/include \
./configure --prefix=/home/users/lib/lib_gnu/ \
make \
make install 

cd ../ \
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz \
tar xvf netcdf-fortran-4.5.3.tar.gz \
cd netcdf-fortran-4.5.3/ \
./configure --prefix=/home/users/lib/lib_gnu/ \
make \
make install


### 5. Installing JasPer

cd ../ \
wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz \
tar xvf jasper-1.900.29.tar.gz \
./configure --prefix=/home/users/lib/lib_gnu/ \
make \
make install



