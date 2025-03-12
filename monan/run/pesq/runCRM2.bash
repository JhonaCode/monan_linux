#!/bin/bash -x 
#Type of Initial and Boundary conditions
EXP_IBC=ERA5 #GFS   # ERA5 ;  GFS

#Regional run 
Domain=regional

#Dianostics out interval
OUTPUT_HOURS=1

#Step of hour boundary conditions
INPUT_INTERVAL=3

TypeGrid='quasi_uniform'

#'mesoscale_reference','convection_permitting','none'
#reference='mesoscale_reference'
reference='convection_permitting'

# 'cu_ntiedtke' 'cu_grell_freitas <10km' 'cu kain fritsch'
cld_conv='suite'
#cld_conv='cu_ntiedtke'

# 'mp_wsm6'  'mp_thompson'  'mp_thompson'  'mp_kessler'
cld_micro='suite'

# 'suite','sf_monin_obukhov','sf_mynn','off' (default: suite)
pbl_sche='suite'

#Number of levels
NLEV=55

LABELI=2014021500 
LABELF=2014032500


#ESTA POR DIAS no por horas, 1 dia  
#no se pq no funciona.
RUNHOURSTEP=24
#Hours to run each date  
RUNHOUR=24

start=${LABELI}
end=${LABELF}

current="${start}"

while [[ "${current}" -le "${end}" ]]
do
        formatted_date=$(date -d "${current:0:8} ${current:8}:00" "+%Y-%m-%d %H")

	LABELI=${current}

        #LABELF=$(date -d "${formatted_date} + ${RUNHOUR} hour" "+%Y%m%d%H")
        LABELF=$(date -d "${formatted_date} + 1 day" "+%Y%m%d%H")

	echo "${LABELI}",${LABELF} 

        #current=$(date -d "${formatted_date} + ${RUNHOURSTEP} hour" "+%Y%m%d%H")
        current=$(date -d "${formatted_date} + 1 day" "+%Y%m%d%H")

	for EXP_RES in 3 7 10 15 
	do
	
		for AreaRegion in goamazon2   #goamazon2 
		do
		
		#Experiment Name
		EXP_NAME=${AreaRegion}
		
		reference='mesoscale_reference'
		cld_conv='cu_grell_freitas'
		
		if [ ${EXP_RES} -lt 10 ]; then
		
			reference='convection_permitting'
			cld_conv='cu_ntiedtke'
		
		fi
		
		#Experiment base on parameterization Name
		EXP_NAME_MODEL=${cld_conv}_${reference}_${cld_micro}_${pbl_sche}_HS${INPUT_INTERVAL}
		
		#./runPre.bash   ${EXP_IBC} ${INPUT_INTERVAL} ${EXP_NAME} ${EXP_RES} ${NLEV} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid} 

		sed -e "
		        s,#%REFERENCE%#,${reference},g;\
		        s,#%CLD_CONV%#,${cld_conv},g;\
		        s,#%CLD_MICRO%#,${cld_micro},g;\
		        s,#%PBL_SCHEME%#,${pbl_sche},g"\
		        runModel.bash > runModel.temp.bash
		
		chmod +x runModel.temp.bash

		./runModel.temp.bash ${EXP_NAME} ${OUTPUT_HOURS} ${INPUT_INTERVAL} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}  
		
		####./runPost.bash ${EXP_NAME} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}
		
		done 

	done
done
