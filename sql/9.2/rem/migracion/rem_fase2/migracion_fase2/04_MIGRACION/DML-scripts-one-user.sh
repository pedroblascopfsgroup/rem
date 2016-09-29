#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi

function run_scripts {
	export NLS_LANG=.AL32UTF8
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql 20160928 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160928" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_2401_REM_MIG2_CLIENTES_COMERCIALES-REM01-reg3.1.sql > DML_2401_REM_MIG2_CLIENTES_COMERCIALES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160928" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	      cat DML_2401_REM_MIG2_CLIENTES_COMERCIALES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160928" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql"
	  fi
	fi
}

run_scripts "$@" | tee output.log
