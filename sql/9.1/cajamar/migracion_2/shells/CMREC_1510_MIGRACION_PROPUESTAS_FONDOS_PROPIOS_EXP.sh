#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi


fecha="$2"

ctl_dir="ctl/"
dat_dir="dat/"
log_dir="log/"
bad_dir="bad/"
sql_dir="sql/"

echo "[INFO] Datos de aprovisionamiento de fecha "$fecha
echo "[INFO] Directorio CTL: "$ctl_dir
echo "[INFO] Directorio DAT: "$dat_dir

if [ ! -f $ORACLE_HOME/bin/sqlldr ]; then
    echo "[ERROR] No se encuentra SQL Loader. Compruebe la instalación de cliente Oracle y variable de entorno ORACLE_HOME"
    exit 1
fi

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

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_378_ENTITY01_DATGMN-ModificacionTablaMIGPropuestasTerminosAcuerdo.sql
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DDL_378_ENTITY01_DATGMN-ModificacionTablaMIGPropuestasTerminosAcuerdo.sql
   exit 1
fi


echo "Carga tablas MIG..."
echo "MIG_PROPUESTAS_CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_cabeceraDataLoad.ctl log="$log_dir"PROPUESTAS-CABECERA_"$fecha".log bad="$bad_dir"PROPUESTAS-CABECERA_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROPUESTAS-CABECERA.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_CABECERA"
#   exit 1
fi


echo "MIG_PROPUESTAS_TERMINO_ACUERDO"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_terminos_acuerdosDataLoad.ctl log="$log_dir"PROPUESTAS-TERMINOSACUERDO_"$fecha".log bad="$bad_dir"PROPUESTAS-TERMINOSACUERDO_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROPUESTAS-TERMINOSACUERDO.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_TERMINO_ACUERDO"
#   exit 1
fi


echo "MIG_PROPUESTAS_TERMI_OPERAC"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_terminos_acuerdos_operacionesDataLoad.ctl log="$log_dir"TERMINOS-OPERACIONES_"$fecha".log bad="$bad_dir"TERMINOS-OPERACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"TERMINOS-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_TERMI_OPERAC"
#   exit 1
fi


echo "Inicio MIGRAR_PROPUESTAS_CON_EXPEDIENTES.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"MIGRAR_PROPUESTAS_CON_EXPEDIENTES_V3.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"MIGRAR_PROPUESTAS_CON_EXPEDIENTES_V3.sql
   exit 1
fi


echo "Fin CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS_EXP.sh. Revise el fichero de log"
exit 0
