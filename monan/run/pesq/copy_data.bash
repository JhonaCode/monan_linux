#!/bin/bash -x
path_prefix_in_submit="/mnt/beegfs/paulo.kubota/monan_linux/monan"
path_prefix_in_home="/home/paulo.kubota/monan_linux/monan"

#path_prefix_out=`cd ..;pwd`
#Myown folder


#Local to create the submit_home
SUBMIT_HOME="/mnt/beegfs/jhonatan.aguirre/MPAS_project/monan_linux"
HOME="/home/jhonatan.aguirre/MPAS_project/monan_linux/monan"

#path_prefix_out=`cd ..;pwd`

if [ ! -e ${SUBMIT_HOME} ];then
   echo  Making the Submit directory:${SUBMIT_HOME}
   mkdir -p ${SUBMIT_HOME}
   mkdir -p ${SUBMIT_HOME}/model
   mkdir -p ${SUBMIT_HOME}/pre
   mkdir -p ${SUBMIT_HOME}/pos
   echo 'x'
fi

#Jhonatan
#Local of the clone directory 
path_prefix_out_submit=${SUBMIT_HOME}
path_prefix_out_home=${HOME}

#jhona
#copy necessary files to separate the subnmit home
copy_sources() {
  local path_in=${1}/pre/sources/MPAS-Tools
  local path_out=${2}/pre/sources/MPAS-Tools

  if [ ! -e ${path_out} ];then
  	mkdir -p  ${path_out}
  fi
  echo "cp -urfp: ${path_in} ${path_out}"
  cp -urfp ${path_in}/* ${path_out}

  local path_in=${1}/model/sources/MONAN-Model_v1.0.0_egeon.gnu940
  local path_out=${2}/model/sources/MONAN-Model_v1.0.0_egeon.gnu940

  if [ ! -e ${path_out} ];then
  	mkdir -p  ${path_out}
  fi
  echo "cp -urfp: ${path_in} ${path_out}"
  cp -urfp ${path_in}/* ${path_out}

  local path_in=${1}/pos/sources/convert_mpas_v0.1.0_egeon.gnu940
  local path_out=${2}/pos/sources/convert_mpas_v0.1.0_egeon.gnu940

  if [ ! -e ${path_out} ];then
  	mkdir -p  ${path_out}
  fi
  echo "cp -urfp: ${path_in} ${path_out}"
  cp -urfp ${path_in}/* ${path_out}

}



copy_mesh_quasi_uniform() {


  local path_in=${1}/pre/databcs/meshes/quasi_uniform/global/015_km
  local path_out=${2}/pre/databcs/meshes/quasi_uniform/global/015_km

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/

  fi


  local path_in=${1}/pre/databcs/meshes/quasi_uniform/global/024_km
  local path_out=${2}/pre/databcs/meshes/quasi_uniform/global/024_km

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/

  fi


}


# Define a function with local variables

copy_mesh_variable_resolution() {
  local path_in=${1}/pre/databcs/meshes/variable_resolution/global/060_015km
  local path_out=${2}/pre/databcs/meshes/variable_resolution/global/060_015km

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi


  local path_in=${1}/pre/databcs/meshes/variable_resolution/global/092_025km
  local path_out=${2}/pre/databcs/meshes/variable_resolution/global/092_025km

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi


}

# Define a function with local variables

copy_mesh_WPS_GEOG() {
  local path_in=${1}/pre/databcs/WPS_GEOG
  local path_out=${2}/pre/databcs/WPS_GEOG

  echo "cp -urfp: ${path_in} ${path_out}"

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	cd ${path_out}/
  	ln -s ${path_in}/* .

  fi
  
}


# Define a function with local variables

copy_mesh_datain_gfs() {
  local path_in=${1}/pre/datain/regional/gfs
  local path_out=${2}/pre/datain/regional/gfs

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"

  	cp -urfp ${path_in}/* ${path_out}/
  fi


  local path_in=${1}/pre/datain/global/gfs
  local path_out=${2}/pre/datain/global/gfs

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  
  	cp -urfp ${path_in}/* ${path_out}/

  fi

}

# Define a function with local variables

copy_mesh_datain_era5() {
  local path_in=${1}/pre/datain/regional/era5
  local path_out=${2}/pre/datain/regional/era5

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi

  local path_in=${1}/pre/datain/global/era5
  local path_out=${2}/pre/datain/global/era5

  if [ ! -e ${path_out} ];then
  	mkdir -p ${path_out}

  	cp -urfp ${path_in}/* ${path_out}/
  fi


}

# Define a function with local variables

copy_mesh_exec() {
  local path_in=${1}/pre/exec/MONAN-Model_v2.0.0_egeon.gnu940/exec
  local path_out=${2}/pre/exec

  if [ ! -e ${path_out} ];then
   	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi

}

# Define a function with local variables

copy_mesh_tables() {
  local path_in=${1}/pre/tables
  local path_out=${2}/pre/tables

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi

}

copy_monan_pre() {
  local path_in=${1}/pre/namelist
  local path_out=${2}/pre/namelist

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in} ${path_out}"
  	
  	cp -urfp ${path_in}/* ${path_out}/
  fi

}

copy_monan_home() {
  local path_in=${1}/model/sources
  local path_out=${2}/model/sources

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}

  	echo "cp -urfp: ${path_in}/MONAN-Model_v2.0.0_egeon.gnu940 ${path_in}"
  	
  	cp -urfp ${path_in}/MONAN-Model_v2.0.0_egeon.gnu940 ${path_out}/
  fi

}

copy_monan_model() {
  local path_in=${1}/model/namelist
  local path_out=${2}/model/namelist

  if [ ! -e ${path_out} ];then

  	mkdir -p ${path_out}
  	
  fi
  echo "cp -urfp: ${path_in}/MONAN-Model_v2.0.0_egeon.gnu940 ${path_out}/"
  cp -urfp ${path_in}/MONAN-Model_v2.0.0_egeon.gnu940 ${path_out}/

}


#souces from git clone to submit home
#copy_sources     ${path_prefix_out_home}      ${path_prefix_out_submit}

#home
#copy_monan_home  ${path_prefix_in_home} ${path_prefix_out_home}
#copy_monan_model ${path_prefix_in_submit} ${path_prefix_out_submit}
##submit
##copy_mesh_quasi_uniform       ${path_prefix_in_submit}  ${path_prefix_out_submit}
##copy_mesh_variable_resolution ${path_prefix_in_submit}  ${path_prefix_out_submit}

copy_mesh_WPS_GEOG            ${path_prefix_in_submit}  ${path_prefix_out_home}

#copy_mesh_datain_gfs          ${path_prefix_in_submit}  ${path_prefix_out_submit}
#copy_mesh_datain_era5         ${path_prefix_in_submit}  ${path_prefix_out_submit}
copy_mesh_exec                ${path_prefix_in_submit}  ${path_prefix_out_home}
copy_mesh_tables              ${path_prefix_in_submit}  ${path_prefix_out_home}
