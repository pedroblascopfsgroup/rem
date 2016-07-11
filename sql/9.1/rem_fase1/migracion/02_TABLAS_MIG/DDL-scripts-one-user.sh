#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi


export NLS_LANG=.AL32UTF8
exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01.sql
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql 20160209 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "REM01" "David González" "batch"  "0.1" "20160209" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA-REM01-reg3.1.sql > DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "20160209" "REM01" "KO" ""
      echo "@KO@: DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql" "20160209" "REM01" "OK" ""
      echo " OK : DDL_1201_REM_HAYA01_MIG_ACTIVO_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO-REM01-reg3.1.sql > DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql" "20160216" "REM01" "OK" ""
      echo " OK : DDL_1202_REM_HAYA01_MIG_ACTIVO_TITULO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS-REM01-reg3.1.sql > DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql" "20160216" "REM01" "OK" ""
      echo " OK : DDL_1203_REM_HAYA01_MIG_ACTIVO_PLANDINVENTAS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL-REM01-reg3.1.sql > DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql" "20160216" "REM01" "OK" ""
      echo " OK : DDL_1204_REM_HAYA01_MIG_ACTIVO_ADJ_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql 20160216 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "REM01" "David González" "batch"  "0.1" "20160216" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL-REM01-reg3.1.sql > DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "20160216" "REM01" "KO" ""
      echo "@KO@: DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql" "20160216" "REM01" "OK" ""
      echo " OK : DDL_1205_REM_HAYA01_MIG_ACTIVO_ADJ_NO_JUDICIAL.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql 20160217 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160217" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA-REM01-reg3.1.sql > DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "20160217" "REM01" "KO" ""
      echo "@KO@: DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql" "20160217" "REM01" "OK" ""
      echo " OK : DDL_1206_REM_HAYA01_MIG_ACTIVO_COM_PROP_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql 20160209 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "REM01" "David González" "batch"  "0.1" "20160209" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES-REM01-reg3.1.sql > DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "20160209" "REM01" "KO" ""
      echo "@KO@: DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql" "20160209" "REM01" "OK" ""
      echo " OK : DDL_1207_REM_HAYA01_MIG_ACTIVO_DATOSADICIONALES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql 20160217 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160217" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA-REM01-reg3.1.sql > DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "20160217" "REM01" "KO" ""
      echo "@KO@: DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql" "20160217" "REM01" "OK" ""
      echo " OK : DDL_1208_REM_HAYA01_MIG_PROPIETARIOS_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql 20160217 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160217" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO-REM01-reg3.1.sql > DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "20160217" "REM01" "KO" ""
      echo "@KO@: DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql" "20160217" "REM01" "OK" ""
      echo " OK : DDL_1209_REM_HAYA01_MIG_PROPIETARIOS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql 20160218 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160218" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO-REM01-reg3.1.sql > DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "20160218" "REM01" "KO" ""
      echo "@KO@: DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql" "20160218" "REM01" "OK" ""
      echo " OK : DDL_1210_REM_HAYA01_MIG_CATASTRO_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql 20160218 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160218" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO-REM01-reg3.1.sql > DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "20160218" "REM01" "KO" ""
      echo "@KO@: DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql" "20160218" "REM01" "OK" ""
      echo " OK : DDL_1211_REM_HAYA01_MIG_CARGAS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql 20160219 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160219" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO-REM01-reg3.1.sql > DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "20160219" "REM01" "KO" ""
      echo "@KO@: DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql" "20160219" "REM01" "OK" ""
      echo " OK : DDL_1212_REM_HAYA01_MIG_OCUPANTES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql 20160304 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160304" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO-REM01-reg3.1.sql > DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "20160304" "REM01" "KO" ""
      echo "@KO@: DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql" "20160304" "REM01" "OK" ""
      echo " OK : DDL_1213_REM_HAYA01_MIG_LLAVES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql 20160218 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160218" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE-REM01-reg3.1.sql > DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "20160218" "REM01" "KO" ""
      echo "@KO@: DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql" "20160218" "REM01" "OK" ""
      echo " OK : DDL_1214_REM_HAYA01_MIG_MOVIMIENTOS_LLAVE.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql 20160219 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160219" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO-REM01-reg3.1.sql > DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "20160219" "REM01" "KO" ""
      echo "@KO@: DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql" "20160219" "REM01" "OK" ""
      echo " OK : DDL_1215_REM_HAYA01_MIG_TASACIONES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql 20160217 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "REM01" "Javier Díaz" "batch"  "0.1" "20160217" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO-REM01-reg3.1.sql > DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160217" "REM01" "KO" ""
      echo "@KO@: DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql" "20160217" "REM01" "OK" ""
      echo " OK : DDL_1216_REM_HAYA01_MIG_INFOCOMERCIAL_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql 20160222 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "REM01" "Javier Díaz" "batch"  "0.1" "20160222" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO-REM01-reg3.1.sql > DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "20160222" "REM01" "KO" ""
      echo "@KO@: DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql" "20160222" "REM01" "OK" ""
      echo " OK : DDL_1217_REM_HAYA01_MIG_CALIDADES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION-REM01-reg3.1.sql > DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1218_REM_HAYA01_MIG_INFOCOMERCIAL_DISTRIBUCION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS-REM01-reg3.1.sql > DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1219_REM_HAYA01_MIG_OBSERVACIONES_ACTIVOS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql 20160219 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160219" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA-REM01-reg3.1.sql > DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "20160219" "REM01" "KO" ""
      echo "@KO@: DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql" "20160219" "REM01" "OK" ""
      echo " OK : DDL_1220_REM_HAYA01_MIG_IMAGENES_CABECERA.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql 20160219 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160219" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO-REM01-reg3.1.sql > DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "20160219" "REM01" "KO" ""
      echo "@KO@: DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql" "20160219" "REM01" "OK" ""
      echo " OK : DDL_1221_REM_HAYA01_MIG_IMAGENES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql 20160222 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160222" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO-REM01-reg3.1.sql > DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "20160222" "REM01" "KO" ""
      echo "@KO@: DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql" "20160222" "REM01" "OK" ""
      echo " OK : DDL_1222_REM_HAYA01_MIG_DOCUMENTOS_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql 20160222 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160222" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO-REM01-reg3.1.sql > DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "20160222" "REM01" "KO" ""
      echo "@KO@: DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql" "20160222" "REM01" "OK" ""
      echo " OK : DDL_1223_REM_HAYA01_MIG_AGRUPACIONES_ACTIVO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql 20160222 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160222" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1224_REM_HAYA01_MIG_AGRUPACIONES-REM01-reg3.1.sql > DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql" "20160222" "REM01" "KO" ""
      echo "@KO@: DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql" "20160222" "REM01" "OK" ""
      echo " OK : DDL_1224_REM_HAYA01_MIG_AGRUPACIONES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION-REM01-reg3.1.sql > DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1225_REM_HAYA01_MIG_OBSERVACIONES_AGRUPACION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION-REM01-reg3.1.sql > DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1226_REM_HAYA01_MIG_IMAGENES_AGRUPACION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION-REM01-reg3.1.sql > DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1227_REM_HAYA01_MIG_SUBDIVISIONES_AGRUPACION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION-REM01-reg3.1.sql > DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1228_REM_HAYA01_MIG_IMAGENES_SUBDIVISION.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1229_REM_HAYA01_MIG_PROVEEDORES-REM01-reg3.1.sql > DDL_1229_REM_HAYA01_MIG_PROVEEDORES.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1229_REM_HAYA01_MIG_PROVEEDORES.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql 20160218 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160218" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS-REM01-reg3.1.sql > DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "20160218" "REM01" "KO" ""
      echo "@KO@: DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql" "20160218" "REM01" "OK" ""
      echo " OK : DDL_1230_REM_HAYA01_MIG_ACTIVO_COM_PROP_CUOTAS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR-REM01-reg3.1.sql > DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1231_REM_HAYA01_MIG_ENTIDAD_PROVEEDOR.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1232_REM_HAYA01_MIG_TRABAJO.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1232_REM_HAYA01_MIG_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1232_REM_HAYA01_MIG_TRABAJO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1232_REM_HAYA01_MIG_TRABAJO-REM01-reg3.1.sql > DDL_1232_REM_HAYA01_MIG_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1232_REM_HAYA01_MIG_TRABAJO.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1232_REM_HAYA01_MIG_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1232_REM_HAYA01_MIG_TRABAJO.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1232_REM_HAYA01_MIG_TRABAJO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO-REM01-reg3.1.sql > DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1233_REM_HAYA01_MIG_PRESUPUESTO_TRABAJO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql 20160224 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160224" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO-REM01-reg3.1.sql > DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "20160224" "REM01" "KO" ""
      echo "@KO@: DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql" "20160224" "REM01" "OK" ""
      echo " OK : DDL_1234_REM_HAYA01_MIG_PROVISION_SUPLIDO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO-REM01-reg3.1.sql > DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1235_REM_HAYA01_MIG_PROVEEDOR_CONTACTO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1236_REM_HAYA01_MIG_PRECIO.sql 20160218 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1236_REM_HAYA01_MIG_PRECIO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1236_REM_HAYA01_MIG_PRECIO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160218" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1236_REM_HAYA01_MIG_PRECIO-REM01-reg3.1.sql > DDL_1236_REM_HAYA01_MIG_PRECIO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1236_REM_HAYA01_MIG_PRECIO.sql" "20160218" "REM01" "KO" ""
      echo "@KO@: DDL_1236_REM_HAYA01_MIG_PRECIO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1236_REM_HAYA01_MIG_PRECIO.sql" "20160218" "REM01" "OK" ""
      echo " OK : DDL_1236_REM_HAYA01_MIG_PRECIO.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql 20160223 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "REM01" "Pablo Meseguer" "batch"  "0.1" "20160223" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS-REM01-reg3.1.sql > DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "20160223" "REM01" "KO" ""
      echo "@KO@: DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql" "20160223" "REM01" "OK" ""
      echo " OK : DDL_1237_REM_HAYA01_MIG_ADMISION_DOCUMENTOS.sql"
  fi
fi
exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg2.sql DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql 20160224 REM01 > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then
    echo " YE : Fichero ya ejecutado DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
elif [ $RESULTADO != 0 ] ; then
    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."
    exit 1;
else
  exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "REM01" "Manuel Rodriguez" "batch"  "0.1" "20160224" "HREOS-67B" "NO"
  exit | sqlplus -s -l $1 @./scripts/DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO-REM01-reg3.1.sql > DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.log
  export RESULTADO=$?
  if [ $RESULTADO != 0 ] ; then
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "20160224" "REM01" "KO" ""
      echo "@KO@: DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
      exit 1
  else
      exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg4.sql "DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql" "20160224" "REM01" "OK" ""
      echo " OK : DDL_1238_REM_HAYA01_MIG_PRESUPUESTO_ACTIVO.sql"
  fi
fi
