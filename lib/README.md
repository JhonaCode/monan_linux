# Check if the following commands are installed:

```
 make 
 gmake 
 cmake
```

# Configure user account environment (.bashrc)
export USER_COMPILER=intel

if [[ "$USER_COMPILER" == "intel" ]];then

#######################################

####ESMF intel

export PYTHON=`which python` 

source /home/users/intel/oneapi/setvars.sh --force

export PNETCDF=/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF \
export NETCDF=/home/users/lib/lib_intel/netcdf \
export HDF5=/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5 \
export JASPERLIB=/home/users/lib/lib_intel/grib/grib2/lib \
export JASPERINC=/home/users/lib/lib_intel/grib/grib2/include 

####Define all environmental variables LD_LIBRARY_PATH and PATH 

export LD_LIBRARY_PATH=:${LD_LIBRARY_PATH}     \
export PATH=:${PATH}

export LD_LIBRARY_PATH=/home/users/lib/lib_intel/grib/grib2/lib:/home/users/lib/lib_intel/zlib/lib:/home/users/lib/lib_intel/pio/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_intel/aec/libaec/lib:/home/users/lib/lib_intel/zlib/lib:/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_intel/netcdf/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_intel/openjpeg/lib:/home/users/lib/lib_intel/libpng/lib:/home/users/lib/lib_intel/eccodes/lib:/home/users/lib/lib_intel/curl/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF/lib:/home/users/lib/lib_intel/netcdf/lib:/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_intel/metis/lib:${LD_LIBRARY_PATH}

export PATH=/home/users/lib/lib_intel/zlib/bin:/home/users/lib/lib_intel/pio/bin:${PATH} \
export PATH=/home/users/lib/lib_intel/aec/libaec/bin:/home/users/lib/lib_intel/zlib/bin:/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/bin:/home/users/lib/lib_intel/netcdf/bin:${PATH} \
export PATH=/home/users/lib/lib_intel/openjpeg/bin:/home/users/lib/lib_intel/libpng/bin:/home/users/lib/lib_intel/eccodes/bin:/home/users/lib/lib_intel/curl/bin:${PATH} \
export PATH=/home/users/lib/lib_intel/pnetcdf/pnetcdf-1.12.3/PnetCDF/bin:/home/users/lib/lib_intel/netcdf/bin:/home/users/lib/lib_intel/hdf5/hdf5-1.12.1/hdf5/lib:${PATH} \
export PATH=/home/users/lib/lib_intel/metis/bin:/home/users/lib/lib_intel/grads/opengrads-2.2.1.oga.1/Contents:${PATH}

else

#######################################

####ESMF gnu 

export PYTHON=`which python` 

export PNETCDF=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF \
export NETCDF=/home/users/lib/lib_gnu/netcdf \
export HDF5=/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5 \
export JASPERLIB=/home/users/lib/lib_gnu/grib/grib2/lib \
export JASPERINC=/home/users/lib/lib_gnu/grib/grib2/include 

####Define all environmental variables LD_LIBRARY_PATH and PATH 

export LD_LIBRARY_PATH=:${LD_LIBRARY_PATH} \
export PATH=:${PATH}

export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/grib/grib2/lib:/home/users/lib/lib_gnu/zlib/lib:/home/users/lib/lib_gnu/pio/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/aec/libaec/lib:/home/users/lib/lib_gnu/zlib/lib:/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:/home/users/lib/lib_gnu/netcdf/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/openjpeg/lib:/home/users/lib/lib_gnu/libpng/lib:/home/users/lib/lib_gnu/eccodes/lib:/home/users/lib/lib_gnu/curl/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF/lib:/home/users/lib/lib_gnu/netcdf/lib:/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:${LD_LIBRARY_PATH} \
export LD_LIBRARY_PATH=/home/users/lib/lib_gnu/metis/lib:${LD_LIBRARY_PATH}

export PATH=/home/users/lib/lib_gnu/zlib/bin:/home/users/lib/lib_gnu/pio/bin:${PATH} \
export PATH=/home/users/lib/lib_gnu/aec/libaec/bin:/home/users/lib/lib_gnu/zlib/bin:/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/bin:/home/users/lib/lib_gnu/netcdf/bin:${PATH} \
export PATH=/home/users/lib/lib_gnu/openjpeg/bin:/home/users/lib/lib_gnu/libpng/bin:/home/users/lib/lib_gnu/eccodes/bin:/home/users/lib/lib_gnu/curl/bin:${PATH} \
export PATH=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF/bin:/home/users/lib/lib_gnu/netcdf/bin:/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5/lib:${PATH} \
export PATH=/home/users/lib/lib_gnu/metis/bin:/home/users/lib/lib_gnu/grads/opengrads-2.2.1.oga.1/Contents:${PATH}

fi

