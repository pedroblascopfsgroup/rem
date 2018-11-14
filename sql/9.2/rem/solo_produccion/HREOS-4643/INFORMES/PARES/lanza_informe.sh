#!/bin/bash
export NLS_LANG=SPANISH_SPAIN.UTF8

if [ "$#" -ne 2 ]; then
   echo "[INFO] Parametros: <entidad> [SAREB, CAJAMAR, BANKIA]"
   echo "[INFO] Parametros: <cadena_conexion> <pass@host:puerto/ORACLE_SID>"
   exit 1
fi

if [[ "$1" != "SAREB" ]] && [[ "$1" != "CAJAMAR" ]] && [[ "$1" != "BANKIA" ]]; then
    echo "[INFO] Entidad no válida."
    echo "[INFO] Valores aceptados [SAREB, CAJAMAR, BANKIA]"
    exit 1
fi

#Variables
DIR_PARES=INFORMES/PARES 
DIR_REPORTS=${DIR_PARES}/REPORTS
DIR_LOGS=${DIR_PARES}/LOGS
DIR_SP=${DIR_PARES}/SP
DIR_SALIDA=${DIR_PARES}/OUTPUT


TXT=PARES_OFERTAS_UVEM_REM.txt
TXT1=PARES_ACTIVOS_UVEM_REM.txt
REPORT_SQL=DML_3000_REM_SPOOL_GEN_FICHERO_PARES_COMERCIAL.sql
REPORT_SQL1=DML_3001_REM_SPOOL_GEN_FICHERO_PARES_STOCK.sql

echo "########################################################"
echo "#####    FICHEROS DE PARES"
echo "########################################################"
echo " "


#####################################
#### GENERANDO FICHERO PARES OFERTAS
#####################################
echo -e "[INFO] [1/2] Generando informe pares OFERTAS..."
  ${ORACLE_HOME}/bin/sqlplus "REM01/$2" @${DIR_REPORTS}/${REPORT_SQL} > ${DIR_LOGS}/001_$1_generar_fichero_pares_ofertas.log
if [ ! -f ${DIR_SALIDA}/${TXT} ] ; then
  echo -e "\n======>>> Error no se ha generado el txt ${TXT}"
  exit 1
fi


#####################################
#### GENERANDO FICHERO PARES STOCK
#####################################
echo -e "[INFO] [2/2] Generando informe pares STOCK..."
  ${ORACLE_HOME}/bin/sqlplus "REM01/$2" @${DIR_REPORTS}/${REPORT_SQL1} > ${DIR_LOGS}/002_$1_fichero_pares_stock_activos.log
if [ ! -f ${DIR_SALIDA}/${TXT1} ] ; then
  echo -e "\n======>>> Error no se ha generado el txt ${TXT1}"
  exit 1
fi


exit 0