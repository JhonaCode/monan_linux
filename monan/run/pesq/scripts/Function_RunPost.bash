
# Define a function with local variables

Function_RunPost() {
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: Function_RunPost
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
#        ./Function_RunPost.bash EXP_NAME RES LABELI
#
# For benchmark:
#        ./Function_RunPost.bash CFSR ${EXP_RES} 2010102300
#
# For ERA5 datasets
#
#        ./Function_RunPost.bash ERA5 ${EXP_RES} 2021010100
#        ./Function_RunPost  ${RES_KM} ${EXP_NAME} ${EXP_RES} ${LABELI} ${LABELF}  ${Domain} ${AreaRegion} ${TypeGrid}
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
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_RunPost.bash | head -n -1
}


#
# Verificando argumentos de entrada
#

if [ $# -ne 9 ]; then
   usage
   exit 1
fi
#
# pegando argumentos
#
EXP_DIR=${1}
EXP_NAME=${2}
RES_NUM=${3}
#Name of the folder of the experiment
EXP_RES=${4}
LABELI=${5}; start_date=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}:00:00
start_check=${LABELI:0:4}-${LABELI:4:2}-${LABELI:6:2}_${LABELI:8:2}.00.00
LABELF=${6};end_date=${LABELF:0:4}-${LABELF:4:2}-${LABELF:6:2}_${LABELF:8:2}:00:00

Domain=${7}
AreaRegion=${8}
TypeGrid=${9}



################################################################################
#
# Path of the required folder to run the post 
#
###############################################################################
source scripts/VarEnvironmental.bash
source scripts/Function_SetClusterConfig.bash

HSTMAQ=$(hostname)
EXECPATH=${DIR_HOME}/model/exec/MONAN-Model_v8.1.0_egeon.gnu940/exec
NMLDIR=${DIR_HOME}/pos/namelist/${version_pos}
CONVERT_MPAS=${DIR_HOME}/pos/exec/${version_pos}/exec
SCRDIR=${DIR_HOME}/run/scripts

#IN the run has more space to save
DIR_MESH=${DIR_HOME}/pre/databcs/meshes/regional_domain
SUB_MESH=${SUBMIT_HOME}/pre/databcs/meshes/${TypeGrid}/${Domain}/${RES_KM}


BASEDIR=${SUBMIT_HOME}/${EXP_DIR}
MODDIR=${BASEDIR}/model/runs/${EXP_NAME}
PREDIR=${BASEDIR}/pre/runs
MESHPRE=${PREDIR}/pre/databcs/meshes

POSDIR=${BASEDIR}/pos/runs
EXP=${POSDIR}/${EXP_NAME}
TBLDIR=${BASEDIR}/pre/databcs/tables
DATADIR=${BASEDIR}/pre/datain/data

LOGDIR=${EXP}/logs
LOG_FILE=${LOGDIR}/pos.out

#####################################################
#
# start post processing
##################################################### 
 VarEnvironmental "export Environmental Variable "
 Function_SetClusterConfig ${EXP_RES} ${TypeGrid} 'set Function_SetClusterConfig '

##################################################### 
echo -e  "\n${GREEN}==>${NC} Executing post processing...\n"
mkdir -p ${EXP}
mkdir -p ${LOGDIR}

rm -f ${LOG_FILE}
rm -f ${EXP}/convert_mpas >> ${LOG_FILE}

#####################################################
#
#Link and copy theh necessary files 
#
#####################################################

ln -sf ${MODDIR}/${AreaRegion}.${RES_NUM}.init.nc  ${EXP} >> ${LOG_FILE}

ln -sf ${SUB_MESH}/${AreaRegion}.${RES_NUM}.grid.nc   ${EXP} >> ${LOG_FILE}


cp ${CONVERT_MPAS}/convert_mpas  ${EXP} >> ${LOG_FILE}

# copy from repository to testcase and runs /ngrid2latlon.sh
cp ${NMLDIR}/convert_mpas.nml       ${EXP}   >> ${LOG_FILE}

cp ${NMLDIR}/ctl_descriptor.bash    ${EXP}  >> ${LOG_FILE}

########################################################

if [ ${Domain} = "regional" ]; then
echo "----------------------------"  
echo "       REGIONAL DOMAIN      "  
echo "----------------------------"  
DOM=R

clon=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | awk '{printf "%.5f\n", $3/1}'`
clat=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | awk '{printf "%.5f\n", $2/1}'`

#
#   1grau -  110000
#   y     - 1000000.   
#
Semi_major_axis=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Semi-major-axis: | awk '{printf "%.5f\n", (($2/1)/100000)+2}'`
#startlon=`echo ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+1.0)} '`   # -64.0
#endlon=`echo   ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+1.0)} '`   # -39.0
#startlat=`echo ${clat}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+1.0)} '`   # -40.0
#endlat=`echo ${clat}    ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+1.0)} '`   # -20.0
#nlat=`echo ${startlat}  ${endlat} ${len_disp}| awk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    # 700
#nlon=`echo ${startlon}  ${endlon} ${len_disp}| awk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    #  867

startlon=-65
endlon=-55
startlat=-9
endlat=1
nlat=200
nlon=200

else
echo "----------------------------"  
echo "        GLOBAL DOMAIN       "  
echo "----------------------------"  
DOM=G
#Semi_major_axis=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Semi-major-axis: | awk '{printf "%.5f\n", (($2/1)/100000)+2}'`
startlon=0.2496533   #`echo ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -64.0
endlon=359.7503   #`echo   ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -39.0
startlat=-89.75 #`echo ${clat}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -40.0
endlat=89.75    #`echo ${clat}    ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -20.0
nlat=360 #`echo ${startlat}  ${endlat} ${len_disp}| awk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    # 700
nlon=721 #`echo ${startlon}  ${endlon} ${len_disp}| awk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    #  867
fi

cat > ${EXP}/target_domain <<EOF
nlat = ${nlat}
nlon = ${nlon}
startlat = ${startlat}
startlon = ${startlon}
endlat   = ${endlat}
endlon   = ${endlon}
EOF

echo -e  "\n${GREEN}==>${NC} Executing post processing...\n"
#####################################################

JOBNAME=POSMONANR

sed -e "s,#AreaRegion#,${AreaRegion},g;\
        s,#FOLDER2RUN#,${EXP},g;\
        s,#NAMELIST#,${NMLDIR},g;\
        s,#DATA2POS#,${MODDIR}/monanprd,g;\
        s,#SCRDIR#,${SCRDIR},g;\
        s,#JOBNAME#,${JOBNAME},g;\
        s,#LOGDIR#,${LOGDIR},g;\
        s,#EXPRES#,${RES_NUM},g;\
        s,#PARTITION#,${partition},g;\
	s,#CORES#,${cores},g"\
	${SCRDIR}/post_convert.sh > ${EXP}/post_convert.sh ###>> ${LOG_FILE}


chmod 777 ${EXP}/post_convert.sh

echo -e  "${GREEN}==>${NC} post_convert.sh...\n"
######################################################
#EXP WAS DEFINED IN FUNCTION_RUNTPOST
####

######################################################
#Load Modules
. ${SCRDIR}/load_monan_app_modules.sh
######################################################

cd ${EXP}

#***************************************`
bash post_convert.sh
#***************************************`


echo -e  "${GREEN}==>${NC}  Script ${0} completed. \n"
echo -e  "${GREEN}==>${NC}  Log file: ${LOG_FILE} . End of script. \n"


return 10 
}
