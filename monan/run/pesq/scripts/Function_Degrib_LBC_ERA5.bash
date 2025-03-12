#!/bin/bash -x
function Function_Degrib_LBC_ERA5(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: static
#
# !DESCRIPTION: Script para criar topografia, land use e variáveis estáticas
#
# !CALLING SEQUENCE:
#
#Function_Degrib_IC.sh ${EXP_IBC} ${HOURSSTEP} ${EXP_NAME} ${RES_KM} ${EXP_RES}  ${LABELI}  ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}

#	    o  EXP_IBC   : ERA5, GFS
#	    o  HOURSSTEP : Hour to use the LATERAL condition 
#	    o  EXP_NAME  : Experiment Name
#           o  RES_KM    : 015_km
#           o  RES       : 1024002 number of grid cel
#           o  LABELI    : Initial: date 2015030600
#           o  LABELF    : End    : date 2015030600
#           o  Domain    : global  or regional
#           o  AreaRegion: PortoAlegre
#           o  TypeGrid  : quasi_uniform or variable_resolution
#           o  EXP_NAME  : GFS, ERA5, CFSR, etc.
#
# For benchmark:
#     ./Function_Degrib_LBC_ERA5.sh 1024002 GFS 1024002
#
# !REVISION HISTORY: 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_Degrib_LBC_ERA5.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 10 ]; then
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
RES=${5}
LABELI=${6}
LABELF=${7}
Domain=${8}
AreaRegion=${9}
TypeGrid=${10}

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

#Path to save the era5 ic 
path_reg=${DATADIR}


#################################################

cd ${RUNDIR} 
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


#to ajust the time to UTC, to using teh epoch 
# and to correct a error in adding hours. 
export TZ=UTC

##################################################################
#Copy Initial Condition before ungrib
##################################################################
if [ ${Domain} = "regional" ]; then
   echo "----------------------------"  
   echo "       REGIONAL DOMAIN      "  
   echo "----------------------------"  
   #
   #

   #Copy the specific files of the IC and 
   #the different BC in a specific folder to use
   ###########################################
   start=${LABELI}
   end=${LABELF}

   
   current="${start}"
   
   while [[ "${current}" -le "${end}" ]]
   do
   
   	if [ ! -e ${BNDDIR}/e5.oper.*.ll025sc.${current}.grib  ]; then
   

   		if [ ! -e ${DATADIR}/e5.oper.*.ll025sc.${current}.grib  ]; then

   	  		echo -e "<<<<<<${RED}>>>>>"
   	  		echo -e "File e5.oper.*.ll025sc.${current}.grib does not exist"
   	     		echo -e " Verific the data in folder ${BNDDIR}"
   	     		echo -e " And  in folder ${DATADIR}"
   	     		exit 0
		else 

        		ln -sf  ${DATADIR}/e5.oper.*.$current.grib ${EXPIC}
		fi

   	else
   
        	echo  "cp $current BC to  ${EXPILC} experiment folder "
        	#*************************************************

        	#BC
        	cp -f ${BNDDIR}/e5.oper.*.$current.grib ${EXPIC}
        	#*************************************************
   	fi

        formatted_date=$(date -d "${current:0:8} ${current:8}" '+%Y-%m-%d %H')
        current=$(date -d "${formatted_date} + ${HOURSSTEP} hours" '+%Y%m%d%H')

	####convert the original time to epoch seconds
	#start_epoch=$(date -d "${current:0:8} ${current:8}" +%s)
	##### Add 3 hours (3 * 3600 seconds)
	#end_epoch=$((start_epoch + 3 * 3600))
	##### Convert back to formatted date
        #current=$(date -u -d "@${end_epoch}" +%Y%m%d%H)
	
        echo "$formatted_date"
   
   done
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

seconds=`echo ${HOURSSTEP} | awk '{printf "%.0f", $1*3600}'`

sed -e "s,#LABELI#,${start_date},g;\
        s,#LABELF#,${end_date},g;\
        s,#SECONDS#,${seconds},g;\
        s,#PREFIX#,${EXP_IBC},g"\
         ${NMLDIR}/namelist.wps.LBC.${Domain} > ${EXPIC}/namelist.wps


####################################################
#Making the degrib_era5

FILES2UNGRIB=e5.oper.*.ll025sc.*.grib
JobName=degrib_era5_lbc
PREFIX=${EXP_IBC}

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
