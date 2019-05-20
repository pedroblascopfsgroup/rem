#!/bin/bash

DIR_OTROS=../OTROS
DIR_REPORTS=${DIR_OTROS}/REPORTS
DIR_LOGS=${DIR_OTROS}/LOGS
DIR_SALIDA=${DIR_OTROS}/OUTPUT
DIR_CSV2EXCEL=../Csv2Excel

CSV1=prueba1.csv
CSV2=prueba2.csv
REPORT_SQL=INFORME_OTROS.sql


#####################################
#### GENERANDO CSV
#####################################
#echo -e "[INFO] Generando informe..."
#exit | ${ORACLE_HOME}/bin/sqlplus "REM01/$2" @${DIR_REPORTS}/${REPORT_SQL} > ${DIR_LOGS}/006_$1_generar_csv.log
#if [ ! -f ${DIR_SALIDA}/${CSV} ] ; then
#  echo -e "\n======>>> Error no se ha generado el csv ${CSV}"
#  exit 1
#fi

#####################################
#### GENERANDO EXCEL
#####################################
if [ "${JAVA_HOME}" == "" ] ; then
  echo -e "\n======>>> Error no se ha encontrado la variable de entorno JAVA_HOME"
  exit 1
fi

#${JAVA_HOME}/bin/java -jar ${DIR_CSV2EXCEL}/Csv2Excel.jar ${DIR_SALIDA}/${CSV}:
#Csv2Excel -t xlsx -o myoutfile -d \| -e UTF-8 -i mysheet1.txt:mysheet2.txt:mysheet3.txt
${JAVA_HOME}/bin/java -jar ${DIR_CSV2EXCEL}/Csv2Excel.jar ${DIR_SALIDA}/${CSV1}:${DIR_SALIDA}/${CSV2}

exit 0

