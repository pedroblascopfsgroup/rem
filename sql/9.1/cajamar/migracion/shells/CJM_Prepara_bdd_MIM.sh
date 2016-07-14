#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit 1
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT carterizacion LETRADOS PROCURADORES $0"
echo "########################################################"
echo "#####    INICIO CJM_Prepara_bdd_MIM.sql"
echo "########################################################"
echo "Inicio CJM_Prepara_bdd_MIM.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_406_ENTITY01_DATGMN-CreacionTablasProcedimientosOperacionesMIM.sql

if [ $? != 0 ] ; then
   echo "[INFO] Error 1 "
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_406_ENTITY01_DATGMN-CreacionTablasProcedimientosOperacionesMIM.sql
   exit 1
fi
echo "[INFO] 1 "
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_407_ENTITY01_DATGMN-ModificacionTablaExpedientesCabeceraMIM.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_407_ENTITY01_DATGMN-ModificacionTablaExpedientesCabeceraMIM.sql
   exit 1
fi
echo "[INFO] 2 "
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_408_ENTITY01_DATGMN-CreacionTablasProcedimientosDemandadosMIM.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_408_ENTITY01_DATGMN-CreacionTablasProcedimientosDemandadosMIM.sql
   exit 1
fi

echo "[INFO] 3 "
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_409_ENTITY01_DATGMN-CreacionTablasProcedimientosCabeceraMIM.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_409_ENTITY01_DATGMN-CreacionTablasProcedimientosCabeceraMIM.sql
   exit 1
fi


$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_410_ENTITY01_DATJGM-CreacionTablasProcedimientosActoresMIM.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_410_ENTITY01_DATJGM-CreacionTablasProcedimientosActoresMIM.sql
   exit 1
fi

echo "Fin CJM_Prepara_bdd_MIM. Revise el fichero de log"
exit 0
