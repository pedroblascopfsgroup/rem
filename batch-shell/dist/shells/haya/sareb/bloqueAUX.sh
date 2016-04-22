#!/bin/bash

######################################
#            BLOQUE AUX              #
######################################

FECHA=`date +%d%b%G`
FECHA_ANT=`date +%d%b%G --date="1 days ago"`
LOG="$DIR_CONTROL_LOG/bloqueAUX.log"
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
	if [ "$?" == "0" ] ; then
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


# BLOQUE AUXILIARES #

# Se elimina apr_wait_adresses.sh apr_main_adresses.sh para agruparlo en bloqueAdresses.sh y planificado los sabados a las 5 hrs #

lanzarParaleloSinEsperar apr_extras_contract.sh apr_extras_person.sh

#lanzarParaleloSinEsperar apr_wait_CIRBE.sh apr_wait_charges.sh apr_wait_receipts.sh apr_wait_phones.sh apr_wait_assets.sh
#apr_wait_drafts_cnt.sh apr_wait_drafts_per.sh

lanzarParalelo apr_main_charges.sh apr_main_receipts.sh

lanzarParalelo apr_main_phones.sh apr_main_assets.sh

lanzarParalelo apr_main_drafts_per.sh apr_main_drafts_cnt.sh

lanzar apr_main_CIRBE.sh

echo "HA FINALIZADO LA EJECUCION DE LOS PROCESOS: `date`"
echo "Comprueba el LOG en $LOG y el Batch               " 

echo "                                                  " >> $LOG
echo "EXPLOTACION FINALIZADA: `date`			" >> $LOG
echo "Comprueba log de ejecucion batch                  " >> $LOG
echo "***************************************************" >> $LOG

exit 0
