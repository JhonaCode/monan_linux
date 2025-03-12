
#Type of Initial and Boundary conditions
EXP_IBC=ERA5 #GFS   # ERA5 ;  GFS

#Regional run 
Domain=regional

#Dianostics out interval
HOURS_STEP_BC=1

#Step of hour boundary conditions
INPUT_INTERVAL=3

TypeGrid='quasi_uniform'

#'mesoscale_reference','convection_permitting','none'
reference='mesoscale_reference'
#reference='convection_permitting'

# 'cu_ntiedtke' 'cu_grell_freitas <10km' 'cu kain fritsch'
cld_conv='suite'
#cld_conv='cu_ntiedtke'

# 'mp_wsm6'  'mp_thompson'  'mp_thompson'  'mp_kessler'
cld_micro='suite'

# 'suite','sf_monin_obukhov','sf_mynn','off' (default: suite)
pbl_sche='suite'

reference='mesoscale_reference'

#Number of levels
NLEV=55


LABELI=2014090100 
LABELF=2014090200
RUNHOURSTEP=24
RUNHOUR=24


###############
#to run day per day
#LABELI=2014090100 
#LABELF=2014090200
#RUNHOURSTEP=24
#RUNHOUR=24

start=${LABELI}
end=${LABELF}

current="${start}"

while [[ "${current}" -le "${end}" ]]
do
        formatted_date=$(date -d "${current:0:8} ${current:8}:00:00" "+%Y-%m-%d %H")
        echo "$formatted_date"
	LABELI=$current
        LABELF=$(date -d "$formatted_date + ${RUNHOUR} hour" "+%Y%m%d%H")

        current=$(date -d "$formatted_date + ${RUNHOURSTEP} hour" "+%Y%m%d%H")
        echo "$LABELI"
        echo "$LABELF"

	for EXP_RES in 3 ##7 10 15 
	do
	
		for AreaRegion in goamazon  ##goamazon2
		do
		
		#Experiment Name
		EXP_NAME=${AreaRegion}_l110
		
		reference='mesoscale_reference'
		
		if [ ${EXP_RES} -lt 10 ]; then
		
			reference='convection_permitting'
		
		fi
		
		#Experiment base on parameterization Name
		EXP_NAME_MODEL=${cld_conv}_${reference}_${cld_micro}_${pbl_sche}_HS${INPUT_INTERVAL}
		
		#./runPre.bash   ${EXP_IBC} ${HOURS_STEP_BC} ${EXP_NAME} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid} 
		
		sed -e "
		        s,#%REFERENCE%#,${reference},g;\
		        s,#%CLD_CONV%#,${cld_micro},g;\
		        s,#%CLD_MICRO%#,${cld_conv},g;\
		        s,#%PBL_SCHEME%#,${pbl_sche},g"\
		        runModel.bash > runModel.temp.bash
		
		chmod +x runModel.temp.bash
		./runModel.temp.bash ${EXP_NAME} ${HOURS_STEP_BC} ${INPUT_INTERVAL} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}  
		
		./runPost.bash ${EXP_NAME} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}
		
		done 
	done 
done

