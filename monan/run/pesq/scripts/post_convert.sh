#!/bin/bash

####################################
# scripts to submit posprocess to egeon 
# Criated: Jhonatan. A. A. Manco
####################################

####################################
#Variables
####################################
AreaRegion=#AreaRegion#
FOLDER2RUN=#FOLDER2RUN#
PARTITION=#PARTITION#
NAMELIST=#NAMELIST#
DATA2POS=#DATA2POS#
SCRDIR=#SCRDIR#
JOBNAME=#JOBNAME#
LOGDIR=#LOGDIR#
EXPRES=#EXPRES#
CORES=#CORES#
####################################
LOG_FILE=${LOGDIR}/pos.out

# tempo de duracao do job
JobElapsedTime=01:00:00		
# Numero de processadores que serao utilizados no Job
MPITasks=${CORES}             	
# Numero de processadores utilizados por tarefas MPI
TasksPerNode=128         
# Number of cores hosting OpenMP threads
ThreadsPrMPITask=1     	

NODES=`echo  ${CORES} ${TasksPerNode} |awk '{print $1/$2}'`

#Load Egeon Modules
###########################
#. ${SCRDIR}/load_monan_app_modules.sh
###########################


sbatch --wait <<EOT
#!/bin/bash

#SBATCH --job-name=${JOBNAME}
#SBATCH --nodes=1
#SBATCH --partition=${PARTITION}	
#SBATCH --tasks-per-node=${TasksPerNode}         # ic for benchmark
#SBATCH --time=02:30:00
#SBATCH --output=${LOGDIR}/my_job_postprd.o%j    # File name for standard output
#SBATCH --error=${LOGDIR}/my_job_postprd.e%j     # File name for standard error output
#
ulimit -s unlimited
ulimit -c unlimited
ulimit -v unlimited

export PMIX_MCA_gds=hash

echo  "STARTING AT \`date\` "
echo  ${NAMELIST}
echo  ${FOLDER2RUN}
echo  ${LOG_FILE}

cd ${FOLDER2RUN}

search_dir=${DATA2POS}

for files in "\$search_dir"/diag.*

do

dirpost=`pwd`

dirmodel=\`dirname \${files}\`

filename=\`basename \${files}\`


if [ \${filename:0:4} = "diag" ]; then

labelF=\`echo \${filename} | awk '{print substr(\$1,6,22)}'\`

cp ${NAMELIST}/include_fields.diag  ${FOLDER2RUN}/include_fields   >> ${LOG_FILE}
cp ${NAMELIST}/exclude_fields.diag  ${FOLDER2RUN}/exclude_fields   >> ${LOG_FILE}

else
labelF=\`echo \${filename} | awk '{print substr(\$1,9,22)}'\`

cp ${NAMELIST}/include_fields.history   ${FOLDER2RUN}/include_fields   >> ${LOG_FILE}
cp ${NAMELIST}/exclude_fields.history   ${FOLDER2RUN}/exclude_fields   >> ${LOG_FILE}
fi
postname='mpas.'\${labelF}
rm latlon.nc
./convert_mpas \${search_dir}/${AreaRegion}.${EXPRES}.init.nc  \${dirmodel}/\${filename}
mv latlon.nc  \${postname}
done

echo "End of degrib Job"

exit 0
EOT


