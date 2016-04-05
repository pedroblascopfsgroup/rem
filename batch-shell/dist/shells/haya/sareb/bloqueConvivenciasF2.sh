#!/bin/bash

################################################
#       BLOQUE SALIDA DE CONVIVENCIAS F2       #
################################################

FECHA=`date +%d%b%G`
FECHA_ANT=`date +%d%b%G --date="1 days ago"`
LOG="/home/ops-haya/bloqueSalidaConvivenciasF2.log"
DIR=/etl/HRE/shells

TESTIGO=testigoConvF2.sem
#DIR=./
source $DIR/setBatchEnv.sh

 
rm -f $DIR/$TESTIGO




echo "****************************************************" >> $LOG
echo "Explotacion Recovery Haya - Arbol de Procesos v1.0   " >> $LOG
echo "Fecha de lanzamiento: $FECHA" >> $LOG
echo "****************************************************" >> $LOG


function lanzar () {
	echo "****************************************************" >> $LOG
	echo "--- INICIO: $1 ($FECHA)" >> $LOG
	$DIR/$1 >> $LOG
	if [ "$?" == "0" ] ; then
	   echo "--- $1 finalizado correctamente ($FECHA)" >> $LOG
	else
	   echo "==== ERROR $? EN $1 ($FECHA)" >> $LOG
	   exit 1
	fi
        echo "****************************************************" >> $LOG  
}

function lanzarSinFinalizarPorError () {
	echo "****************************************************" >> $LOG
	echo "--- INICIO NO BLOQUEANTE: $1 ($FECHA)" >> $LOG
	$DIR/$1 >> $LOG
	if [ "$?" == "0" ] ; then
	   echo "--- $1 finalizado correctamente ($FECHA)" >> $LOG
	else
	   echo "==== ERROR $? EN $1 ... Seguimos ($FECHA)" >> $LOG
	fi    
	echo "****************************************************" >> $LOG
}

function lanzarParalelo () {

	FAIL=0

	for proceso in $* ; do
		echo "****************************************************" >> $LOG
		echo "--- INICIO PARALELO: $proceso ($FECHA)" >> $LOG
		$DIR/$proceso & >> $LOG
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1" 
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  ($FECHA)" >> $LOG
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*  ($FECHA)" >> $LOG
	    exit 1
	fi
	echo "****************************************************" >> $LOG
}

function lanzarParaleloSinEsperar () {

	FAIL=0

	for proceso in $* ; do
		echo "****************************************************" >> $LOG
		echo "--- INICIO PARALELO NO BLOQUEANTE: $proceso ($FECHA)" >> $LOG
		$DIR/$proceso & >> $LOG
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  ($FECHA)" >> $LOG
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*" >> $LOG
	    echo "---- Seguimos... Seguimos... ($FECHA)" >> $LOG
	fi
	echo "****************************************************" >> $LOG
}


# BLOQUE SALIDA CONVIVENCIA (FASE2) #

lanzar proc_convivencia_stock_bienes.sh
lanzar proc_convivencia_cargas_bienes.sh
touch $DIR/$TESTIGO


echo "HA FINALIZADO LA EJECUCION DE LOS PROCESOS: $FECHA"
echo "Comprueba el LOG en $LOG y el Batch               " 

echo "                                                  " >> $LOG
echo "EXPLOTACION FINALIZADA: $FECHA			" >> $LOG
echo "Comprueba log de ejecucion batch                  " >> $LOG
echo "***************************************************" >> $LOG

exit 0
