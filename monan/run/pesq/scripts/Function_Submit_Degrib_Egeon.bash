#!/bin/bash -x
function Function_Submit_Degrib_Egeon(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: Function to Submit  Degrib file to Egeon
#
# !DESCRIPTION: Submision Script to make IC ERA5  
# !CALLING SEQUENCE:
#
# Function_Submit_Degrib_Egeon.bash ${FILES2UNGRIB} ${FOLDER2RUN}  ${PREFIX} ${LOGDIR} ${JOBNAME}  ${RES_KM} ${TypeGrid}
#
#		FILES2UNGRIB	: 
#		FOLDER2RUN	:
#		PREFIX		:
#		LOGDIR		:  
#		JOBNAME		:
#               RES_KM		:
#               TypeGrid	:

#
# For benchmark:
#     ./Function_Submit_Degrib_Egeon.bash  ${FILES2UNGRIB} ${FOLDER2RUN} ${PREFIX} ${LOGDIR} ${JOBNAME} ${RES_KM} ${TypeGrid}
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./Function_Submit_Degrib_Egeon.bash | head -n -1
}

#############################################################
# Check input args
if [ $# -ne 7 ]; then
   usage
   exit 1
fi
#############################################################
# Arguments 

FILES2UNGRIB=${1} 
FOLDER2RUN=${2}   
PREFIX=${3}      
LOGDIR=${4}     
JOBNAME=${5}     
RES_KM=${6} 
TypeGrid=${7}         

########################################
#Use function to set the nodes ... 

#source scripts/Function_SetClusterConfig.bash
Function_SetClusterConfig ${RES_KM} ${TypeGrid} 'set Function_SetClusterConfig '
#############################################################
# Arguments 

jobelapsedtime=01:00:00		# tempo de duracao do job
MPITasks=${cores}             	# Numero de processadores que serao utilizados no Job
TasksPerNode=128         	# Numero de processadores utilizados por tarefas MPI
ThreadsPerMPITask=1     	# Number of cores hosting OpenMP threads


NODES=`echo  ${cores} ${TasksPerNode} |awk '{print $1/$2}'`

cat > ${FOLDER2RUN}/${JOBNAME}.sh << EOF
#!/bin/bash
#SBATCH --job-name=${JOBNAME}
#SBATCH --nodes=${nodes}            
#SBATCH --ntasks=${cores}            
#SBATCH --tasks-per-node=${TasksPerNode}    
#SBATCH --partition=${partition}
#SBATCH --time=00:30:00
#SBATCH --output=${LOGDIR}/my_job_ungrib.o%j  
#SBATCH --error=${LOGDIR}/my_job_ungrib.e%j   
#
ulimit -s unlimited
ulimit -c unlimited
ulimit -v unlimited


########
export PMIX_MCA_gds=hash
########

ldd ungrib.exe

echo  "STARTING AT \`date\` "
Start=\`date +%s.%N\`
echo \$Start > Timing.${JOBNAME}

cd ${FOLDER2RUN}


##*********************************
chmod 777 ${FOLDER2RUN}/link_grib.csh
./link_grib.csh ${FILES2UNGRIB}
mpirun -np 1 ./ungrib.exe
##*********************************

End=\`date +%s.%N\`
echo  "FINISHED AT \`date\` "
echo \$End   >>Timing.${JOBNAME}
echo \$Start \$End | awk '{print \$2 - \$1" sec"}' >> Timing.${JOBNAME}

EOF

chmod +x ${FOLDER2RUN}/${JOBNAME}.sh

}

