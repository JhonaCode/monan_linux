#!/bin/bash -x
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: runPost
#
# !DESCRIPTION:
#        Script para rodar o Post-Processing of MONAN
#        Realiza as seguintes tarefas:
#           o Pos-processamento (netcdf para grib2, regrid latlon, crop)
#
# !CALLING SEQUENCE:
#     
#   ./runPost.bash  ${EXP_NAME} ${EXP_RES}   ${LABELI}  ${LABELF}  ${Domain}  ${AreaRegion}  ${TypeGrid}
#
#
# For GFS datasets
#
#        ./runPost.bash  GFS 535554   2024042700  2024050100  regional  PortoAlegre  variable_resolution
#
#           o EXP_NAME   : Forcing: ERA5, CFSR, GFS, etc.
#           o EXP_RES    : mesh npts : 535554 etc
#           o LABELI     : Initial: date 2015030600
#           o LABELF     : End: date 2015030600
#           o Domain     : Domain: global or regional
#           o AreaRegion : PortoAlegre, Belem, global
#           o TypeGrid   : quasi_uniform or variable_resolution
#
#
# For benchmark:
#
#  Extreme event in southern Brazil (flooding)
#
#./runPost.bash    GFS   163842   2024042700  2024050100  regional  Sul      variable_resolution
#
#    Hurricane Catarina
#
#./runPost.bash    ERA5  163842   2004032400  2004032800  regional  Sul       variable_resolution
#
#   meteorological instability line LI-NORDESTE
#
#./runPost.bash    ERA5  163842   2010101600  2010102000  regional  Nordeste  variable_resolution
#
#   meteorological instability line LI-NORTE
#
#./runPost.bash    ERA5  163842   2013043000  2013050400  regional  Norte     variable_resolution
#
#   meteorological easterly wave  NORDESTE
#
#./runPost.bash    ERA5  163842   2019052500  2019052900  regional  Nordeste  variable_resolution
#
#
# !REVISION HISTORY:
#
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
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./runPost.bash | head -n -1
}

#Specified the model run data folder.
EXP_FOLDER=goamazon7
#Domain regional to run
AreaRegion=goamazon7

#'mesoscale_reference','convection_permitting','none'
reference='mesoscale_reference'

#reference='convection_permitting'
# 'cu_ntiedtke' 'cu_grell_freitas <10km' 'cu kain fritsch'
cld_conv='cu_grell_freitas'
#cld_conv='cu_ntiedtke'

# 'mp_wsm6'  'mp_thompson'  'mp_thompson'  'mp_kessler'
cld_micro='mp_thompson'

# 'suite','sf_monin_obukhov','sf_mynn','off' (default: suite)
pbl_sche='suite'

#Step of hour boundary conditions
HOURS_STEP_BC=3

#Resolution in Km: 3, 4, 7, 15 , 20  
export EXP_RES=15

#Initial and Final Date 
export LABELI=2014090204 #00 utc-4
export LABELF=2014090304 #00 utc-4

TypeGrid='quasi_uniform'

###############################
#To load the output in python 
###############################

namepyload=sep_02

pathpyload=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/MPAS_shca

export EXP_NAME=${cld_conv}_${reference}_${cld_micro}_${pbl_sche}_HS${HOURS_STEP_BC}

#################################################################
# No necessary to modified below.  
#################################################################

#
# Verificando argumentos de entrada
# Se os parametros sao definidos na chamada
if [ $# -ne 8 ]; then

	echo 'Os Argumentos foram lidos do scrip runPost' 
else 
	echo 'Argumentos foram definidos na Chamada'
	export EXP_FOLDER=${1}            
	export EXP_NAME=${2}            
	export EXP_RES=${3}            
	export LABELI=${4}
	export LABELF=${5}
	export Domain=${6}
	export AreaRegion=${7}  
	export TypeGrid=${8}
fi


source scripts/VarEnvironmental.bash
source scripts/Function_SetResolution.bash
source scripts/Function_SetClusterConfig.bash
source scripts/Function_RunPost.bash
source scripts/Function_Create_ctl.bash
source scripts/python/load_python.bash

 VarEnvironmental "export Environmental Variable "
 Function_SetResolution ${EXP_RES} ${TypeGrid} "set resolution"


#####################################################
##Complete experiment name
#Name of the Model  directory
EXP=${EXP_FOLDER}_${RES_KM}_${LABELI}_${LABELF} #GFS

npy="g_s02_r${EXP_RES}_suite_HS${HOURS_STEP_BC}"

namepyload=sep_02_72

echo -e  "${GREEN}==>${NC} Creating submition scripts runpost, atmosphere_model...\n"
echo -e  "${GREEN}==>${NC} post_convert.sh...\n"
 Function_RunPost  ${EXP} ${EXP_NAME} ${RES_NUM} ${EXP_RES} ${LABELI} ${LABELF}  ${Domain} ${AreaRegion} ${TypeGrid} 


 load_python  ${pathpyload} ${namepyload} ${EXP} ${EXP_NAME}	\
              ${LABELI}     ${LABELF}  ${HOURS_STEP_BC}		\
	      ${npy}


exit 0

