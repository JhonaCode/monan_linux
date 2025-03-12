#!/bin/bash -x

# Define a function with local variables

Function_RunModel() {
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: Function_RunModel
#
# !DESCRIPTION:
#        Script para rodar o MONAN
#        Realiza as seguintes tarefas:
#           o Ungrib os dados do GFS, ERA5
#           o Interpola para grade do modelo
#           o Cria condicao inicial e de fronteria
#           o Integra o modelo MONAN
#           o Pos-processamento (netcdf para grib2, regrid latlon, crop)
#
# !CALLING SEQUENCE:
#     
#        ./Function_RunModel.egeon EXP_NAME RES LABELI
#
# For benchmark:
#        ./Function_RunModel.egeon CFSR ${EXP_RES} 2010102300
#
# For ERA5 datasets
#
#        ./Function_RunModel.egeon ERA5 ${EXP_RES} 2021010100
#        ./Function_RunModel  ${RES_KM} ${EXP_NAME} ${EXP_RES} ${LABELI} ${LABELF}  ${Domain} ${AreaRegion} ${TypeGrid}
#           o RES_KM     : 060_015km
#           o EXP_NAME   : GFS, ERA5
#           o EXP_RES    : mesh npts : 535554 etc
#           o LABELI     : Initial: date 2015030600
#           o LABELF     : End: date 2015030600
#           o Domain     : Domain: global or regional
#           o AreaRegion : PortoAlegre, Belem, global
#           o TypeGrid   : quasi_uniform or variable_resolution
#
#
# !REVISION HISTORY:
# 30 sep 2022 - JPRF
# 12 oct 2022 - GAM Group - MONAN on EGEON DELL cluster
# 23 oct 2022 - GAM Group - MONAN benchmark on EGEON
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_RunModel.bash | head -n -1
}

######################################
# Verificando argumentos de entrada
#

if [ $# -ne 11 ]; then
   usage
   exit 1
fi

source scripts/Function_SetClusterConfig.bash
source scripts/Function_Submit_Egeon.bash
######################################

#
# pegando argumentos
#
EXP=${1}
HOURSSTEP=${2}
INPUT_INTERVAL=${3}
EXP_NAME=${4}
RES_KM=${5}
EXP_RES=${6}
LABELI=${7} 
LABELF=${8}
Domain=${9}
AreaRegion=${10}
TypeGrid=${11}


######################################
#dates to check the initial condition 

start_date=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}.00.00
end_date=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}.00.00

start_date2=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}:00:00
end_date2=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}:00:00
#end_date2=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_01:00:00

######################################
#
# Caminhos
#
HSTMAQ=$(hostname)

#Model 
SCRDIR=${DIR_HOME}/pesq/run/scripts
HOMEMODEL=${DIR_HOME}/model 
NMLDIR=${HOMEMODEL}/namelist/${version_model}
#EXECPATH=${HOMEMODEL}/exec/${version_model}/exec





#Submit
BASEDIR=${SUBMIT_HOME}
PREHOME=${BASEDIR}/pre
TBLDIR=${PREHOME}/tables
DIR_MESH=${PREHOME}/databcs/meshes/${TypeGrid}/${Domain}/${RES_KM}
EXECPATH=${SUBMIT_HOME}/model/exec/${version_model}/exec
PREDIR=${BASEDIR}/${EXP}/pre/runs
EXPIC=${PREDIR}/wpsprd

#MOdel submit
EXPDIR=${BASEDIR}/${EXP}/model/runs/${EXP_NAME}
LOGDIR=${EXPDIR}/logs


#Initial condition of the experiment
OPERDIR=${ERA5_HOME}
BNDDIR=${ERA5_HOME}

###############################################################################
# To check if the Initial and Boundary Condition Exist. 
# Initial Conditions: 
###############################################################################

