#!/bin/bash +x
function Function_PlotDomain(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: Function_RecDomain
#
# !DESCRIPTION: Script para criar topografia, land use e variáveis estáticas
#
# !CALLING SEQUENCE:
#
#Function_RecDomain.sh ${RES_KM} ${EXP_RES} ${frac} ${Domain} ${AreaRegion} ${TypeGrid}
#           o RES_KM     : 015_km
#           o Domain     : global  or regional
#           o AreaRegion : PortoAlegre
#           o TypeGrid   : quasi_uniform or variable_resolution
#
# For benchmark:
#     ./Function_RecDomain.sh 1024002 GFS 1024002
#
# !REVISION HISTORY: 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' Function_RecDomain.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 7 ]; then
   usage
   exit 1
fi

EXP_NAME=${1}
RES_KM=${2}
EXP_RES=${3}
frac=${4}
Domain=${5}
AreaRegion=${6}
TypeGrid=${7}

#EXP_NAME
EXP=${EXP_NAME}_${RES_KM}_${LABELI}_${LABELF}

BASEDIR=${SUBMIT_HOME}
EXPDIR=${BASEDIR}/${EXP}
EXPRUN=${BASEDIR}/${EXP}/pre/runs

#######################################################
# Criando diretorios da rodada
#######################################################
if [ ! -e ${EXPDIR} ]; then
   mkdir -p ${EXPDIR}
   mkdir -p ${EXPRUN}
fi

cd ${SUBMIT_HOME}/pre/databcs/meshes/${TypeGrid}

pathin=${SUBMIT_HOME}/pre/databcs/meshes/${TypeGrid}
pathmesh=${DIR_HOME}

path_ncl=${NCARG_BIN}

export DIR_MESH=${pathmesh}/pre/databcs/meshes/regional_domain
if [ ${Domain} = "regional" ]; then
echo "----------------------------"  
echo "       REGIONAL DOMAIN      "  
echo "----------------------------"  

clon=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | awk '{printf "%.5f\n", $3/1}'`
clat=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | awk '{printf "%.5f\n", $2/1}'`
#
#   1grau -  110000
#   y     - 1000000.
#
Semi_major_axis=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Semi-major-axis: | awk '{printf "%.5f\n", (($2/1)/100000)+2}'`
startlon=`echo ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -64.0
endlon=`echo   ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -39.0
startlat=`echo ${clat}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -40.0
endlat=`echo ${clat}    ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -20.0
FILEDATA=${pathin}/${Domain}/${RES_KM}/${AreaRegion}.${EXP_RES}.grid.nc

sed -e "s,#FILEDATA#,${FILEDATA},g; \
	s,#startlon#,${startlon},g; \
	s,#endlon#,${endlon},g; \
	s,#startlat#,${startlat},g;\
	s,#title#,${AreaRegion}.${EXP_RES},g;\
	s,#endlat#,${endlat},g" \
	${DIR_MESH}/plot_region.ncl > ${pathin}/plot_region.ncl

${path_ncl}/ncl ${pathin}/plot_region.ncl

rm ${pathin}/plot_region.ncl
mv ${pathin}/regional_mesh.png ${EXPRUN}/${AreaRegion}.${EXP_RES}.png

else

echo "----------------------------"  
echo "        GLOBAL DOMAIN       "  
echo "----------------------------"  
Semi_major_axis=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Semi-major-axis: | awk '{printf "%.5f\n", (($2/1)/100000)+2}'`
startlon=-180   #`echo ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -64.0
endlon=180   #`echo   ${clon}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -39.0
startlat=-90 #`echo ${clat}  ${Semi_major_axis}| awk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -40.0
endlat=90    #`echo ${clat}    ${Semi_major_axis}| awk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -20.0
FILEDATA=${pathin}/${Domain}/${RES_KM}/${AreaRegion}.${EXP_RES}.grid.nc

sed -e "s,#FILEDATA#,${FILEDATA},g" \
	 ${DIR_MESH}/mpas-a_mesh.ncl > ${pathin}/mpas-a_mesh.ncl

${path_ncl}/ncl ${pathin}/mpas-a_mesh.ncl
rm ${pathin}/mpas-a_mesh.ncl
mv ${pathin}/global_mesh.pdf ${EXPRUN}/${AreaRegion}.${EXP_RES}.png

fi


}
