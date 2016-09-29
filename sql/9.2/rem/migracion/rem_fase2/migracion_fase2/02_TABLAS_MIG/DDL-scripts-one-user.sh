#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi

function run_scripts {
	export NLS_LANG=.AL32UTF8
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01.sql
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2201_REM_MIG2_CLIENTES_COMERCIALES-REM01-reg3.1.sql > DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql"
	      cat DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2201_REM_MIG2_CLIENTES_COMERCIALES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2202_REM_MIG2_VIS_VISITAS.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2202_REM_MIG2_VIS_VISITAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2202_REM_MIG2_VIS_VISITAS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2202_REM_MIG2_VIS_VISITAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2202_REM_MIG2_VIS_VISITAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2202_REM_MIG2_VIS_VISITAS-REM01-reg3.1.sql > DDL_2202_REM_MIG2_VIS_VISITAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2202_REM_MIG2_VIS_VISITAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2202_REM_MIG2_VIS_VISITAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2202_REM_MIG2_VIS_VISITAS.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2202_REM_MIG2_VIS_VISITAS.sql"
	      cat DDL_2202_REM_MIG2_VIS_VISITAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2202_REM_MIG2_VIS_VISITAS.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2202_REM_MIG2_VIS_VISITAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2203_REM_MIG2_OFR_OFERTAS.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2203_REM_MIG2_OFR_OFERTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2203_REM_MIG2_OFR_OFERTAS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2203_REM_MIG2_OFR_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2203_REM_MIG2_OFR_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2203_REM_MIG2_OFR_OFERTAS-REM01-reg3.1.sql > DDL_2203_REM_MIG2_OFR_OFERTAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2203_REM_MIG2_OFR_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2203_REM_MIG2_OFR_OFERTAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2203_REM_MIG2_OFR_OFERTAS.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2203_REM_MIG2_OFR_OFERTAS.sql"
	      cat DDL_2203_REM_MIG2_OFR_OFERTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2203_REM_MIG2_OFR_OFERTAS.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2203_REM_MIG2_OFR_OFERTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO-REM01-reg3.1.sql > DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql"
	      cat DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2206_REM_MIG2_RES_RESERVAS.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2206_REM_MIG2_RES_RESERVAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2206_REM_MIG2_RES_RESERVAS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2206_REM_MIG2_RES_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2206_REM_MIG2_RES_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2206_REM_MIG2_RES_RESERVAS-REM01-reg3.1.sql > DDL_2206_REM_MIG2_RES_RESERVAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2206_REM_MIG2_RES_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2206_REM_MIG2_RES_RESERVAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2206_REM_MIG2_RES_RESERVAS.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2206_REM_MIG2_RES_RESERVAS.sql"
	      cat DDL_2206_REM_MIG2_RES_RESERVAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2206_REM_MIG2_RES_RESERVAS.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2206_REM_MIG2_RES_RESERVAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS-REM01-reg3.1.sql > DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql"
	      cat DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2207_REM_MIG2_ERE_ENTREGAS_RESERVAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI-REM01-reg3.1.sql > DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql"
	      cat DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2208_REM_MIG2_OFR_TIA_TITULARES_ADI.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE-REM01-reg3.1.sql > DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql"
	      cat DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2210_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql 20160913 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160913" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE-REM01-reg3.1.sql > DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql" "20160913" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql"
	      cat DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql" "20160913" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2213_REM_MIG2_COV_COMPARECIENTES_VENDE.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS-REM01-reg3.1.sql > DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql"
	      cat DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2215_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2216_REM_MIG2_FOR_FORMALIZACIONES-REM01-reg3.1.sql > DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql"
	      cat DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2216_REM_MIG2_FOR_FORMALIZACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2217_REM_MIG2_POS_POSICIONAMIENTO-REM01-reg3.1.sql > DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql"
	      cat DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2217_REM_MIG2_POS_POSICIONAMIENTO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2218_REM_MIG2_SUB_SUBSANACIONES-REM01-reg3.1.sql > DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql"
	      cat DDL_2218_REM_MIG2_SUB_SUBSANACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2218_REM_MIG2_SUB_SUBSANACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI-REM01-reg3.1.sql > DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql"
	      cat DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2222_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC-REM01-reg3.1.sql > DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql"
	      cat DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2223_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-791" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES-REM01-reg3.1.sql > DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql"
	      cat DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2224_REM_MIG2_ACT_VAL_VALORACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES-REM01-reg3.1.sql > DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql"
	      cat DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2225_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql 20160919 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160919" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS-REM01-reg3.1.sql > DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql" "20160919" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql"
	      cat DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql" "20160919" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2226_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2227_REM_MIG2_ACT_PRP.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2227_REM_MIG2_ACT_PRP.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2227_REM_MIG2_ACT_PRP.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2227_REM_MIG2_ACT_PRP.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2227_REM_MIG2_ACT_PRP.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2227_REM_MIG2_ACT_PRP-REM01-reg3.1.sql > DDL_2227_REM_MIG2_ACT_PRP.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2227_REM_MIG2_ACT_PRP.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2227_REM_MIG2_ACT_PRP.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2227_REM_MIG2_ACT_PRP.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2227_REM_MIG2_ACT_PRP.sql"
	      cat DDL_2227_REM_MIG2_ACT_PRP.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2227_REM_MIG2_ACT_PRP.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2227_REM_MIG2_ACT_PRP.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2232_REM_MIG2_PVE_PROVEEDORES-REM01-reg3.1.sql > DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql"
	      cat DDL_2232_REM_MIG2_PVE_PROVEEDORES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2232_REM_MIG2_PVE_PROVEEDORES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION-REM01-reg3.1.sql > DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql"
	      cat DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2233_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql 20160920 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160920" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql" "20160920" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql"
	      cat DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql" "20160920" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2234_REM_MIG2_PVC_PROVEEDOR_CONTACTO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES-REM01-reg3.1.sql > DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql"
	      cat DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2235_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO-REM01-reg3.1.sql > DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql"
	      cat DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2236_REM_MIG2_GPA_GASTOS_PROVEE_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO-REM01-reg3.1.sql > DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql"
	      cat DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2237_REM_MIG2_GPT_GASTOS_PROVEE_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2239_REM_MIG2_GGE_GASTOS_GESTION-REM01-reg3.1.sql > DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql"
	      cat DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2239_REM_MIG2_GGE_GASTOS_GESTION.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION-REM01-reg3.1.sql > DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql"
	      cat DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2240_REM_MIG2_GIM_GASTOS_IMPUGANCION.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD-REM01-reg3.1.sql > DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql"
	      cat DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2241_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2244_REM_MIG2_ACT_ACTIVO.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2244_REM_MIG2_ACT_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2244_REM_MIG2_ACT_ACTIVO.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2244_REM_MIG2_ACT_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2244_REM_MIG2_ACT_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2244_REM_MIG2_ACT_ACTIVO-REM01-reg3.1.sql > DDL_2244_REM_MIG2_ACT_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2244_REM_MIG2_ACT_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2244_REM_MIG2_ACT_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2244_REM_MIG2_ACT_ACTIVO.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2244_REM_MIG2_ACT_ACTIVO.sql"
	      cat DDL_2244_REM_MIG2_ACT_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2244_REM_MIG2_ACT_ACTIVO.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2244_REM_MIG2_ACT_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql 20160927 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql" "REM01" "MANUEL RODRIGUEZ" "batch"  "0.1" "20160927" "HREOS-855" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_PREV_tables_REM01_DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO-REM01-reg3.1.sql > DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	  export RESULTADO=$?
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_tables.sql > DB_SNAPSHOT_POST_tables_REM01_DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	  exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql" "20160927" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql"
	      cat DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql" "20160927" "REM01" "OK" "" > /dev/null
	      echo " OK : DDL_2245_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql" "REM01" "JOSEVI JIMENEZ" "online"  "9.2" "20160928" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l $1 @./scripts/DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS-REM01-reg3.1.sql > DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	echo " -- : DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql" "REM01" "DANIEL GUTIÉRREZ" "online"  "9.2" "20160628" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l $1 @./scripts/DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD-REM01-reg3.1.sql > DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	echo " -- : DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql" "REM01" "Luis Caballero" "online"  "9.1" "20160921" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	exit | sqlplus -s -l $1 @./scripts/DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR-REM01-reg3.1.sql > DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	echo " -- : DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
}

run_scripts "$@" | tee output.log
