#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi

function run_scripts {
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA-REM01-reg3.1.sql > DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
	      cat DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1439_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1440_REM_MIGRATION_MIG_ACA_CABECERA-REM01-reg3.1.sql > DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql"
	      cat DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1440_REM_MIGRATION_MIG_ACA_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI-REM01-reg3.1.sql > DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
	      cat DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1441_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1442_REM_MIGRATION_MIG_ATI_TITULO-REM01-reg3.1.sql > DML_1442_REM_MIGRATION_MIG_ATI_TITULO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql"
	      cat DML_1442_REM_MIGRATION_MIG_ATI_TITULO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1442_REM_MIGRATION_MIG_ATI_TITULO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1443_REM_MIGRATION_MIG_APC_PRECIO-REM01-reg3.1.sql > DML_1443_REM_MIGRATION_MIG_APC_PRECIO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql"
	      cat DML_1443_REM_MIGRATION_MIG_APC_PRECIO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1443_REM_MIGRATION_MIG_APC_PRECIO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS-REM01-reg3.1.sql > DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
	      cat DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1444_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL-REM01-reg3.1.sql > DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
	      cat DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1445_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
	      cat DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1446_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO-REM01-reg3.1.sql > DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
	      cat DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1447_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO-REM01-reg3.1.sql > DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
	      cat DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1448_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA-REM01-reg3.1.sql > DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
	      cat DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1449_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO-REM01-reg3.1.sql > DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
	      cat DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1450_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
	      cat DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1451_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR-REM01-reg3.1.sql > DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
	      cat DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1452_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO-REM01-reg3.1.sql > DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
	      cat DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1453_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1454_REM_MIGRATION_MIG_AGRUPACIONES-REM01-reg3.1.sql > DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql"
	      cat DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1454_REM_MIGRATION_MIG_AGRUPACIONES.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO-REM01-reg3.1.sql > DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
	      cat DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1455_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP-REM01-reg3.1.sql > DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
	      cat DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1456_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP-REM01-reg3.1.sql > DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
	      cat DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1457_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO-REM01-reg3.1.sql > DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
	      cat DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1458_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO-REM01-reg3.1.sql > DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
	      cat DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1459_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	      cat DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1460_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
	      cat DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1461_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	      cat DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1462_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO-REM01-reg3.1.sql > DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
	      cat DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1463_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
	      cat DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1464_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
	  fi
	fi
	exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql 20160803 REM01 > /dev/null
	export RESULTADO=$?
	if [ $RESULTADO == 33 ] ; then
	    echo " YE : Fichero ya ejecutado DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql"
	elif [ $RESULTADO != 0 ] ; then
	    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
	    exit 1
	else
	  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql" "REM01" "CLV" "batch"  "0.1" "20160803" "HREOS-719" "NO" > /dev/null
	  exit | sqlplus -s -l $1 @./scripts/DML_1466_REM_MIGRATION_MIG_PROVEEDORES-REM01-reg3.1.sql > DML_1466_REM_MIGRATION_MIG_PROVEEDORES.log
	  export RESULTADO=$?
	  if [ $RESULTADO != 0 ] ; then
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql" "20160803" "REM01" "KO" "" > /dev/null
	      echo "@KO@: DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql"
	      cat DML_1466_REM_MIGRATION_MIG_PROVEEDORES.log
	      exit 1
	  else
	      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql" "20160803" "REM01" "OK" "" > /dev/null
	      echo " OK : DML_1466_REM_MIGRATION_MIG_PROVEEDORES.sql"
	  fi
	fi
}

run_scripts "$@" | tee output.log
