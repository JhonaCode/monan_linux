#!/bin/bash -x
function Function_Degrib_IC_ERA5(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: static
#
# !DESCRIPTION: Script para criar topografia, land use e variáveis estáticas
#
# !CALLING SEQUENCE:
#
#Function_Degrib_IC.sh ${EXP_IBC} ${EXP_NAME} ${RES_KM}  ${EXP_RES}  ${LABELI}  ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}
#           o TYPE_BC    : GFS, ERA5, CFSR, etc.
#           o EXP_NAME   : Name of the experiment 
#           o RES_KM     : 015_km
#           o EXP_RES    : 1024002 number of grid cel
#           o LABELI     : Initial: date 2015030600
#           o LABELF     : End    : date 2015030600
#           o Domain     : global  or regional
#           o AreaRegion : PortoAlegre
#           o TypeGrid   : quasi_uniform or variable_resolution
#
# For benchmark:
#     ./Function_Degrib_IC.sh 1024002 GFS 1024002
#
# !REVISION HISTORY: 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' Function_Degrib_IC_ERA5.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 9 ]; then
   usage
   exit 1
fi
#
# Args
#
EXP_IBC=${1}
EXP_NAME=${2}
RES_KM=${3}
RES=${4}
LABELI=${5}
LABELF=${6}
Domain=${7}
AreaRegion=${8}
TypeGrid=${9}
start_date=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}:00:00
end_date=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}:00:00

#jhona
################
#EXP_NAME
EXP=${EXP_NAME}_${RES_KM}_${LABELI}_${LABELF}
################



####################################################################
#
# Paths of necessary folders 
#
####################################################################
HSTMAQ=$(hostname)


#NMLDIR=${PREDIR}/namelist/${version_model}
HOMEPRE=${DIR_HOME}/pre 
RUNDIR=${DIR_HOME}/run/pesq
SCRDIR=${RUNDIR}/scripts
NMLDIR=${HOMEPRE}/namelist/${version_model}
TBLDIRGRIB=${HOMEPRE}/Variable_Tables
EXECPATH=${HOMEPRE}/exec

BASEDIR=${SUBMIT_HOME}
PREDIR=${BASEDIR}/${EXP}/pre
DATADIR=${PREDIR}/datain/${Domain}/${EXP_IBC}
EXPDIR=${PREDIR}/runs
#Directory to save the IC 
EXPIC=${EXPDIR}/wpsprd

LOGDIR=${EXPDIR}/logs

USERDATA=`echo ${EXP} | tr '[:upper:]' '[:lower:]'`

OPERDIR=${ERA5_HOME}
BNDDIR=${ERA5_HOME}
#path_reg=${ERA5_HOME}
#Path to save the era5 ic 
path_reg=${DATADIR}/${Domain}/${EXP_IBC}/${LABELI}



#cd ${RUNDIR}
#pwd
source scripts/Function_Submit_Degrib_Egeon.bash

#######################################################
#### Verific Data to make the initial conditions
#######################################################
if [ ! -d ${BNDDIR} ]; then
   echo "Condicao de contorno inexistente !"
   echo "Verifique a data da rodada."
   echo "File ${BNDDIR}/e5.oper.f00.ll025sc.${LABELI}.grib does not exist."
   echo "Please run RunIC.sh or verific the Initial condition"
   echo "$0 ${LABELI}"
   exit 1       
   # close for running only the model
fi
#######################################################
# Criando diretorios da rodada
#######################################################
if [ -e ${EXPDIR} ]; then
   mkdir -p ${EXPDIR}
   mkdir -p ${EXPDIR}/logs   
   mkdir -p ${EXPDIR}/sst
   mkdir -p ${EXPDIR}/wpsprd
   mkdir -p ${EXPDIR}/scripts
fi

if [ ! -e ${DATADIR} ]; then
    mkdir -p ${DATADIR}
fi

##################################################################
#Copy Initial Condition before ungrib
##################################################################
if [ ${Domain} = "regional" ]; then
   echo "----------------------------"  
   echo "       REGIONAL DOMAIN      "  
   echo "----------------------------"  
   #
   #
   if [ ! -e ${BNDDIR}/e5.oper.*.ll025sc.${LABELI}.grib  ]; then

     		echo "File ${BNDDIR}/e5.oper.*.ll025sc.${LABELI}.grib does not exist."
		echo " Verific the data in folder ${BNDDIR}"
		exit 0
   else

     	echo "File ${BNDDIR}/e5.oper.*.ll025sc.${LABELI}.grib exists"
     	cp -urf ${BNDDIR}/e5.oper.*.ll025sc.${LABELI}.grib ${EXPIC}

   fi
else
   ln -sf ${BNDDIR}/*.grb ${EXPIC}
   ln -sf ${OPERDIR}/invariant/*.grb ${EXPIC}
fi
#
#
##################################################################
###UNGRIB IC
##################################################################


####################################################
#Namelist.wps
sed -e "s,#LABELI#,${start_date},g;\
	s,#PREFIX#,${EXP_IBC}_IC,g"\
	${NMLDIR}/namelist.wps.TEMPLATE.${Domain} > ${EXPIC}/namelist.wps


####################################################
#Making the degrib_era5

FILES2UNGRIB=e5.oper.*.ll025sc.${LABELI}.grib
JobName=degrib_era5
PREFIX=${EXP_IBC}_IC

cd ${SCRDIR}

Function_Submit_Degrib_Egeon ${FILES2UNGRIB} ${EXPIC} ${PREFIX} ${LOGDIR} ${JobName} ${RES_KM} ${TypeGrid}


###########################
#Link necessary files 
###########################

ln -sf ${EXPDIR}/static/${AreaRegion}.${RES_NUM}.static.nc ${EXPIC}

cp ${TBLDIRGRIB}/Vtable.ERA-interim.pl ${EXPIC}/Vtable
cp ${TBLDIRGRIB}/link_grib.csh ${EXPIC}
cp ${EXECPATH}/ungrib.exe ${EXPIC}

###########################
#Load Egeon Modules
###########################
. ${SCRDIR}/load_monan_app_modules.sh
###########################

cd ${EXPIC}

sbatch --wait ${JobName}.sh

grep "Successful completion of program ungrib.exe" ungrib.log >& /dev/null

if [ $? -ne 0 ]; then
   echo -e " ${RED}==> BUMMER: Ungrib generation failed for some yet unknown reason."
   echo -e " "
   tail -10 ${LOGDIR}/ungrib.log
   echo " "
   exit 21
fi

echo -e "  ##########################################"
echo -e "  ###  ${GREEN}==>${NC}  Ungrib completed - `date` ####"
echo -e "  ##########################################"
echo -e "  \n"
######################################################
#
# clean up and remove links
#
######################################################

mv ${FILES2UNGRIB} ${DATADIR}
mv ungrib.log ${LOGDIR}/ungrib.${JobName}.${start_date}.log
mv Timing.${JobName} ${LOGDIR}
mv namelist.wps  ${EXPDIR}/scripts/namelist_${JobName}.wps
rm -f link_grib.csh


######################################################
#LINK THE LBC TO INIT ATMOSPHERE FOLDER
######################################################
cd ${EXPDIR}

ln -sf ${EXPIC}/${PREFIX}\:*  ${EXPDIR}
find ${EXPIC} -maxdepth 1 -type l -exec rm -f {} \;

######################################################
#
echo -e " ${GREEN}==> End of degrib ${JobName}.sh "
echo -e "  \n"
echo -e "  \n"

#
######################################################

}
