#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi

function run_scripts {
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1339_CHECK_DD_MIG_ACA_CABECERA-REM01-reg3.1.sql > DML_1339_CHECK_DD_MIG_ACA_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql"
	      cat DML_1339_CHECK_DD_MIG_ACA_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1339_CHECK_DD_MIG_ACA_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1340_CHECK_DD_MIG_ATI_TITULO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1340_CHECK_DD_MIG_ATI_TITULO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1340_CHECK_DD_MIG_ATI_TITULO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1340_CHECK_DD_MIG_ATI_TITULO-REM01-reg3.1.sql > DML_1340_CHECK_DD_MIG_ATI_TITULO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1340_CHECK_DD_MIG_ATI_TITULO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1340_CHECK_DD_MIG_ATI_TITULO.sql"
	      cat DML_1340_CHECK_DD_MIG_ATI_TITULO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1340_CHECK_DD_MIG_ATI_TITULO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1340_CHECK_DD_MIG_ATI_TITULO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL-REM01-reg3.1.sql > DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
	      cat DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1342_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
	      cat DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1343_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI-REM01-reg3.1.sql > DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
	      cat DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1345_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA-REM01-reg3.1.sql > DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
	      cat DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1346_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO-REM01-reg3.1.sql > DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
	      cat DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1347_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO-REM01-reg3.1.sql > DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
	      cat DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1349_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	      cat DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1352_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO-REM01-reg3.1.sql > DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
	      cat DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1353_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
	      cat DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1354_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO-REM01-reg3.1.sql > DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
	      cat DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1355_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION-REM01-reg3.1.sql > DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
	      cat DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1356_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA-REM01-reg3.1.sql > DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
	      cat DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1358_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO-REM01-reg3.1.sql > DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
	      cat DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1360_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES-REM01-reg3.1.sql > DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
	      cat DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1362_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION-REM01-reg3.1.sql > DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
	      cat DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1365_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1367_CHECK_DD_MIG_APR_PROVEEDORES-REM01-reg3.1.sql > DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql"
	      cat DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1367_CHECK_DD_MIG_APR_PROVEEDORES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS-REM01-reg3.1.sql > DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
	      cat DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1368_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	      cat DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1369_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1370_CHECK_DD_MIG_ATR_TRABAJO-REM01-reg3.1.sql > DML_1370_CHECK_DD_MIG_ATR_TRABAJO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql"
	      cat DML_1370_CHECK_DD_MIG_ATR_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1370_CHECK_DD_MIG_ATR_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
	      cat DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1371_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO-REM01-reg3.1.sql > DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
	      cat DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1372_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
	      cat DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1373_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1374_CHECK_DD_MIG_APC_PRECIO.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1374_CHECK_DD_MIG_APC_PRECIO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1374_CHECK_DD_MIG_APC_PRECIO.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1374_CHECK_DD_MIG_APC_PRECIO-REM01-reg3.1.sql > DML_1374_CHECK_DD_MIG_APC_PRECIO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1374_CHECK_DD_MIG_APC_PRECIO.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1374_CHECK_DD_MIG_APC_PRECIO.sql"
	      cat DML_1374_CHECK_DD_MIG_APC_PRECIO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1374_CHECK_DD_MIG_APC_PRECIO.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1374_CHECK_DD_MIG_APC_PRECIO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql 201600803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "REM01" "CLV" "batch"  "0.1" "201600803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS-REM01-reg3.1.sql > DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "201600803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
	      cat DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "201600803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1375_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
	  fi
	fi
}

run_scripts "$@" | tee output.log
