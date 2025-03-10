#!/bin/bash -x
function Function_Make_Static(){
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: static
#
# !DESCRIPTION: Submision Script para  criar init_atmosphere_model
# !CALLING SEQUENCE:
#
#Function_static.sh ${STATICPATH}

#           STATICPATH  : Path of the static directory in the pre 
#
# For benchmark:
#     Function_Make_Static.bash  STATICPATH 
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' Function_Make_Static.bash | head -n -1
}

#
# Check input args
#

if [ $# -ne 2 ]; then
   usage
   exit 1
fi

STATICPATH=${1}
local  mensage=${2}
echo -e  "${GREEN}==>${NC} ${mensage} \n"                 

#######################################################
# Selected ncores to submission job
#######################################################
Function_SetClusterConfig ${RES_KM} ${TypeGrid} 'set Function_SetClusterConfig '

executable=init_atmosphere_model

#Number of process of one node in the egeon
task2node=128
nodes=1 ##`echo  ${cores} ${task2node} |awk '{print $1/$2}'`

#sbatch --wait <<EOT
cat > ${STATICPATH}/make_static_exe.sh << EOF
#!/bin/bash
#SBATCH --job-name=static.monan
#SBATCH --nodes=${nodes}                  # Specify number of nodes
#SBATCH --ntasks=${cores_stat}             
#SBATCH --tasks-per-node=${task2node}     # Specify number of (MPI) tasks on each node
#SBATCH --partition=${partition}
#SBATCH --time=02:00:00        # Set a limit on the total run time
#SBATCH --output=${STATICPATH}/logs/my_job.o%j    # File name for standard output
#SBATCH --error=${STATICPATH}/logs/my_job.e%j     # File name for standard error output


ulimit -s unlimited
ulimit -c unlimited
ulimit -v unlimited

cd ${STATICPATH}

echo  "STARTING AT \`date\` "
Start=\`date +%s.%N\`
echo \$Start > ${STATICPATH}/Timing

time mpirun -np ${cores_stat} -env UCX_NET_DEVICES=mlx5_0:1 -genvall ./${executable}

End=\`date +%s.%N\`
echo  "FINISHED AT \`date\` "
echo \$End   >> ${STATICPATH}/Timing
echo \$Start \$End | awk '{print \$2 - \$1" sec"}' >> ${STATICPATH}/Timing

EOF

chmod +x ${STATICPATH}/make_static_exe.sh


}
