#!/bin/bash

###################################################
#   06/Julio/2015                                 #
#   ARBOL PROCESOS RECOVERY HAYA                  #
#                                                 #
###################################################

FECHA=`date +%d%b%G`
FECHA_ANT=`date +%d%b%G --date="1 days ago"`
LOG="$DIR_CONTROL_LOG/simulador.log"
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


# BLOQUE PCR #

lanzar bloquePCR.sh

# BLOQUE CONVIVENCIAS F2 - BLOQUE GCL - BLOQUE AUX #

lanzarParalelo bloqueConvivencias.sh bloqueAUX.sh bloqueGCL.sh

#Añadida la ejecución del resto de procesos que se lanzan en algún momento.
lanzar bloqueAdresses.sh
lanzar bloqueConvivenciasF2.sh
lanzar sftp.download.files.sh
lanzar sftp.upload.files.UVEM.sh
lanzar proc_convivencia_cierre_deudas.sh
#lanzar upload_proc_convivencia_cierre_deudas.sh
lanzar proc_convivencia_contratos_litios.sh
lanzar upload_proc_convivencia_contratos_litios.sh
lanzar download_convivencia_cdd_resultado_nuse.sh 
#lanzar convivencia_cdd_resultado_nuse.sh
lanzar apr_gen_tdx_haya.sh
#lanzar apr_gen_burofax.sh
#lanzar apr_rec_burofax.sh
lanzar bloqueHISTyBI.sh
#Fin resto de procesos



echo "HA FINALIZADO LA EJECUCION DE LOS PROCESOS: `date`"
echo "Comprueba el LOG en $LOG y el Batch               " 

echo "                                                  " >> $LOG
echo "EXPLOTACION FINALIZADA: `date`			" >> $LOG
echo "Comprueba log de ejecucion batch                  " >> $LOG
echo "***************************************************" >> $LOG

lanzar sendMail.sh

exit 0
