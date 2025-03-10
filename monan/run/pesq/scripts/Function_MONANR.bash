#!/bin/bash -x

# Define a function with local variables

Function_MONANR() {
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
#
# !CALLING SEQUENCE:
#     
#
# ./MONANR.bash  
#
# For benchmark:
#
#EOP
#-----------------------------------------------------------------------------!
function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_MONANR.bash | head -n -1
}

######################################
source scripts/VarEnvironmental.bash


 VarEnvironmental "export Environmental Variable "

######################################
# Verificando argumentos de entrada #

if [ $# -ne 1 ]; then
   usage
fi


export EXPDIR=${1}


##Define necessary folder
LOGDIR=${EXPDIR}/logs


#dates to check the initial condition 
start_date=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}.00.00
end_date=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}.00.00

#########################################################
#Load Egeon Modules
. ${DIR_HOME}/run/scripts/load_monan_app_modules.sh
#########################################################
JobName=MONANR

echo -e  "${GREEN}==>${NC} Submiting ${JobName}.sh...\n"

cd ${EXPDIR}

sbatch --wait ${JobName}.sh

if [ ! -e "${EXPDIR}/diag.${start_date}.nc" ]; then
    echo "********* ATENTION ************"
    echo "An error running MONAN occurred. check logs folder"
    exit -1
fi

if [ ! -e "${EXPDIR}/diag.${end_date}.nc" ]; then
    echo "********* ATENTION ************"
    echo "An error running MONAN occurred. check logs folder"
    exit -1
fi

echo -e  "Script \${0} completed. \n"

##################################
##################################
#
# move dataout, 
# clean up and remove files/links
#
##################################
##################################

cp *.init.nc* ${EXPDIR}/monanprd

mv diag* ${EXPDIR}/monanprd

mv histor* ${EXPDIR}/monanprd

mv Timing.${JobName} ${LOGDIR}

#find ${EXPDIR} -maxdepth 1 -type l -exec rm -f {} \;


}
