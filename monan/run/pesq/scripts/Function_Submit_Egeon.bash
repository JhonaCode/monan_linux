#!/bin/bash -x 
function Function_Submit_Egeon(){
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: SUBMIT_EGEON  
#
# !DESCRIPTION: Submit any scritp to run on  egeon  
#
# !CALLING SEQUENCE:
#
#Function_InitAtmos_IC_ERA5.bash ${EXECUTABLE} ${FOLDER2RUN} ${LOGDIR} ${FILE2CHEC} ${CORES} ${JOBNAME}  ${PARTITION}
#	o)EXECUTABLE	:   scrip to exec
#	o)FOLDER2RUN	:   Directory to run 
#       o)LOGDIR	:   Log directory 
#       o)CORES		:   Number of cores 
#       o)JOBNAME	:   Name of the job
#	o)PARTITION	:   Partion egeon PESQ1, PESQ2
#
# For benchmark:
#     ./Function_Submit_Egeon.bash 
#
# !REVISION HISTORY: 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./scripts/Function_Submit_Egeon.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 6 ]; then
   usage
   exit 1
fi

export PMIX_MCA_gds=hash

####################################
#Variables
####################################
EXECUTABLE=${1}
FOLDER2RUN=${2}
LOGDIR=${3}
CORES=${4}
JOBNAME=${5}
PARTITION=${6}
####################################

# tempo de duracao do job
JobElapsedTime=06:00:00		
# Numero de processadores que serao utilizados no Job
MPITasks=${CORES}             	
# Numero de processadores utilizados por tarefas MPI
TasksPerNode=128
# Number of cores hosting OpenMP threads
ThreadsPerMPITask=1

echo $CORES

if ((${CORES}>${TasksPerNode})); then
	NODES=`echo ${CORES} ${TasksPerNode} | awk '{printf "%.0f", $1/$2}'`
else
	NODES=1
fi 

cat > ${FOLDER2RUN}/${JOBNAME}.sh <<EOF
#!/bin/bash
#SBATCH --job-name=${JOBNAME}
#SBATCH --nodes=${NODES}           # Specify number of nodes
#SBATCH --ntasks=${CORES}            
#SBATCH --tasks-per-node=${TasksPerNode}       # Specify number of (MPI) tasks on each node
#SBATCH --partition=${PARTITION} 
#SBATCH --time=${JobElapsedTime}
#SBATCH --output=${LOGDIR}/my_job_ic.o%j    # File name for standard output
#SBATCH --error=${LOGDIR}/my_job_ic.e%j     # File name for standard error output
#
ulimit -c unlimited
ulimit -v unlimited
ulimit -s unlimited

cd ${FOLDER2RUN}

echo  "STARTING AT \`date\` "
Start=\`date +%s.%N\`
echo \$Start >  ${FOLDER2RUN}/Timing.${JOBNAME}

time mpirun -np ${CORES} -env UCX_NET_DEVICES=mlx5_0:1 -genvall ./${EXECUTABLE}

End=\`date +%s.%N\`
echo  "FINISHED AT \`date\` "
echo \$End   >> ${FOLDER2RUN}/Timing.${JOBNAME}
echo \$Start \$End | awk '{print \$2 - \$1" sec"}' >>  ${FOLDER2RUN}/Timing.${JOBNAME}

EOF

chmod +x ${FOLDER2RUN}/${JOBNAME}.sh


}
