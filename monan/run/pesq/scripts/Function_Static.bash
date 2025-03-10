#!/bin/bash -x
function Function_Static(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: static
#
# !DESCRIPTION: Script para criar topografia, land use e variáveis estáticas
#
# !CALLING SEQUENCE:
#
#Function_static.sh ${EXP_NAME} ${HOURSSTEP} ${RES_KM} ${EXP_RES}  ${LABELI} ${Domain} ${AreaRegion} ${TypeGrid}
#           o RES_KM     : 015_km
#           o EXP_NAME   : GFS, ERA5, CFSR, etc.
#           o EXP_RES    : 1024002 number of grid cel
#           o LABELI     : Initial: date 2015030600
#           o Domain     : global  or regional
#           o AreaRegion : PortoAlegre
#           o TypeGrid   : quasi_uniform or variable_resolution
#
# For benchmark:
#     ./static.sh 1024002 GFS 1024002
#
# !REVISION HISTORY:Jhonatan A. A. 20 Agosto 2024 
# Adding the make_statitics.sh fucntion. Linha 132  
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_Static.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 8 ]; then
   usage
   exit 1
fi
#
# Args
#
EXP_NAME=${1}
HOURSSTEP=${2}
RES_KM=${3}
RES=${4}
LABELI=${5}
Domain=${6}
AreaRegion=${7}
TypeGrid=${8}

#jhona
################
#EXP_NAME
EXP=${EXP_NAME}_${RES_KM}_${LABELI}_${LABELF}
################


#######################################################
# Set Paths
#######################################################
#
#--- 
HSTMAQ=$(hostname)


BASEDIR=${SUBMIT_HOME}

PREDIR=${BASEDIR}/pre
TBLDIR=${PREDIR}/tables

RUNDIR=${DIR_HOME}/run
SCRDIR=${RUNDIR}/scripts

NMLDIR=${DIR_HOME}/pre/namelist/${version_model}

DATADIR=${PREDIR}/databcs
GEODATA=${DATADIR}/WPS_GEOG
MESHDIR=${DATADIR}/meshes/${TypeGrid}/${Domain}/${RES_KM}

EXECFILEPATH=${SUBMIT_HOME}/pre/exec
SCRIPTFILEPATH=${BASEDIR}/${EXP}/pre/runs
STATICPATH=${SCRIPTFILEPATH}/static

#######################################################
# Selected ncores to submission job
#######################################################

cd ${RUNDIR}

source scripts/Function_Make_Static.bash

source scripts/Function_SetClusterConfig.bash

Function_SetClusterConfig ${RES_KM} ${TypeGrid} 'set Function_SetClusterConfig '

#
# Criando diretorio dados Estaticos
#
if [ ! -e ${STATICPATH}/${AreaRegion}.${RES}.static.nc  ]; then
    echo "File init.statics does not exist, it will be created"
else
    echo "File exists"
    return 44
fi


#######################################################
#Making the statics directory
#######################################################
if [ ! -d ${STATICPATH} ]; then
  mkdir -p ${STATICPATH}/logs
fi

#######################################################
#
# Copy and link the necessary files 
#
#######################################################
#cd ${STATICPATH}

ln -sf ${TBLDIR}/* ${STATICPATH}

ln -sf ${MESHDIR}/${AreaRegion}.${RES}.grid.nc ${STATICPATH}

ln -sf ${MESHDIR}/${AreaRegion}.${RES}.graph.info.part.${cores_stat} ${STATICPATH}

cp -f ${EXECFILEPATH}/init_atmosphere_model ${STATICPATH}

#######################################################
#namelist.init.atmosphere
#######################################################

seconds=`echo ${HOURSSTEP} | awk '{printf "%.0f", $1*3600}'`

sed -e "s,#GEODAT#,${GEODATA},g; \
	s,#RES#,${RES_NUM},g; \
	s,#SECONDS#,${seconds},g;\
	s,#x1#,${AreaRegion},g" \
	${NMLDIR}/namelist.init_atmosphere.STATIC.${Domain} \
       > ${STATICPATH}/namelist.init_atmosphere

#######################################################
#streams.init.atmosphere
#######################################################
sed -e "s,#RES#,${RES_NUM},g; \
	s,#x1#,${AreaRegion},g" \
       	${NMLDIR}/streams.init_atmosphere.STATIC.${Domain} \
	> ${STATICPATH}/streams.init_atmosphere



#############################################################
#######make_static.sh
#############################################################

 Function_Make_Static ${STATICPATH}  'Making make_static_exe.sh'


#Load Egeon Modules
###########################
. ${SCRDIR}/load_monan_app_modules.sh
###########################

cd ${STATICPATH}


sbatch --wait make_static_exe.sh


grep "Finished running" log.init_atmosphere.0000.out >& /dev/null

if [ $? -ne 0 ]; then
   echo "  BUMMER: Static generation failed for some yet unknown reason."
   echo " "
   tail -10 ${STATICPATH}/log.init_atmosphere.0000.out
   echo " "
   exit 21
fi

echo "  ####################################"
echo "  ### Static completed - `date` ####"
echo "  ####################################"
echo " "
#
# clean up and remove links
#

ln -sf ${AreaRegion}.${RES}.static.nc ${SCRIPTFILEPATH}

mv log.init_atmosphere.0000.out ${STATICPATH}/logs
mv Timing  ${STATICPATH}/logs

find ${STATICPATH} -maxdepth 1 -type l -exec rm -f {} \;

}
