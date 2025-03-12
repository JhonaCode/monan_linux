#!/bin/bash -x
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: runModel
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
#
# ./runModel.bash  ${EXP_NAME} ${EXP_RES}   ${LABELI}  ${LABELF}  ${Domain}  ${AreaRegion}  ${TypeGrid}
#
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
#./runModel.bash    GFS   163842   2024042700  2024050100  regional  Sul  variable_resolution
#
#    Hurricane Catarina
#
#./runModel.bash    ERA5  163842   2004032400  2004032800  regional  Sul       variable_resolution
#
#   meteorological instability line LI-NORDESTE
#
#./runModel.bash    ERA5  163842   2010101600  2010102000  regional  Nordeste  variable_resolution
#
#   meteorological instability line LI-NORTE
#
#./runModel.bash    ERA5  163842   2013043000  2013050400  regional  Norte     variable_resolution
#
#   meteorological easterly wave  NORDESTE
#
#./runModel.bash    ERA5  163842   2019052500  2019052900  regional  Nordeste  variable_resolution
#
# !REVISION HISTORY:
# 26 Agos 20242 - Jhonatan A. A. Manco
# 30 sep 2022 - JPRF
# 12 oct 2022 - GAM Group - MONAN on EGEON DELL cluster
# 23 oct 2022 - GAM Group - MONAN benchmark on EGEON
#
# !REMARKS:

# TODO list:
# - CR: unificar todos exports em load_monan_app_modules.sh
# - DE: Alterar script de modo a poder executar novamente com os diretórios limpos e não precisar baixar os dados novamente
# - DE: Criar função para mensagem
#
#
#EOP
#-----------------------------------------------------------------------------!

#'mesoscale_reference','convection_permitting','none'
reference='#%REFERENCE%#'
#reference='convection_permitting'

# 'cu_ntiedtke' 'cu_grell_freitas <10km' 'cu kain fritsch'
cld_conv='#%CLD_CONV%#'

# 'mp_wsm6'  'mp_thompson'  'mp_thompson'  'mp_kessler'
cld_micro='#%CLD_MICRO%#'

# 'suite','sf_monin_obukhov','sf_mynn','off' (default: suite)
pbl_sche='#%PBL_SCHEME%#'

############################################################
#Variables in the run call
#It value does not matter in teh runAll 
############################################################
#Step of hour boundary conditions
INPUT_INTERVAL=3

#Out diagnostic interval
HOURS_STEP_BC=3

#Type of Initial and Boundary conditions
export EXP_PRE=goamazon7 #GFS   # ERA5 ;  GFS

#Regional geometric area
export AreaRegion=goamazon7

#Resolution in Km: 3, 4, 7, 15 , 20  
export EXP_RES=15

#Regional run 
export Domain=regional

export LABELI=2014090204 #00 utc-4

export LABELF=2014090304 #00 utc-4

export TypeGrid='quasi_uniform'

export EXP_NAME=${cld_conv}_${reference}_${cld_micro}_${pbl_sche}_HS${HOURS_STEP_BC}

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/runModel.bash | head -n -1
}
#################################################
# Verificando argumentos de entrada
#
if [ $# -ne 10 ]; then

	echo 'Os Argumentos foram lidos do scrip runPre' 
else 
	echo 'Argumentos foram definidos na Chamada'
#  Get Parameter Arguments
	export EXP_PRE=${1}         # ERA5 ;  GFS
	export HOURS_STEP_BC=${2}
	export INPUT_INTERVAL=${3}
	export EXP_NAME=${4}       
	export EXP_RES=${5}         #3 ,5 , 7
	export LABELI=${6}
	export LABELF=${7}
	export Domain=${8}          # regional
	export AreaRegion=${9}      #Belem
	export TypeGrid=${10}        #TypeGrid=variable_resolution
fi
#################################################
#Experiment base on parameterization Name
#export EXP_NAME=ntiedtke_tes

source scripts/VarEnvironmental.bash
source scripts/Function_SetResolution.bash
source scripts/Function_RunModel.bash
source scripts/Function_MONANR.bash


 VarEnvironmental "export Environmental Variable "
 Function_SetResolution ${EXP_RES} ${TypeGrid} 'set resolution '


######################################                              
##Complete experiment name of preprocesing folder   
#####################################
EXP=${EXP_PRE}_${RES_KM}_${LABELI}_${LABELF}

EXPDIR=${SUBMIT_HOME}/${EXP}/model/runs/${EXP_NAME}


##################################################
#Making the Run model MONANR.sh
##################################################
echo -e  "${GREEN}==>${NC} Creating submition scripts degrib, atmosphere_model...\n"

 Function_RunModel  ${EXP} ${HOURS_STEP_BC} ${INPUT_INTERVAL} ${EXP_NAME} ${RES_KM} ${EXP_RES} ${LABELI} ${LABELF}  ${Domain} ${AreaRegion} ${TypeGrid}

##################################################
#Modify the namelist for parameterizations
##################################################
sed -e "
        s,#REFERENCE#,${reference},g;\
        s,#CLD_CONV#,${cld_conv},g;\
        s,#CLD_MICRO#,${cld_micro},g;\
        s,#PBL_SCHEME#,${pbl_sche},g"\
        ${EXPDIR}/namelist.atmosphere.temp > ${EXPDIR}/namelist.atmosphere


##################################################
#To submit MONANR.sh model execution
##################################################
 Function_MONANR  ${EXPDIR}

echo -e "${GREEN}==>${NC} Script ${0} completed. \n"
##################################################
