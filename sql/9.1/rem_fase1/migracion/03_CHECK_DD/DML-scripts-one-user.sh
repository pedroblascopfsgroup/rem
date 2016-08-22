#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi


exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1301_CHECK_DD_MIG_ACA_CABECERA-REM01-reg3.1.sql > DML_1301_CHECK_DD_MIG_ACA_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1301_CHECK_DD_MIG_ACA_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1302_CHECK_DD_MIG_ATI_TITULO.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1302_CHECK_DD_MIG_ATI_TITULO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1302_CHECK_DD_MIG_ATI_TITULO.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1302_CHECK_DD_MIG_ATI_TITULO-REM01-reg3.1.sql > DML_1302_CHECK_DD_MIG_ATI_TITULO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1302_CHECK_DD_MIG_ATI_TITULO.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1302_CHECK_DD_MIG_ATI_TITULO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1302_CHECK_DD_MIG_ATI_TITULO.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1302_CHECK_DD_MIG_ATI_TITULO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL-REM01-reg3.1.sql > DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1304_CHECK_DD_MIG_ADJ_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1305_CHECK_DD_MIG_ADJ_NO_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI-REM01-reg3.1.sql > DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1307_CHECK_DD_MIG_ADA_DATOS_ADI.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA-REM01-reg3.1.sql > DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1308_CHECK_DD_MIG_APC_PROP_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO-REM01-reg3.1.sql > DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1309_CHECK_DD_MIG_APA_PROP_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO-REM01-reg3.1.sql > DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1311_CHECK_DD_MIG_ACA_CARGAS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1314_CHECK_DD_MIG_AML_MOVIMIENTOS_LLAVE.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO-REM01-reg3.1.sql > DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1315_CHECK_DD_MIG_ATA_TASACIONES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1316_CHECK_DD_MIG_AIA_INFOCOMERCIAL_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160302" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO-REM01-reg3.1.sql > DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1317_CHECK_DD_MIG_ACA_CALIDADES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160229" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION-REM01-reg3.1.sql > DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1318_CHECK_DD_MIG_AID_INFOCOMERCIAL_DISTRIBUCION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA-REM01-reg3.1.sql > DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1320_CHECK_DD_MIG_AIC_IMAGENES_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO-REM01-reg3.1.sql > DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1322_CHECK_DD_MIG_ADA_DOCUMENTOS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "REM01" "Manuel Rodríguez" "batch"  "0.1" "20160229" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES-REM01-reg3.1.sql > DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1324_CHECK_DD_MIG_AAG_AGRUPACIONES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160229" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION-REM01-reg3.1.sql > DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1327_CHECK_DD_MIG_ASA_SUBDIVISIONES_AGRUPACION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql" "REM01" "Manuel Rodríguez" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1329_CHECK_DD_MIG_APR_PROVEEDORES-REM01-reg3.1.sql > DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1329_CHECK_DD_MIG_APR_PROVEEDORES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS-REM01-reg3.1.sql > DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql" "20160216" "REM01" "OK" ""
      echo " OK : DML_1330_CHECK_DD_MIG_CPC_PROP_CUOTAS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1331_CHECK_DD_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql" "REM01" "Manuel Rodríguez" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1332_CHECK_DD_MIG_ATR_TRABAJO-REM01-reg3.1.sql > DML_1332_CHECK_DD_MIG_ATR_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1332_CHECK_DD_MIG_ATR_TRABAJO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1333_CHECK_DD_MIG_APT_PRESUPUESTO_TRABAJO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "REM01" "Manuel Rodríguez" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO-REM01-reg3.1.sql > DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1334_CHECK_DD_MIG_APS_PROVISION_SUPLIDO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql 20160301 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160301" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "20160301" "REM01" "KO" ""
      echo "@KO@: DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql" "20160301" "REM01" "OK" ""
      echo " OK : DML_1335_CHECK_DD_MIG_APC_PROVEEDOR_CONTACTO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1336_CHECK_DD_MIG_APC_PRECIO.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1336_CHECK_DD_MIG_APC_PRECIO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1336_CHECK_DD_MIG_APC_PRECIO.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1336_CHECK_DD_MIG_APC_PRECIO-REM01-reg3.1.sql > DML_1336_CHECK_DD_MIG_APC_PRECIO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1336_CHECK_DD_MIG_APC_PRECIO.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1336_CHECK_DD_MIG_APC_PRECIO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1336_CHECK_DD_MIG_APC_PRECIO.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1336_CHECK_DD_MIG_APC_PRECIO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql 20160225 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "REM01" "David González" "batch"  "0.1" "20160225" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS-REM01-reg3.1.sql > DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "20160225" "REM01" "KO" ""
      echo "@KO@: DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql" "20160225" "REM01" "OK" ""
      echo " OK : DML_1337_CHECK_DD_MIG_ADD_ADMISION_DOCUMENTOS.sql"
  fi
fi
