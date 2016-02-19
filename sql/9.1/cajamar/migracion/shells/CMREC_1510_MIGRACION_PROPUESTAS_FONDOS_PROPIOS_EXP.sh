#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION PROPUESTAS FONDOS PROPIOS EXPEDIENTES $0"
echo "########################################################"
echo "#####    INICIO CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS_EXP.sh"
echo "########################################################"
echo "Inicio MIGRAR_PROPUESTAS_CON_EXPEDIENTES.sql"

echo "Inicio PREPARACION ENTORNO"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_379_ENTITY01_DATGMN-CreacionTablaTMPMIGPropuestas_ConExpediente.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_379_ENTITY01_DATGMN-CreacionTablaTMPMIGPropuestas_ConExpediente.sql
   exit 1
fi



echo "Inicio MIGRAR_PROPUESTAS_CON_EXPEDIENTES.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_PROPUESTAS_CON_EXPEDIENTES_V2.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_PROPUESTAS_CON_EXPEDIENTES_V2.sql
   exit 1
fi


echo "Fin CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS_EXP.sh. Revise el fichero de log"
exit 0
