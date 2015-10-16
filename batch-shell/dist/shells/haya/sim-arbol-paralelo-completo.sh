#!/bin/bash

FECHA=`date +%d%b%G`
FECHA_ANT=`date +%d%b%G --date="1 days ago"`
LOG="/home/ops-haya/simulador.log"
DIR=/etl/HRE/shells
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


lanzar apr_wait_ofi_zon.sh
lanzar apr_main_ofi_zon.sh
lanzar apr_refresh_zpu.sh
#lanzar apr_wait_users.sh
#lanzar apr_main_users.sh


# BLOQUE PCR #
lanzar extract_pcr.sh
lanzarParalelo apr_load_contract.sh apr_load_person.sh apr_load_relation.sh
lanzarParalelo apr_validacion_pcr.sh
lanzarParalelo apr_pcr_contract.sh apr_pcr_person.sh
lanzarParalelo apr_pcr_mov.sh apr_pcr_relation.sh
lanzarParalelo rera_precal_arquet.sh apr_precalculo_pcr.sh


# BLOQUE CONVIVENCIAS #
lanzar convivenciaF2_procedimientos.sh
lanzar convivenciaF2_bienes.sh


# BLOQUE GCL #
lanzarParalelo apr_load_group.sh rera_hist_mov.sh
lanzarSinFinalizarPorError rera_precalculo.sh


#lanzarSinFinalizarPorError apr_ana_man_pcr.sh

# BLOQUE AUXILIARES #
lanzarParaleloSinEsperar apr_extras_contract.sh apr_extras_person.sh

lanzarParaleloSinEsperar apr_wait_CIRBE.sh apr_wait_charges.sh apr_wait_drafts_cnt.sh apr_wait_drafts_per.sh apr_wait_receipts.sh apr_wait_adresses.sh apr_wait_phones.sh apr_wait_assets.sh

lanzarParalelo apr_main_CIRBE.sh apr_main_charges.sh apr_main_drafts_cnt.sh 

lanzarParalelo apr_main_drafts_per.sh apr_main_receipts.sh 

lanzarParalelo apr_main_adresses.sh apr_main_phones.sh apr_main_assets.sh 

# BLOQUE SALIDA CONVIVENCIA (FASE2) #
lanzar proc_convivencia_stock_bienes.sh
lanzar proc_convivencia_cargas_bienes.sh


echo "HA FINALIZADO LA EJECUCION DE LOS PROCESOS: `date`"
echo "Comprueba el LOG en $LOG y el Batch               " 

echo "                                                  " >> $LOG
echo "EXPLOTACION FINALIZADA: `date`			" >> $LOG
echo "Comprueba log de ejecucion batch                  " >> $LOG
echo "***************************************************" >> $LOG

exit 0
