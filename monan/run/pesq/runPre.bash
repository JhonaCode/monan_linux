#!/bin/bash -x
#---------------------------------------------------------------------------------------------#
#                                           DIMNT/INPE                                        #
#---------------------------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: run_monan
#
# !DESCRIPTION:
#        Script para rodar o MONAN
#        Realiza as seguintes tarefas:
#           o Ungrib os dados do GFS, ERA5
#           o Interpola para grade do modelo
#           o Cria condicao inicial e de fronteria
#           o Integra o modelo MONAN
#           o Pre-processamento (netcdf para grib2, regrid latlon, crop)
#
# !CALLING SEQUENCE:
#     
#./runPre.bash EXP_NAME EXP_RES   LABELI      LABELF      Domain    AreaRegion   TypeGrid
#
#           o EXP_NAME   : Forcing: ERA5, CFSR, GFS, etc.
#           o EXP_RES    : Resolution: 1024002 (24km), 2621442
#           o LABELI     : Initial: date 2015030600
#           o LABELF     : End:     date 2015030600 
#           o Domain     : global  or regional
#           o AreaRegion : PortoAlegre
#           o TypeGrid   : quasi_uniform or variable_resolution
#
#
# For benchmark:
#
#  Extreme event in southern Brazil (flooding)
#
#./runPre.bash    GFS   163842   2024042700  2024050100  regional  Sul  variable_resolution
#
#    Hurricane Catarina
#
#./runPre.bash    ERA5  163842   2004032400  2004032800  regional  Sul       variable_resolution
#
#   meteorological instability line LI-NORDESTE
#
#./runPre.bash    ERA5  163842   2010101600  2010102000  regional  Nordeste  variable_resolution
#
#   meteorological instability line LI-NORTE
#
#./runPre.bash    ERA5  163842   2013043000  2013050400  regional  Norte     variable_resolution
#
#   meteorological easterly wave  NORDESTE
#
#./runPre.bash    ERA5  163842   2019052500  2019052900  regional  Nordeste  variable_resolution
#
# !REVISION HISTORY:
# 30 sep 2022 - JPRF
# 12 oct 2022 - GAM Group - MONAN on EGEON DELL cluster
# 23 oct 2022 - GAM Group - MONAN benchmark on EGEON
#
# !REMARKS:
#
# TODO list:
# - CR: unificar todos exports em load_monan_app_modules.sh
# - DE: Alterar script de modo a poder executar novamente com os diretórios limpos e
#       nao precisar baixar os dados novamente
# - DE: Criar função para mensagem

##foi criada variavel para controlar as condicoes iniciais e o nome 
##do experiemnto separadamente
###${EXP_IBC}

#EOP
#-----------------------------------------------------------------------------!

#Experiment Name
export EXP_NAME=goamazon7

#Regional geometric area
export AreaRegion=goamazon7

#Type of Initial and Boundary conditions
export EXP_IBC=ERA5 #GFS   # ERA5 ;  GFS

#Resolution in Km: 3, 4, 7, 15 , 20  
export EXP_RES=15

#Regional run 
export Domain=regional


export LABELI=2014090204 #00 utc-4

export LABELF=2014090304 #00 utc-4

#Step of hour boundary conditions
export HOURS_STEP_BC=3

export TypeGrid='quasi_uniform'

export NLEV=55 

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/runPre.bash | head -n -1
}
#
# Verificando argumentos de entrada
#
if [ $# -ne 10 ]; then

	echo 'Os Argumentos foram lidos do scrip runPre' 
else 
	echo 'Argumentos foram definidos na Chamada'
#  Get Parameter Arguments
	export EXP_IBC=${1}         # ERA5 ;  GFS
	export HOURS_STEP_BC=${2}
	export EXP_NAME=${3}       
	export EXP_RES=${4}         #3 ,5 , 7
	export NLEV=${5}            #3 ,5 , 7
	export LABELI=${6}
	export LABELF=${7}
	export Domain=${8}          # regional
	export AreaRegion=${9}      #Belem
	export TypeGrid=${10}       #TypeGrid=variable_resolution
fi
#
#
# Activity Functions
#
source scripts/VarEnvironmental.bash
source scripts/Function_SetClusterConfig.bash
source scripts/Function_GridRotate.bash

source scripts/Function_SetResolution.bash
source scripts/Function_RecDomain.bash
source scripts/Function_PlotDomain.bash
source scripts/Function_Static.bash

source scripts/Function_Degrib_IC_ERA5.bash
source scripts/Function_InitAtmos_IC_ERA5.bash
source scripts/Function_InitAtmos_IC_GFS.bash
source scripts/Function_InitAtmos_LBC_GFS.bash

source scripts/Function_Degrib_LBC_ERA5.bash

source scripts/Function_InitAtmos_LBC_ERA5.bash

#
# Activity Modules
#
#
# Execute Functions
#
 VarEnvironmental       "export Environmental Variable "

source ${DIR_HOME}/run/pesq/scripts/load_monan_app_modules.sh

  Function_SetResolution ${EXP_RES} ${TypeGrid} 'set resolution '

echo -e  "${GREEN}==>${NC} Creating Function_GridRotate.sh for...\n"

  #Function_GridRotate ${RES_KM} ${RES_NUM} ${frac} ${Domain} ${AreaRegion} ${TypeGrid}


echo -e  "${GREEN}==>${NC} Creating FunStion_RecDomain.sh for...\n"

  #Function_RecDomain ${RES_KM} ${RES_NUM} ${frac} ${Domain} ${AreaRegion} ${TypeGrid}


echo -e  "${GREEN}==>${NC} Plot Domain.sh for...\n"


  #Function_PlotDomain ${EXP_NAME} ${RES_KM} ${RES_NUM} ${frac} ${Domain} ${AreaRegion} ${TypeGrid}


echo -e  "${GREEN}==>${NC} Creating make_static.sh for submiting init_atmosphere...\n"


  Function_Static ${EXP_NAME} ${HOURS_STEP_BC} ${RES_KM} ${RES_NUM} ${LABELI} ${Domain} ${AreaRegion} ${TypeGrid}



echo -e  "${GREEN}==>${NC} Creating submition scripts degrib, atmosphere_model...\n"

  #Function_Degrib_IC_ERA5 ${EXP_IBC} ${EXP_NAME} ${RES_KM}  ${RES_NUM}  ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}



echo -e  "${GREEN}==>${NC} Submiting degriblbc_exe.sh...\n"

  #Function_Degrib_LBC_ERA5 ${EXP_IBC} ${HOURS_STEP_BC} ${EXP_NAME} ${RES_KM} ${RES_NUM}  ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}


echo -e  "${GREEN}==>${NC} Submiting InitAtmos_ic_exe.sh...\n"

  Function_InitAtmos_IC_ERA5 ${EXP_IBC} ${HOURS_STEP_BC} ${EXP_NAME}  ${RES_KM}  ${RES_NUM} ${NLEV} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}

echo -e  "${GREEN}==>${NC} Submiting InitAtmos_lbc_exe.sh...\n"


  Function_InitAtmos_LBC_ERA5 ${EXP_IBC} ${HOURS_STEP_BC} ${EXP_NAME}  ${RES_KM}  ${RES_NUM} ${NLEV} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}


exit 0
