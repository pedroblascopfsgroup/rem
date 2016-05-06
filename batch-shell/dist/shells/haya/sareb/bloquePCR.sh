#!/bin/bash

######################################
#           BLOQUE PCR               #
######################################



FECHA=`date +%d%b%G`
FECHA_ANT=`date +%d%b%G --date="1 days ago"`
LOG="$DIR_CONTROL_LOG/bloquePCR.log"
DIR=$DIR_SHELLS
#DIR=./
source $DIR/setBatchEnv.sh




echo "****************************************************" >> $LOG
echo "Explotacion Recovery Haya - Arbol de Procesos v1.0   " >> $LOG
echo "Fecha de lanzamiento: $FECHA" >> $LOG
echo "****************************************************" >> $LOG


function lanzar () {
	echo "****************************************************" >> $LOG
	echo "--- INICIO: $1 (`date`)" >> $LOG
	$DIR/$1 >> $LOG
	RES=`echo "$?"`
	echo "LA VARIABLE ES = $RES" >> $LOG
	if [ "$RES" == "0" ] ; then
	   echo "--- $1 finalizado correctamente (`date`)" >> $LOG
	else
	   echo "==== ERROR $? EN $1" >> $LOG
	   exit 1
	fi
        echo "****************************************************" >> $LOG  
}


function lanzarSinFinalizarPorError () {
	echo "****************************************************" >> $LOG
	echo "--- INICIO NO BLOQUEANTE: $1 (`date`)" >> $LOG
	$DIR/$1 >> $LOG
	if [ "$?" == "0" ] ; then
	   echo "--- $1 finalizado correctamente (`date`)" >> $LOG
	else
	   echo "==== ERROR $? EN $1 ... Seguimos (`date`)" >> $LOG
	fi    
	echo "****************************************************" >> $LOG
}

function lanzarParalelo () {

	FAIL=0

	for proceso in $* ; do
		echo "****************************************************" >> $LOG
		echo "--- INICIO PARALELO: $proceso (`date`)" >> $LOG
		$DIR/$proceso & >> $LOG
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1" 
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  (`date`)" >> $LOG
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*  (`date`)" >> $LOG
	    exit 1
	fi
	echo "****************************************************" >> $LOG
}

function lanzarParaleloSinEsperar () {

	FAIL=0

	for proceso in $* ; do
		echo "****************************************************" >> $LOG
		echo "--- INICIO PARALELO NO BLOQUEANTE: $proceso (`date`)" >> $LOG
		$DIR/$proceso & >> $LOG
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  (`date`)" >> $LOG
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*" >> $LOG
	    echo "---- Seguimos... Seguimos... (`date`)" >> $LOG
	fi
	echo "****************************************************" >> $LOG
}


# BLOQUE PCR #

#lanzar apr_wait_ofi_zon.sh
#lanzar apr_main_ofi_zon.sh
#lanzarSinFinalizarPorError apr_refresh_zpu_1.0.2.sh
#apr_wait_users.sh apr_main_users.sh

lanzar extract_pcr.sh
lanzarParalelo apr_load_contract.sh apr_load_person.sh apr_load_relation.sh
lanzar apr_validacion_pcr.sh
lanzarParalelo apr_pcr_contract.sh apr_pcr_person.sh
lanzarParalelo apr_pcr_mov.sh apr_pcr_relation.sh
lanzarParalelo rera_precal_arquet.sh apr_precalculo_pcr.sh
lanzar apr_recalculo_deuda.sh
lanzarSinFinalizarPorError apr_pcr_precal_per.sh

echo "HA FINALIZADO LA EJECUCION DE LOS PROCESOS: `date`"
echo "Comprueba el LOG en $LOG y el Batch               " 

echo "                                                  " >> $LOG
echo "EXPLOTACION FINALIZADA: `date`			" >> $LOG
echo "Comprueba log de ejecucion batch                  " >> $LOG
echo "***************************************************" >> $LOG

exit 0
