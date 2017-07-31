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
DIR_KPIS=INFORMES/KPIS 
DIR_REPORTS=${DIR_KPIS}/REPORTS
DIR_LOGS=${DIR_KPIS}/LOGS
DIR_SP=${DIR_KPIS}/SP
DIR_SALIDA=${DIR_KPIS}/OUTPUT
DIR_CSV2EXCEL=INFORMES/Csv2Excel

SP=SP_MIG_GEN_INFORME_KPIS.sql
CSV=REPORT-informe_KPIS.csv
REPORT_SQL=REPORT-informe_KPIS.sql

echo "########################################################"
echo "#####    INFORME DE KPIS"
echo "########################################################"
echo " "

#####################################
#### COMPILAR SP
#####################################
echo "[INFO] [1/3] Preparando el proceso..."
${ORACLE_HOME}/bin/sqlplus REM01/$2 @${DIR_SP}/${SP} > ${DIR_LOGS}/001_$1_compilar_sp.log
if [ $? != 0 ]; then 
    echo -e "\n======>>> Error compilando @SP_MIG_GEN_INFORME_KPIS.sql"
    exit 1
fi

#####################################
#### OBTENER USUARIOCREAR
#####################################
OUTPUT=$($ORACLE_HOME/bin/sqlplus -S REM01/$2 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT USUARIOCREAR FROM REM01.MIG2_USUARIOCREAR_CARTERIZADO WHERE UPPER(USUARIOCREAR) LIKE UPPER('%$1%');
/
EOF
)
USUARIO_MIGRACION=$(echo $OUTPUT | awk '{ print $1 }')

#####################################
#### LANZAR SP
#####################################
echo -e "[INFO] [2/3] Generando las volumetrías de las validaciones..."
${ORACLE_HOME}/bin/sqlplus "REM01/$2" << ETIQUETA > ${DIR_LOGS}/002_$1_lanzar_sp.log
  EXECUTE SP_MIG_GEN_INFORME_KPIS('$USUARIO_MIGRACION');
ETIQUETA

if [ $? != 0 ] ; then 
   echo -e "\n======>>> Error en @SP_MIG_GEN_INFORME_KPIS.sql"
   exit 1
fi

#####################################
#### GENERANDO CSV
#####################################
echo -e "[INFO] [3/3] Generando informe..."
exit | ${ORACLE_HOME}/bin/sqlplus "REM01/$2" @${DIR_REPORTS}/${REPORT_SQL} > ${DIR_LOGS}/003_$1_generar_csv.log
if [ ! -f ${DIR_SALIDA}/${CSV} ] ; then
  echo -e "\n======>>> Error no se ha generado el csv ${CSV}"
  exit 1
fi

#####################################
#### GENERANDO EXCEL
#####################################
if [ "${JAVA_HOME}" == "" ] ; then
  echo -e "\n======>>> Error no se ha encontrado la variable de entorno JAVA_HOME"
  exit 1
fi

${JAVA_HOME}/bin/java -jar ${DIR_CSV2EXCEL}/Csv2Excel.jar ${DIR_SALIDA}/${CSV}

exit 0