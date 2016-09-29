#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con los usuarios propietarios: master y entidad.
#

if [ "$#" -lt 2 ]; then
    echo "Es necesario indicar las contraseñas de cada uno de los usuarios seguidas de @host:port/sid, es decir:"
    echo "Parametros: master_pass@host:port/sid  entity01_pass@host:port/sid"
    exit
fi

function run_scripts {
	export NLS_LANG=.AL32UTF8
	exit | sqlplus -s -l REM01/$2 @./scripts/DML_000_ENTITY01_reg2.sql DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql 20160928 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DML_000_ENTITY01_reg3.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160928" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DML_2401_REM_MIG2_CLIENTES_COMERCIALES-REM01-reg3.1.sql > DML_2401_REM_MIG2_CLIENTES_COMERCIALES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DML_000_ENTITY01_reg4.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160928" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	      cat DML_2401_REM_MIG2_CLIENTES_COMERCIALES.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DML_000_ENTITY01_reg4.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160928" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	  fi
	fi
}

run_scripts "$@" | tee output.log
