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

lanzar apr_wait_ofi_zon.sh
lanzar apr_main_ofi_zon.sh
lanzar apr_wait_users.sh
lanzar apr_main_users.sh
lanzar apr_refresh_zpu.sh

lanzar extract_pcr.sh
lanzar apr_load_contract.sh
lanzar apr_load_person.sh
lanzar apr_load_relation.sh

lanzar rera_precal_arquet.sh
lanzar apr_pcr.sh

lanzar rera_revision.sh
lanzar carga_bi.sh

lanzar apr_wait_charges.sh
lanzar apr_main_charges.sh

echo "***************************************************"
echo "Fin de ejecución: `date`"
echo "***************************************************"

exit 0

