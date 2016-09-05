#!/bin/bash
exit;

if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi


export NLS_LANG=.AL32UTF8
exit | sqlplus -s -l $1 @./scripts/DDL_000_HAYA01.sql
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql 20160216 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160216" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql" "20160216" "HAYA01" "KO" ""
      echo "@KO@: DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql" "20160216" "HAYA01" "OK" ""
      echo " OK : DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql 20160219 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160219" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0069_REM_HAYA01_ACT_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql" "20160219" "HAYA01" "KO" ""
      echo "@KO@: DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql" "20160219" "HAYA01" "OK" ""
      echo " OK : DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql 20160229 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160229" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0070_REM_HAYA01_CPR_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql" "20160229" "HAYA01" "KO" ""
      echo "@KO@: DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql" "20160229" "HAYA01" "OK" ""
      echo " OK : DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql 20160229 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160229" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0071_REM_HAYA01_PRO_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql" "20160229" "HAYA01" "KO" ""
      echo "@KO@: DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql" "20160229" "HAYA01" "OK" ""
      echo " OK : DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql 20160229 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160229" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0072_REM_HAYA01_AGR_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql" "20160229" "HAYA01" "KO" ""
      echo "@KO@: DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql" "20160229" "HAYA01" "OK" ""
      echo " OK : DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql 20160229 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql" "HAYA01" "DAVID GONZALEZ" "online"  "9.1" "20160229" "0" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_0073_REM_HAYA01_PVE_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql" "20160229" "HAYA01" "KO" ""
      echo "@KO@: DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql" "20160229" "HAYA01" "OK" ""
      echo " OK : DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg2.sql DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql 20160229 HAYA01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg3.sql "DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql" "HAYA01" "David González" "batch"  "0.1" "20160229" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DML_0070_REM_HAYA01_INSERT_DD_ENO_9999-HAYA01-reg3.1.sql > DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql" "20160229" "HAYA01" "KO" ""
      echo "@KO@: DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DML_000_ENTITY01_reg4.sql "DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql" "20160229" "HAYA01" "OK" ""
      echo " OK : DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.sql"
  fi
fi
