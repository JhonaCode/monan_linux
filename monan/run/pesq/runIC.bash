#!/bin/bash -x 
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: runIC
#
# !DESCRIPTION:
#        Script para gerar as condicoes inicias e de contorno para o  MONAN
#        Realiza as seguintes tarefas:
#	 Baixa as condições iniciais (CI) do ERA5 e do GFS  
#
# !CALLING SEQUENCE:
#
# ./runIC.bash  
#
#  IC_HOME	: Lugar para baixar os dados
#  EXP_IBC  	: Tipo de condicao a ser usada. ERA5 OU GFS
#  LABELI   	: Data inicial do experimento
#  LABELF   	: Data final   do experimento
#  HOURS_STEP_BC: Passo de tempo em horas para baixar as CI 
#  LAT_INI	: Latitude Inicial 
#  LAT_FIN	: Latitude Final
#  LON_INI	: Longitude Inicial 
#  LON_FIN	: Longitude Final

# !REVISION HISTORY:
# 02/08/2024:  Separado do runpre  
#
# !REMARKS:
#
# !Criated by: Jhonatan A. A. Manco
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

# Folder to dowload
#export IC_HOME=/pesq/dados/bamc/public_jhona
export IC_HOME=/pesq/dados/bamc/jhonatan.aguirre/DATA/ERA5/MPAS_data

#Type of Initial and Boundary conditions
export EXP_IBC=ERA5 #GFS  

#Initial and Final Date 
export LABELI=2014090604
export LABELF=2014090804
export EXPNAME="sep07"

#Initial and Final Date 
#export LABELI=2004032400
#export LABELI=2004020722
#export LABELF=2004032800
#export EXPNAME="CATARINA"

#export LABELI=2010101604
#export LABELI=2010101814
#export LABELF=2010102100
#export EXPNAME="LINORDESTE"

#export LABELI=2019052501
#export LABELF=2019052900 
#export EXPNAME="EASTERLYWAVE"

#export LABELI=2013043014 
#e5.oper.f00.ll025sc.2013050300
#export LABELI=2013050301 
#export LABELF=2013050400
#export EXPNAME="LINORTE"


#Step of hour boundary conditions
HOURS_STEP_BC=1

#Initial latitude
#LAT_INI=10
LAT_INI=15
#Final latitude
LAT_FIN=-60
#Initial longitude 
LON_INI=-100
#Final longitude 
LON_FIN=-30

#lat=[15,-60]
#lon=[-90,-30]

######################################################
######################################################
#
#	No Necessary to modified below
#
######################################################
######################################################

# paths of the functions

source scripts/VarEnvironmental.bash
source scripts/Initial_Conditions_ERA5.bash

 VarEnvironmental "export Environmental Variable "

######################################################
#Folder to necessary files

IC_FOLDER=${IC_HOME}/${EXPNAME}

######################################################
#Check Initial and Boundary condition  or download it 
######################################################

Initial_Conditions_ERA5 		  \
	${EXP_IBC} ${IC_FOLDER} ${LABELI} \
	${LABELF}  ${HOURS_STEP_BC} 	  \
	${LAT_INI} ${LAT_FIN} 		  \
	${LON_INI} ${LON_FIN} 


