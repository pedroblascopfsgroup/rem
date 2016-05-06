#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT GESTION ASUNTO POR MARCA HAYA $0"
echo "########################################################"
echo "#####    INICIO CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql"
echo "########################################################"
echo "Inicio CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql"

echo "Inicio PREPARACION ENTORNO"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_377_ENTITY01_DATEJD-CreacionTablaMIGPropuestasParche.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_377_ENTITY01_DATEJD-CreacionTablaMIGPropuestasParche.sql
   exit 1
fi

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_378_ENTITY01_DATEJD-CargaTablaTemporalPropuestas.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_378_ENTITY01_DATEJD-CargaTablaTemporalPropuestas.sql
   exit 1
fi

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_379_ENTITY01_DATEJD-CargaTablaTemporalPropuestas_P2.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_379_ENTITY01_DATEJD-CargaTablaTemporalPropuestas_P2.sql
   exit 1
fi



echo "Inicio MIGRAR_ALTA_DUDOSO_V1.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_ALTA_DUDOSO_V1.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_ALTA_DUDOSO_V1.sql
   exit 1
fi

echo "Inicio MIGRAR_REFINANCIACION_NOVACION_V1.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_REFINANCIACION_NOVACION_V1.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_REFINANCIACION_NOVACION_V1.sql
   exit 1
fi

echo "Inicio MIGRAR_REFINANCIACION_NOVACION_V2.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_REFINANCIACION_NOVACION_V2.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_REFINANCIACION_NOVACION_V2.sql
   exit 1
fi

echo "Inicio MIGRAR_FONDOS_PROPIOS_V1.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_FONDOS_PROPIOS_V1.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_FONDOS_PROPIOS_V1.sql
   exit 1
fi


echo "Fin CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS. Revise el fichero de log"
exit 0
