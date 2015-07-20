#!/bin/bash

echo "****************************************************"
echo "Simulación del camino COMPLETO del árbol de procesos" 
echo "Fecha de lanzamiento: `date`"
echo "****************************************************"

DIR=/aplicaciones/recovecb/shells
#DIR=./
source $DIR/setBatchEnv.sh

function lanzar () {
	echo "--- INICIO: $1 (`date`)"
	$DIR/$1
	if [ "$?" == "0" ] ; then
	   echo "--- $1 finalizado correctamente (`date`)"
	else
	   echo "==== ERROR $? EN $1"
	   exit 1
	fi    
}

function lanzarSinFinalizarPorError () {
	echo "--- INICIO NO BLOQUEANTE: $1 (`date`)"
	$DIR/$1
	if [ "$?" == "0" ] ; then
	   echo "--- $1 finalizado correctamente (`date`)"
	else
	   echo "==== ERROR $? EN $1 ... Seguimos (`date`)"
	fi    
}

function lanzarParalelo () {

	FAIL=0

	for proceso in $* ; do
		echo "--- INICIO PARALELO: $proceso (`date`)"
		$DIR/$proceso &
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  (`date`)"
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*  (`date`)"
	    exit 1
	fi

}

function lanzarParaleloSinEsperar () {

	FAIL=0

	for proceso in $* ; do
		echo "--- INICIO PARALELO NO BLOQUEANTE: $proceso (`date`)"
		$DIR/$proceso &
	done

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $* finalizados correctamente  (`date`)"
	else
 	    echo "==== ERROR EN ALGUNO ($FAIL) DE ESTOS PROCESOS $*"
	    echo "---- Seguimos... Seguimos... (`date`)"
	fi
}


lanzar apr_wait_ofi_zon.sh
lanzar apr_main_ofi_zon.sh
lanzar apr_wait_users.sh
lanzar apr_main_users.sh
lanzar apr_refresh_zpu.sh

lanzar extract_pcr.sh
lanzarParalelo apr_load_contract.sh apr_load_person.sh apr_load_relation.sh

lanzarParalelo rera_precal_arquet.sh apr_pcr.sh

lanzar wait_convivencia.sh
lanzar carga_convivencia.sh

lanzar rera_revision.sh
lanzarParalelo carga_bi.sh proc_convivencia.sh rera_extract_ficagencias.sh

lanzarSinFinalizarPorError refresco_mstr.sh
lanzarParalelo apr_load_group.sh rera_hist_mov.sh
lanzarSinFinalizarPorError rera_precalculo.sh

lanzarSinFinalizar rera_gen_simulacion.sh
lanzarSinFinalizarPorError rera_gen_factdiario.sh
lanzarSinFinalizarPorError rera_load_acjagencias.sh
lanzarSinFinalizarPorError rera_gen_facttotal.sh


lanzarSinFinalizarPorError apr_ana_man_pcr.sh
lanzarParaleloSinEsperar apr_extras_contract.sh apr_extras_person.sh

lanzarParaleloSinEsperar apr_wait_adresses.sh apr_wait_phones.sh apr_wait_deposits.sh apr_wait_charges.sh apr_wait_receipts.sh apr_wait_drafts_cnt.sh apr_wait_fees.sh apr_wait_assets.sh apr_wait_CIRBE.sh apr_wait_drafts_per.sh apr_wait_adequacies.sh

lanzarParalelo apr_main_adresses.sh apr_main_phones.sh apr_main_deposits.sh apr_main_charges.sh apr_main_receipts.sh apr_main_drafts_cnt.sh apr_main_fees.sh apr_main_assets.sh apr_main_CIRBE.sh apr_main_drafts_per.sh apr_main_adequacies.sh

echo "***************************************************"
echo "Fin de ejecución: `date`"
echo "***************************************************"

exit 0