if [ ! -f ${EXPIC}/lbc.${end_date}.nc ]; then
   echo "Condicao de contorno inexistente !"
   echo "Verifique a pasta da condicoes iniciais."
   echo "Criada do Pre."
   echo "$0 ${EXPIC}"
   #close for running only the model
   exit 1
fi


################################################################################
#  os tamanhos dos intervalos de tempo geralmente recebem o valor de 6x do espaçamento da grade em km.

 Function_SetClusterConfig ${EXP_RES} ${TypeGrid} 'set Function_SetClusterConfig '


#
# Criando diretorios da rodada
#
# logs
# scripts
# pre-processing
# production 
# post-processing: 
# tables
# parameters
if [ -e ${EXPDIR} ]; then
   rm -f ${EXPDIR}
fi

if [ ! -e ${EXPDIR} ]; then
   mkdir -p ${EXPDIR}
fi

mkdir -p ${EXPDIR}/logs
mkdir -p ${EXPDIR}/monanprd

###############################################################################
#Necesary files to run. 

#Copy atmosphere model which runs  
cp -u ${EXECPATH}/atmosphere_model ${EXPDIR}

#Thompson Tables
#RTTMG
cp -u ${TBLDIR}/* ${EXPDIR}

#Copy streams...
cp -u ${NMLDIR}/stream_list.atmosphere.* ${EXPDIR}

#Copy the region.init.nc
cp -u ${PREDIR}/${AreaRegion}.${RES_NUM}.init.nc       ${EXPDIR}

#cp -u ${PREDIR}/${AreaRegion}.${RES_NUM}.sfc_update.nc ${EXPDIR}


#To attach graph.info Regional 
ln -sf ${DIR_MESH}/${AreaRegion}.${RES_NUM}.graph.info.part.${cores_model} ${EXPDIR}

#To attach the initial and boundary condition from the pre diretory.
ln -sf ${EXPIC}/lbc.*.nc ${EXPDIR}

#Remove old diag run 
rm -f ${EXPDIR}/diag*.nc 

rm -f ${EXPDIR}/hist*.nc 

rm -f ${EXPDIR}/restart*.nc 

rm -f ${EXPDIR}/log*

###############################################################################
#
#                             Rodando o Modelo
#
###############################################################################
#
#               Modified the Namelist: Parameterization 
#
###############################################################################

#!configuration for cloud convection schemes 
#'cu_ntiedtke','cu_grell_freitas','off'

#!configuration for cloud microphysics schemes 
#suite','mp_wsm6','mp_thompson','mp_kessler','off' (default: suite)

#cu_conv='cu_grell_freitas'
#cu_micro='mp_thompson'

sed -e "s,#LABELI#,${start_date2},g;\
        s,#LABELF#,${end_date2},g;\
        s,#RESNPTS#,${RES_NUM},g;\
        s,#STEPMODEL#,${dt_step},g;\
        s,#LEN_DISP#,${len_disp},g;\
        s,#x1#,${AreaRegion},g"\
        ${NMLDIR}/namelist.atmosphere.TEMPLATE.${Domain} > ${EXPDIR}/namelist.atmosphere.temp

###############################################################################
#
#               Modified the Namelist: Parameterization 
#
###############################################################################


sed -e "s,#RESNPTS#,${RES_NUM},g;\
        s,#x1#,${AreaRegion},g;\
        s,#INPUT_INTERVAL#,${INPUT_INTERVAL},g;\
        s,#HOUR_STEP#,${HOURSSTEP},g"\
        ${NMLDIR}/streams.atmosphere.TEMPLATE.${Domain} > ${EXPDIR}/streams.atmosphere

###############################################################################
#
#               Modified the Namelist: Parameterization 
#########################################################
#Making   MONANR.sh

#JobName 
JobName=MONANR

#script to run 
SCRIPT=atmosphere_model

#To Make InitAtmos_IC_exe.sh
 Function_Submit_Egeon ${SCRIPT} ${EXPDIR} ${LOGDIR} ${cores_model} ${JobName}  ${partition}

##################################################

}
