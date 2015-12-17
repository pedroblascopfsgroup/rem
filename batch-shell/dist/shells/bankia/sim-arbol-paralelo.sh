#!/bin/bash

echo "***************************************************"
echo "Simulación del camino crítico del árbol de procesos" 
echo "Fecha de lanzamiento: `date`"
echo "***************************************************"

source /aplicaciones/recovecb/programas/shells/setBatchEnv.sh

function lanzar () {
	echo "--- INICIO: $1 (`date`)"
	/aplicaciones/recovecb/shells/$1
	if [ "$?" != "0" ] ; then
	   echo "==== ERROR EN $1"
	   exit 1
	fi    
}

function lanzarParalelo2 () {

	FAIL=0

	echo "--- INICIO PARALELO: $1 (`date`)"
	/aplicaciones/recovecb/shells/$1 &

	echo "--- INICIO PARALELO: $2 (`date`)"
	/aplicaciones/recovecb/shells/$2 &

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $1 y $2 finalizados correctamente"
	else
 	    echo "==== ERROR EN $1 o $2"
	    exit 1
	fi

}

function lanzarParalelo3 () {

	FAIL=0

	echo "--- INICIO PARALELO: $1 (`date`)"
	/aplicaciones/recovecb/shells/$1 &

	echo "--- INICIO PARALELO: $2 (`date`)"
	/aplicaciones/recovecb/shells/$2 &

	echo "--- INICIO PARALELO: $3 (`date`)"
	/aplicaciones/recovecb/shells/$3 &

	for job in `jobs -p`
	do
	    #echo $job
	    wait $job || let "FAIL+=1"
	done
	 
	if [ "$FAIL" == "0" ];
	then
	    echo "---- $1, $2 y $3 finalizados correctamente"
	else
 	    echo "==== ERROR EN $1, $2 o $3"
	    exit 1
	fi

}

lanzar apr_wait_ofi_zon.sh
lanzar apr_main_ofi_zon.sh
lanzar apr_wait_users.sh
lanzar apr_main_users.sh
lanzar apr_refresh_zpu.sh

lanzar extract_pcr.sh
lanzarParalelo3 apr_load_contract.sh apr_load_person.sh apr_load_relation.sh

lanzarParalelo2 rera_precal_arquet.sh lanzar apr_pcr.sh

lanzar rera_revision.sh
lanzar carga_bi.sh

lanzar apr_wait_charges.sh
lanzar apr_main_charges.sh

echo "***************************************************"
echo "Fin de ejecución: `date`"
echo "***************************************************"

exit 0

