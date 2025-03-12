#!/bin/bash -x

function Function_SetClusterConfig() {
local  EXP_RES=$1
local  TypeGrid=${2}        #TypeGrid=variable_resolution
local  mensage=$3
echo ${mensage}

#Partition in egeon to run
export partition='PESQ1'
#export partition='PESQ2'

if [ ${TypeGrid} = 'variable_resolution' ]; then
#
# selected ncores to submission job
#


case "`echo ${EXP_RES} | awk '{print $1/1 }'`" in
  60003)cores_model=512 ;MIN_RES=3 ;nodes_model=4 ;cores=256 ;cores_stat=32   ;nodes=2 ;; 	   #'060_003km' ;; 
  60015)cores_model=256 ;MIN_RES=15;nodes_model=2 ;cores=32  ;cores_stat=32   ;nodes=1 ;; 	   # 060_015km
  60025)cores_model=128 ;MIN_RES=25;nodes_model=1 ;cores=32  ;cores_stat=32   ;nodes=1 ;; 	   # 060_015km
esac

dt_step=`echo ${MIN_RES} | awk '{printf "%f", $1*6 } '`
len_disp=`echo ${MIN_RES} | awk '{printf "%f", $1*1000 } '`
#
# Configuracoes
#
JobElapsedTime=01:00:00   # Tempo de duracao do Job
MPITasks=${cores}         # Numero de processadores que serao utilizados no Job
TasksPerNode=${cores}     # Numero de processadores utilizados por tarefas MPI
ThreadsPerMPITask=1       # Number of cores hosting OpenMP threads

else

case "`echo ${EXP_RES} | awk '{print $1/1 }'`" in
3)cores_model=512  ;nodes_model=4 ;cores=256 ;cores_stat=32  ;nodes=2 ;;
5)cores_model=512  ;nodes_model=2 ;cores=256 ;cores_stat=32  ;nodes=2 ;; 
7)cores_model=256  ;nodes_model=1 ;cores=128 ;cores_stat=32  ;nodes=1 ;;     
#10)cores_model=128 ;nodes_model=1 ;cores=64  ;cores_stat=32  ;nodes=1 ;; 
10)cores_model=256 ;nodes_model=1 ;cores=128  ;cores_stat=32  ;nodes=1 ;; 
15)cores_model=32  ;nodes_model=1 ;cores=32  ;cores_stat=32  ;nodes=1 ;; 
24)cores_model=32  ;nodes_model=1 ;cores=32  ;cores_stat=32  ;nodes=1 ;; 
30)cores_model=16  ;nodes_model=1 ;cores=16  ;cores_stat=32  ;nodes=1 ;; 
48)cores_model=8   ;nodes_model=1 ;cores=8   ;cores_stat=32  ;nodes=1 ;; 
60)cores_model=6   ;nodes_model=1 ;cores=6   ;cores_stat=32  ;nodes=1 ;; 
120)cores_model=2  ;nodes_model=1 ;cores=2   ;cores_stat=32  ;nodes=1 ;; 
240)cores_model=2  ;nodes_model=1 ;cores=2   ;cores_stat=32  ;nodes=1 ;; 
384)cores_model=2  ;nodes_model=1 ;cores=2   ;cores_stat=32  ;nodes=1 ;;
480)cores_model=2  ;nodes_model=1 ;cores=2   ;cores_stat=32  ;nodes=1 ;;
esac
# Configuracoes
dt_step=`echo ${EXP_RES} | awk '{printf "%f", $1*4 } '`
len_disp=`echo ${EXP_RES} | awk '{printf "%f", $1*1000 } '`
#foi mudado para rodar março tempo chuvososo amazonia com 3 km 
#dt_step=`echo ${EXP_RES} | awk '{printf "%f", $1*3 } '`
#len_disp=`echo ${EXP_RES} | awk '{printf "%f", $1*500 } '`

#
JobElapsedTime=01:00:00   # Tempo de duracao do Job
MPITasks=${cores}         # Numero de processadores que serao utilizados no Job
TasksPerNode=${cores}     # Numero de processadores utilizados por tarefas MPI
ThreadsPerMPITask=1       # Number of cores hosting OpenMP threads

fi

if [ "${MPITasks}" = "" ]; then
echo "ERROR Function_SetClusterConfig ${EXP_RES}=>"${RES_KM}
exit 5
fi
}
