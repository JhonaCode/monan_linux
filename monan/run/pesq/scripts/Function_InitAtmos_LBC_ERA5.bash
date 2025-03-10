#!/bin/bash -x
function Function_InitAtmos_LBC_ERA5(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: static
#
# !DESCRIPTION: Script para criar topografia, land use e variáveis estáticas
#
# !CALLING SEQUENCE:
#
#Function_InitAtmos_IC_GFS.sh ${RES_KM} ${EXP_NAME} ${EXP_RES}  ${LABELI}  ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}
#           o RES_KM     : 015_km
#           o EXP_NAME   : GFS, ERA5, CFSR, etc.
#           o EXP_RES    : 1024002 number of grid cel
#           o LABELI     : Initial: date 2015030600
#           o LABELF     : End    : date 2015030600
#           o Domain     : global  or regional
#           o AreaRegion : PortoAlegre
#           o TypeGrid   : quasi_uniform or variable_resolution
#
# For benchmark:
#     ./Function_InitAtmos_LBC_ERA5 1024002 GFS 1024002
#
# !REVISION HISTORY: 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC



function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_InitAtmos_LBC_ERA5.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 11 ]; then
   usage
   exit 1
fi
#
# Args
#
   EXP_IBC=${1}
   HOURSSTEP=${2}
   EXP_NAME=${3}
   RES_KM=${4}
   EXP_RES=${5}
   NLEV=${6}
   LABELI=${7}
   LABELF=${8}
   Domain=${9}
   AreaRegion=${10}
   TypeGrid=${11}

   start_date=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}:00:00
   end_date=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}:00:00

#jhona
#########################################################
#EXP_NAME
EXP=${EXP_NAME}_${RES_KM}_${LABELI}_${LABELF}

####################################################################
#
# Paths of necessary folders 
#
####################################################################
HOMEPRE=${DIR_HOME}/pre 
RUNDIR=${DIR_HOME}/run/scripts
SCRDIR=${RUNDIR}/scripts
NMLDIR=${HOMEPRE}/namelist/${version_model}
TBLDIRGRIB=${HOMEPRE}/Variable_Tables
EXECPATH=${HOMEPRE}/exec

DIR_MESH=${SUBMIT_HOME}/pre/databcs/meshes/${TypeGrid}/${Domain}/${RES_KM}

BASEDIR=${SUBMIT_HOME}
PREDIR=${BASEDIR}/${EXP}/pre
DATADIR=${PREDIR}/datain/${Domain}/${EXP_IBC}

SCRIPTFILEPATH=${PREDIR}/runs
STATICPATH=${SCRIPTFILEPATH}/static

EXPDIR=${PREDIR}/runs
#Directory to save the IC 
EXPIC=${EXPDIR}/wpsprd

LOGDIR=${EXPDIR}/logs

USERDATA=`echo ${EXP} | tr '[:upper:]' '[:lower:]'`

OPERDIR=${ERA5_HOME}
BNDDIR=${ERA5_HOME}

#Path to save the era5 ic 
path_reg=${DATADIR}


cd ${RUNDIR}
source scripts/Function_Submit_Egeon.bash
#########################################################
# selected ncores to submission job
#

Function_SetClusterConfig ${RES_KM} ${TypeGrid} 'set Function_SetClusterConfig '

#########################################################
# Criando diretorios da rodada
if [ -e ${EXPDIR} ]; then
   mkdir -p ${EXPDIR}
   mkdir -p ${EXPDIR}/logs   
   mkdir -p ${EXPDIR}/sst
   mkdir -p ${EXPDIR}/wpsprd
   mkdir -p ${EXPDIR}/scripts
fi


###############################################################################
#
#             Initial conditions (ANALYSIS/ERA5) for MONAN grid
#
###############################################################################

TYPE='LBC'

seconds=`echo ${HOURSSTEP} | awk '{printf "%.0f", $1*3600}'`


sed -e "s,#LABELI#,${start_date},g;\
        s,#LABELF#,${end_date},g;\
	s,#NLEV#,${NLEV},g;\
	s,#GEODAT#,${GEODATA},g;\
	s,#RESNPTS#,${RES_NUM},g;\
	s,#SECONDS#,${seconds},g;\
	s,#PREFIX#,${EXP_IBC},g;\
	s,#x1#,${AreaRegion},g"\
	 ${NMLDIR}/namelist.init_atmosphere.LBC.${Domain} >  ${EXPDIR}/namelist.init_atmosphere

sed -e "s,#RESNPTS#,${RES_NUM},g;\
	s,#HOURSSTEP#,${HOURSSTEP},g;
	s,#x1#,${AreaRegion},g;"\
	 ${NMLDIR}/streams.init_atmosphere.LBC.${Domain} >  ${EXPDIR}/streams.init_atmosphere



#########################################################
# Submit Init_atmophere_model 
#########################################################
#Copy necessary file before submiting 

ln -sf ${DIR_MESH}/${AreaRegion}.${RES_NUM}.graph.info.part.${cores} ${EXPDIR}

ln -sf ${DIR_MESH}/${AreaRegion}.${RES_NUM}.graph.info.part.${cores} ${EXPDIR}

ln -sf  ${STATICPATH}/${AreaRegion}.${RES_NUM}.static.nc ${EXPDIR}

ln -sf  ${STATICPATH}/${AreaRegion}.${RES_NUM}.static.nc ${EXPDIR}

cp -f  ${EXECPATH}/init_atmosphere_model ${EXPDIR}/init_atmosphere_model


#########################################################
#Making   Init_atmosphere_ic_exe.sh

#JobName 
JobName=InitAtmos_LBC_exe

#script to run 
SCRIPT=init_atmosphere_model

#To Make InitAtmos_IC_exe.sh
 Function_Submit_Egeon ${SCRIPT} ${EXPDIR} ${LOGDIR} ${cores} ${JobName}  ${partition}


#########################################################
#Load Egeon Modules
. ${SCRDIR}/load_monan_app_modules.sh
#########################################################
#Run   Init_atmosphere_ic_exe.sh
echo -e  "${GREEN}==>${NC} Submiting ${JobName}.sh...\n"

cd ${EXPDIR}


sbatch --wait ${JobName}.sh

##################################################
#
#To check the output
#
##################################################

FILE2CHECK=${AreaRegion}.${RES_NUM}.init.nc

if [[ ! -e "${FILE2CHECK}" ]]; then

  echo -e  "\n${RED}==>${NC} ***** ATTENTION *****\n"	
  echo -e  "${RED}==>${NC}  Executing  ${JOBNAME}.sh fails to generate ${FILE2CHECK} \n"
  echo -e  "${RED}==>${NC}  view ${FOLDER2RUN}/log.init_atmosphere" 
  echo -e  "Check logs at ${EXPDIR}/logs.\n" 
  echo -e  "Exiting script.\n"
  exit -1
else
  echo -e  "${GREEN}==>${NC}  Successful completion of bash ${JOBNAME}.sh to generate ${FILE2CHECK} \n"

fi

#Moving all initial and lateral condition to wpsprd folder
mv lbc.* ${EXPIC}

}
