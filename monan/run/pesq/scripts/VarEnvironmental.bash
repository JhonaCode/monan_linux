#!/bin/bash -x

function VarEnvironmental() {
    local  mensage=$1
    echo   ${mensage}
    export USER_COMPILER=${USER_COMPILER}

    #Jhona
    #export DIR_HOME=`cd ..;pwd`
    #export SUBMIT_HOME=`cd ..;pwd`

    #Folde of the runs
    #export DIR_HOME=/mnt/beegfs/jhonatan.aguirre/MPAS_project/run_pesq
    export DIR_HOME=/home/jhonatan.aguirre/MPAS_project/monan_linux/monan

    export SUBMIT_HOME=/mnt/beegfs/jhonatan.aguirre/MPAS_project/monan_linux

    ##export ERA5_HOME=${SUBMIT_HOME}/pre/datain/regional/era5

    ##export GFS_HOME=${SUBMIT_HOME}/pre/datain/regional/gfs

    #Era 5 folder data
    #export ERA5_HOME=/pesq/dados/bamc/jhonatan.aguirre/DATA/ERA5/MPAS_data/teste_ic
    #export ERA5_HOME=/pesq/dados/bamc/jhonatan.aguirre/DATA/ERA5/MPAS_data/iop1
    export ERA5_HOME=/pesq/dados/bamc/jhonatan.aguirre/DATA/ERA5/MPAS_data/iop2


    export DIRMONAN_PRE_SCR=${DIR_HOME}   # will override scripts at MONAN
    export DIRMONAN_MODEL_SCR=${DIR_HOME}    # will override scripts at MONAN
    export DIRDADOS=/mnt/beegfs/monan/dados/MONAN_v0.1.0 

    #export path_mets=/mnt/beegfs/paulo.kubota/monan_project/metis-5.1.0/build/Linux-x86_64/programs

    export path_mets=/home/paulo_kubota/lib/lib_${USER_COMPILER}/metis/bin

    export NCARG_ROOT=/home/paulo.kubota/.conda/envs/ncl_stable    
    export NCARG_BIN=${NCARG_ROOT}/bin

    export NCAR_Tools=${DIR_HOME}/pre/sources/MPAS-Tools
    export NCAR_MPAS=${NCAR_Tools}/MPAS-Limited-Area
    export version_pos=convert_mpas_v0.1.0_egeon.gnu940

    #export version_model=MONAN-Model_v1.0.0_egeon.gnu940
    export version_model=MONAN-Model_v1.0.0_egeon.${USER_COMPILER}940
    export GREEN='\033[1;32m'  # Green
    export RED='\033[1;31m'    # Red
    export NC='\033[0m'        # No Color
}
