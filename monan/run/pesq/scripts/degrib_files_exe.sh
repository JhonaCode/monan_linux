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
# Function_Submit_Degrib_Egeon.bash ${FILES2UNGRIB} ${FOLDER2RUN} ${EXPDIR} ${PREFIX} ${LOGDIR} ${RES_KM} ${TypeGrid} 
#
#		FILES2UNGRIB:  
#		FOLDER2RUN:
#		EXPDIR:      
#		PREFIX:      
#		LOGDIR:      
#               RES_KM:
#               TypeGrid:

#
# For benchmark:
#     Function_Submit_Degrib_Egeon.bash  ${FILES2UNGRIB} ${FOLDER2RUN} ${EXPDIR} ${PREFIX} ${LOGDIR} ${RES_KM} ${TypeGrid}
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' Function_Submit_Degrib_Egeon.bash | head -n -1
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
EXPDIR=${3}       
PREFIX=${4}      
LOGDIR=${5}     
RES_KM=${6} 
TypeGrid=${7}         

########################################
#Use function to set the nodes ... 

Function_SetClusterConfig ${RES_KM} ${TypeGrid} 'set Function_SetClusterConfig '
#############################################################
# Arguments 

jobelapsedtime=01:00:00		# tempo de duracao do job
MPITasks=${cores}             	# Numero de processadores que serao utilizados no Job
TasksPerNode=128         	# Numero de processadores utilizados por tarefas MPI
ThreadsPerMPITask=1     	# Number of cores hosting OpenMP threads


NODES=`echo  ${cores} ${TasksPerNode} |awk '{print $1/$2}'`

cat > ${EXPDIR}/degrib_ic_exe.sh << EOF
#!/bin/bash
#SBATCH --job-name=${JOBNAME}
#SBATCH --nodes=${NODES}           # Specify number of nodes
#SBATCH --ntasks=${cores}            
#SBATCH --tasks-per-node=${TasksPerNode}                      # ic for benchmark
#SBATCH --partition=${partition}
#SBATCH --time=00:30:00
#SBATCH --output=${LOGDIR}/my_job_ungrib.o%j    # File name for standard output
#SBATCH --error=${LOGDIR}/my_job_ungrib.e%j     # File name for standard error output
#
ulimit -s unlimited
ulimit -c unlimited
ulimit -v unlimited

########
export PMIX_MCA_gds=hash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HOME}/local/lib64
########

ldd ungrib.exe

cd ${FOLDER2RUN}

echo  "STARTING AT \`date\` "
Start=\`date +%s.%N\`
echo \$Start > Timing.${JOBNAME}

##*********************************
./link_grib.csh ${FILES2UNGRIB}
mpirun -np 1 ./ungrib.exe
##*********************************

End=\`date +%s.%N\`
echo  "FINISHED AT \`date\` "
echo \$End   >>Timing.${JOBNAME}
echo \$Start \$End | awk '{print \$2 - \$1" sec"}' >> Timing.${JOBNAME}

EOF

chmod +x ${STATICPATH}/${JOBNAME}.sh

}

