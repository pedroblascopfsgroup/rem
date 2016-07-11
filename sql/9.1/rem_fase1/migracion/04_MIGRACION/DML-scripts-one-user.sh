#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi


exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA-REM01-reg3.1.sql > DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1401_REM_MIGRATION_MIG_CPC_PROP_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1402_REM_MIGRATION_MIG_ACA_CABECERA-REM01-reg3.1.sql > DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1402_REM_MIGRATION_MIG_ACA_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI-REM01-reg3.1.sql > DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1403_REM_MIGRATION_MIG_ADA_DATOS_ADI.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1404_REM_MIGRATION_MIG_ATI_TITULO-REM01-reg3.1.sql > DML_1404_REM_MIGRATION_MIG_ATI_TITULO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1404_REM_MIGRATION_MIG_ATI_TITULO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1405_REM_MIGRATION_MIG_APC_PRECIO-REM01-reg3.1.sql > DML_1405_REM_MIGRATION_MIG_APC_PRECIO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1405_REM_MIGRATION_MIG_APC_PRECIO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS-REM01-reg3.1.sql > DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1406_REM_MIGRATION_MIG_APL_PLANDINVENTAS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL-REM01-reg3.1.sql > DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1407_REM_MIGRATION_MIG_ADJ_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql 20160212 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160212" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "20160212" "REM01" "KO" ""
      echo "@KO@: DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql" "20160212" "REM01" "OK" ""
      echo " OK : DML_1408_REM_MIGRATION_MIG_ADJ_NO_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160229" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO-REM01-reg3.1.sql > DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1409_REM_MIGRATION_MIG_ACA_CARGAS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql 20160307 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160307" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO-REM01-reg3.1.sql > DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "20160307" "REM01" "KO" ""
      echo "@KO@: DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql" "20160307" "REM01" "OK" ""
      echo " OK : DML_1410_REM_MIGRATION_MIG_TASACIONES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160229" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA-REM01-reg3.1.sql > DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1411_REM_MIGRATION_MIG_APC_PROP_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160229" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO-REM01-reg3.1.sql > DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1412_REM_MIGRATION_MIG_APA_PROP_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql 20160307 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql" "REM01" "David González" "batch"  "0.1" "20160307" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_14131_REM_MIGRATION_MIG_PROVEEDORES-REM01-reg3.1.sql > DML_14131_REM_MIGRATION_MIG_PROVEEDORES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql" "20160307" "REM01" "KO" ""
      echo "@KO@: DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql" "20160307" "REM01" "OK" ""
      echo " OK : DML_14131_REM_MIGRATION_MIG_PROVEEDORES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql 20160308 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "REM01" "JAVIER DIAZ" "batch"  "0.1" "20160308" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160308" "REM01" "KO" ""
      echo "@KO@: DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160308" "REM01" "OK" ""
      echo " OK : DML_1413_REM_MIGRATION_MIG_INFOCOMERCIAL_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR-REM01-reg3.1.sql > DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1414_REM_MIGRATION_MIG_AID_INFOCOMERCIAL_DISTR.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "REM01" "JAVIER DIAZ" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO-REM01-reg3.1.sql > DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1415_REM_MIGRATION_MIG_CALIDADES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql" "REM01" "David González" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1416_REM_MIGRATION_MIG_AGRUPACIONES-REM01-reg3.1.sql > DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1416_REM_MIGRATION_MIG_AGRUPACIONES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO-REM01-reg3.1.sql > DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1417_REM_MIGRATION_MIG_AGRUPACIONES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql 20160308 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160308" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP-REM01-reg3.1.sql > DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "20160308" "REM01" "KO" ""
      echo "@KO@: DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql" "20160308" "REM01" "OK" ""
      echo " OK : DML_1418_REM_MIGRATION_MIG_ASA_SUBDIVISIONES_AGRUP.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql 20160307 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160307" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP-REM01-reg3.1.sql > DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "20160307" "REM01" "KO" ""
      echo "@KO@: DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql" "20160307" "REM01" "OK" ""
      echo " OK : DML_1419_REM_MIGRATION_MIG_AOA_OBSERVACIONES_AGRUP.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql 20160229 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160229" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO-REM01-reg3.1.sql > DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "20160229" "REM01" "KO" ""
      echo "@KO@: DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql" "20160229" "REM01" "OK" ""
      echo " OK : DML_1420_REM_MIGRATION_MIG_ACA_CATASTRO_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql 20160304 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "REM01" "David González" "batch"  "0.1" "20160304" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO-REM01-reg3.1.sql > DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "20160304" "REM01" "KO" ""
      echo "@KO@: DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql" "20160304" "REM01" "OK" ""
      echo " OK : DML_1421_REM_MIGRATION_MIG_LLAVES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql 20160308 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160308" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160308" "REM01" "KO" ""
      echo "@KO@: DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql" "20160308" "REM01" "OK" ""
      echo " OK : DML_1422_REM_MIGRATION_MIG_AML_MOVIMIENTOS_LLAVE.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "REM01" "David González" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1425_REM_MIGRATION_MIG_PROVEEDOR_CONTACTO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql 20160309 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160309" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160309" "REM01" "KO" ""
      echo "@KO@: DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql" "20160309" "REM01" "OK" ""
      echo " OK : DML_1426_REM_MIGRATION_MIG_AEP_ENTIDAD_PROVEEDOR.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql 20160309 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160309" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO-REM01-reg3.1.sql > DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "20160309" "REM01" "KO" ""
      echo "@KO@: DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql" "20160309" "REM01" "OK" ""
      echo " OK : DML_1427_REM_MIGRATION_MIG_ATR_TRABAJO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql 20160302 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160302" "HREOS-166" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "20160302" "REM01" "KO" ""
      echo "@KO@: DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql" "20160302" "REM01" "OK" ""
      echo " OK : DML_1428_REM_MIGRATION_MIG_PRESUPUESTO_TRABAJO.sql"
  fi
fi
