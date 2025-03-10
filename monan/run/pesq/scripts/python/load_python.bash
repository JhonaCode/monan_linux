#!/bin/bash
# Define a function with local variables
load_python() {
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: load_python
#
# !DESCRIPTION:
#
# !CALLING SEQUENCE:
#
# !REVISION HISTORY:
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

####################################################
cd ${RUNDIR} 
function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ${PYDIR}/load_python.bash | head -n -1
}

#########################################
# Verificando argumentos de entrada
#########################################

if [ $# -ne 8 ]; then
   usage
   exit 1
fi

pathpyload=${1} 
namepyload=${2}
EXP_FOLDER=${3}
EXP_NAME=${4}
LABELI=${5}
LABELF=${6}
HOURS_STEP_BC=${7}
npy=${8}

####################################################
#Necessary Paths
RUNDIR=${DIR_HOME}/run
SCRDIR=${RUNDIR}/scripts
PYDIR=${SCRDIR}/python

BASEDIR=${SUBMIT_HOME}
POSDIR=${BASEDIR}/${EXP_FOLDER}/pos
EXPDIR=${POSDIR}/runs/${EXP_NAME}


####################################################

pyfile=Parameters_${namepyload}.py

pathpy=${pathpyload}/${pyfile}

if  [ ! -f ${pathpy} ]; then

	cp  ${PYDIR}/Parameters_load.py ${pathpy}

fi

echo -e "#####################################################"		>> "${pathpy}"
echo -e "exp_name='${npy}'"						>> "${pathpy}"
echo -e "path='${EXPDIR}'"						>> "${pathpy}"
echo -e "datei='${LABELI}'"						>> "${pathpy}"
echo -e "datef='${LABELF}'"						>> "${pathpy}"
echo -e "hours_step=${HOURS_STEP_BC}"					>> "${pathpy}"
echo -e "dates=dn.gerate_data_mpas(datei,datef,hours_step)"		>> "${pathpy}"
echo -e "${npy}=dn.concatenate(dates,path,'mpas.',exp_name,UTC=-4)" >> "${pathpy}"
echo -e "                                                     "		>> "${pathpy}"


}
