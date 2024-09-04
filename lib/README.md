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
export JASPERINC=/home/users/lib/lib_intel/grib/grib2/include \

####Define all environmental variables LD_LIBRARY_PATH and PATH 

export LD_LIBRARY_PATH=:${LD_LIBRARY_PATH}     \
export PATH=:${PATH}

else

#######################################

####ESMF gnu 

export PYTHON=`which python` 

export PNETCDF=/home/users/lib/lib_gnu/pnetcdf/pnetcdf-1.12.3/PnetCDF \
export NETCDF=/home/users/lib/lib_gnu/netcdf \
export HDF5=/home/users/lib/lib_gnu/hdf5/hdf5-1.12.1/hdf5 \
export JASPERLIB=/home/users/lib/lib_gnu/grib/grib2/lib \
export JASPERINC=/home/users/lib/lib_gnu/grib/grib2/include \

####Define all environmental variables LD_LIBRARY_PATH and PATH 

export LD_LIBRARY_PATH=:${LD_LIBRARY_PATH} \
export PATH=:${PATH}

fi

