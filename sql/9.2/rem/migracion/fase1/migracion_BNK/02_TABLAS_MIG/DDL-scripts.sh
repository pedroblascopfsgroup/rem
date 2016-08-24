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
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01.sql
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA-REM01-reg3.1.sql > DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
	      cat DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1239_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO-REM01-reg3.1.sql > DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
	      cat DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1240_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS-REM01-reg3.1.sql > DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
	      cat DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1241_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL-REM01-reg3.1.sql > DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
	      cat DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1242_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
	      cat DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1243_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA-REM01-reg3.1.sql > DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
	      cat DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1244_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES-REM01-reg3.1.sql > DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
	      cat DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1245_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA-REM01-reg3.1.sql > DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
	      cat DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1246_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO-REM01-reg3.1.sql > DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
	      cat DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1247_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO-REM01-reg3.1.sql > DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
	      cat DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1248_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO-REM01-reg3.1.sql > DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
	      cat DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1249_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO-REM01-reg3.1.sql > DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
	      cat DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1250_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO-REM01-reg3.1.sql > DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
	      cat DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1251_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
	      cat DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1252_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO-REM01-reg3.1.sql > DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
	      cat DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1253_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
	      cat DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1254_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO-REM01-reg3.1.sql > DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
	      cat DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1255_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION-REM01-reg3.1.sql > DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
	      cat DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1256_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS-REM01-reg3.1.sql > DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
	      cat DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1257_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA-REM01-reg3.1.sql > DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
	      cat DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1258_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO-REM01-reg3.1.sql > DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
	      cat DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1259_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO-REM01-reg3.1.sql > DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
	      cat DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1260_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO-REM01-reg3.1.sql > DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
	      cat DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1261_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1262_REM_HAYA01_MIG_AGRUPACIONES-REM01-reg3.1.sql > DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql"
	      cat DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1262_REM_HAYA01_MIG_AGRUPACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION-REM01-reg3.1.sql > DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
	      cat DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1263_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION-REM01-reg3.1.sql > DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
	      cat DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1264_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION-REM01-reg3.1.sql > DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
	      cat DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1265_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION-REM01-reg3.1.sql > DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
	      cat DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1266_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1267_REM_HAYA01_MIG_PROVEEDORES-REM01-reg3.1.sql > DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql"
	      cat DDL_1267_REM_HAYA01_MIG_PROVEEDORES.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1267_REM_HAYA01_MIG_PROVEEDORES.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS-REM01-reg3.1.sql > DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
	      cat DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1268_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
	      cat DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1269_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1270_REM_HAYA01_MIG_TRABAJO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1270_REM_HAYA01_MIG_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1270_REM_HAYA01_MIG_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1270_REM_HAYA01_MIG_TRABAJO-REM01-reg3.1.sql > DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1270_REM_HAYA01_MIG_TRABAJO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1270_REM_HAYA01_MIG_TRABAJO.sql"
	      cat DDL_1270_REM_HAYA01_MIG_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1270_REM_HAYA01_MIG_TRABAJO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1270_REM_HAYA01_MIG_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
	      cat DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1271_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO-REM01-reg3.1.sql > DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
	      cat DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1272_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
	      cat DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1273_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1274_REM_HAYA01_MIG_PRECIO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1274_REM_HAYA01_MIG_PRECIO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1274_REM_HAYA01_MIG_PRECIO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1274_REM_HAYA01_MIG_PRECIO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1274_REM_HAYA01_MIG_PRECIO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1274_REM_HAYA01_MIG_PRECIO-REM01-reg3.1.sql > DDL_1274_REM_HAYA01_MIG_PRECIO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1274_REM_HAYA01_MIG_PRECIO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1274_REM_HAYA01_MIG_PRECIO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1274_REM_HAYA01_MIG_PRECIO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1274_REM_HAYA01_MIG_PRECIO.sql"
	      cat DDL_1274_REM_HAYA01_MIG_PRECIO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1274_REM_HAYA01_MIG_PRECIO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1274_REM_HAYA01_MIG_PRECIO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS-REM01-reg3.1.sql > DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
	      cat DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1275_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql 201600802 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600802" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO-REM01-reg3.1.sql > DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	  exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "201600802" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
	      cat DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "201600802" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_1276_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql" "REM01" "JOSE VILLEL" "online"  "9.1" "20160817" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS-REM01-reg3.1.sql > DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	echo " -- : DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO.sql" "REM01" "JOSE VILLEL" "online"  "9.1" "20160822" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO-REM01-reg3.1.sql > DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO.log
	echo " -- : DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_012_REM01_VI_BUSQUEDA_PROPUESTAS_ACTIVO.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO.sql" "REM01" "JORGE ROS" "online"  "9.2" "20160805" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO-REM01-reg3.1.sql > DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO.log
	echo " -- : DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_014_REM01_VI_BUSQUEDA_PROPUESTAS_PRECIO.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION.sql" "REM01" "Luis Caballero" "online"  "9.1" "20160810" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION-REM01-reg3.1.sql > DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION.log
	echo " -- : DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_014_REM01_VI_OFERTAS_ACTIVOS_AGRUPACION.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA.sql" "REM01" "JORGE ROS" "online"  "9.2" "20160810" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA-REM01-reg3.1.sql > DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA.log
	echo " -- : DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_015_REM01_VI_BUSQUEDA_ACTIVOS_PROPUESTA.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO.sql" "REM01" "JORGE ROS" "online"  "9.2" "20160811" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO-REM01-reg3.1.sql > DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO.log
	echo " -- : DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_016_REM01_VI_BUSQUEDA_NUM_ACTIVOS_TIPO_PRECIO.log
}

run_scripts "$@" | tee output.log
