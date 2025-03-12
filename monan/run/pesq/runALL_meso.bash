
#Type of Initial and Boundary conditions
EXP_IBC=ERA5 #GFS   # ERA5 ;  GFS

#Regional run 
Domain=regional

LABELI=2014090204 #00 utc-4

LABELF=2014090304 #00 utc-4

#Dianostics out interval
HOURS_STEP_BC=1

#Step of hour boundary conditions
INPUT_INTERVAL=1

TypeGrid='quasi_uniform'

#'mesoscale_reference','convection_permitting','none'
reference='mesoscale_reference'

# 'cu_ntiedtke' 'cu_grell_freitas <10km' 'cu kain fritsch'
#cld_conv='suite'
cld_conv='cu_grell_freitas'

# 'mp_wsm6'  'mp_thompson'  'mp_thompson'  'mp_kessler'
cld_micro='suite'

# 'suite','sf_monin_obukhov','sf_mynn','off' (default: suite)
pbl_sche='suite'

#################################################################################3
#################################################################################3
#Regional geometric area
#AreaRegion=goamazon2

reference='mesoscale_reference'

for EXP_RES in  10 15 
do

for AreaRegion in goamazon  goamazon2
do

#Experiment Name
EXP_NAME=${AreaRegion}

#Experiment base on parameterization Name
EXP_NAME_MODEL=${cld_conv}_${reference}_${cld_micro}_${pbl_sche}_HS${INPUT_INTERVAL}

#./runPre.bash   ${EXP_IBC} ${HOURS_STEP_BC} ${EXP_NAME} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid} 

sed -e "
        s,#%REFERENCE%#,${reference},g;\
        s,#%CLD_CONV%#,${cld_conv},g;\
        s,#%CLD_MICRO%#,${cld_micro},g;\
        s,#%PBL_SCHEME%#,${pbl_sche},g"\
        runModel.bash > runModel.temp.bash

chmod +x runModel.temp.bash
./runModel.temp.bash ${EXP_NAME} ${HOURS_STEP_BC} ${INPUT_INTERVAL} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}  

./runPost.bash ${EXP_NAME} ${EXP_NAME_MODEL} ${EXP_RES} ${LABELI} ${LABELF} ${Domain} ${AreaRegion} ${TypeGrid}

done 
done

