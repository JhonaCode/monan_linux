#!/bin/bash -x

function Function_SetResolution() {
local  EXP_RES=$1
local  TypeGrid=${2}        #TypeGrid=variable_resolution
local  mensage=$3
echo   ${mensage}

#  os tamanhos dos intervalos de tempo geralmente recebem o valor de 6x do espaçamento da grade em km.

if [ ${TypeGrid} = 'variable_resolution' ]; then

case "`echo ${EXP_RES} | awk '{print $1/1 }'`" in
60003)RES_KM='060_003km';RES_NUM='835586';MIN_RES=3 ;frac=20 ;; 
60015)RES_KM='060_015km';RES_NUM='535554';MIN_RES=15;frac=4  ;; 
60025)RES_KM='092_025km';RES_NUM='163842';MIN_RES=25;frac=4  ;; 
esac
else

case "`echo ${EXP_RES} | awk '{print $1/1 }'`" in
3)RES_KM='003_km'  ;RES_NUM='65536002';frac=1;;
5)RES_KM='005_km'  ;RES_NUM='23592962';frac=1;;
7)RES_KM='007_km'  ;RES_NUM='10485762';frac=1;;
10)RES_KM='010_km' ;RES_NUM='5898242' ;frac=1;;
15)RES_KM='015_km' ;RES_NUM='2621442' ;frac=1;;
24)RES_KM='024_km' ;RES_NUM='1024002' ;frac=1;;
30)RES_KM='030_km' ;RES_NUM='655362'  ;frac=1;;
48)RES_KM='048_km' ;RES_NUM='256002'  ;frac=1;;
60)RES_KM='060_km' ;RES_NUM='163842'  ;frac=1;;
120)RES_KM='120_km';RES_NUM='40962'   ;frac=1;;
240)RES_KM='240_km';RES_NUM='10242'   ;frac=1;;
384)RES_KM='384_km';RES_NUM='4002'    ;frac=1;;
480)RES_KM='480_km';RES_NUM='2562'    ;frac=1;;
esac

fi

if [ "${RES_KM}" = "" ]; then
echo "ERROR Function_SetResolution ${EXP_RES}=>"${RES_KM}
exit 3
fi
}
