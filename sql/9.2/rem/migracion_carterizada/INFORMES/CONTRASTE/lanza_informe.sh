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
DIR_CONTRASTE=INFORMES/CONTRASTE 
DIR_REPORTS=${DIR_CONTRASTE}/REPORTS
DIR_LOGS=${DIR_CONTRASTE}/LOGS
DIR_SP=${DIR_CONTRASTE}/SP
DIR_SALIDA=${DIR_CONTRASTE}/OUTPUT
DIR_CSV2EXCEL=INFORMES/Csv2Excel

SP=SP_MIG_GEN_INFORME_CONTRASTE.sql
CSV=REPORT-informe_contraste.csv
REPORT_SQL=REPORT-informe_contraste.sql

echo "########################################################"
echo "#####    INFORME DE CONTRASTE"
echo "########################################################"
echo " "

#####################################
#### COMPILAR SP
#####################################
echo "[INFO] [1/5] Preparando el proceso..."
${ORACLE_HOME}/bin/sqlplus REM01/$2 @${DIR_SP}/${SP} > ${DIR_LOGS}/002_$1_compilar_sp.log
if [ $? != 0 ]; then 
    echo -e "\n======>>> Error compilando @SP_MIG_GEN_INFORME_CONTRASTE.sql"
    exit 1
fi

#####################################
#### TRUNCATE TABLA INFORME
#####################################
echo "[INFO] [2/5] Eliminando volumetrías del informe anterior..."
${ORACLE_HOME}/bin/sqlplus "REM01/$2" << EOF > ${DIR_LOGS}/003_$1_limpiar_registros_antiguos.log
TRUNCATE TABLE REM01.MIG2_INFORME_CONTRASTE;
COMMIT;
EXIT
EOF

if [ $? != 0 ] ; then 
   echo -e "\n======>>> Error eliminando volumetrías del informe anterior."
   exit 1
fi

#####################################
#### INSERTAR VOLUMETRÍAS DAT
#####################################
echo "[INFO] [3/5] Generando las volumetrías de los ficheros de entrada..."
fichero="INFORMES/CONTRASTE/volumetrias_dat.list"
wc -l CTLs_DATs/DATs/*.dat | head --lines=-1 | sed 's/CTLs_DATs\/DATs\///g ; s/.dat//g' | sed -e 's/^[ \t]*//' > $fichero

while read line
do
  registros=$(echo "$line" | cut -d ' ' -f1)
  interfaz=$(echo "$line" | cut -d ' ' -f2)
  echo -e "\t\t - Volumetrías de la interfaz: $interfaz ($registros)"
  ${ORACLE_HOME}/bin/sqlplus "REM01/$2" << EOF > ${DIR_LOGS}/004_$1_volumetrias_dat.log
  INSERT INTO REM01.MIG2_INFORME_CONTRASTE (INTERFAZ, REGISTROS_ENTRADA) VALUES ('$interfaz', $registros);
  COMMIT;
  EXIT
EOF

  if [ $? != 0 ] ; then 
     echo -e "\n======>>> Error en @$line"
     exit 1
  fi

done < "$fichero"

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
echo -e "[INFO] [4/5] Generando las volumetrías de las validaciones..."
${ORACLE_HOME}/bin/sqlplus "REM01/$2" << ETIQUETA > ${DIR_LOGS}/005_$1_lanzar_sp.log
  EXECUTE SP_MIG_GEN_INFORME_CONTRASTE('$USUARIO_MIGRACION');
ETIQUETA

if [ $? != 0 ] ; then 
   echo -e "\n======>>> Error en @SP_MIG_GEN_INFORME_CONTRASTE.sql"
   exit 1
fi

#####################################
#### GENERANDO CSV
#####################################
echo -e "[INFO] [5/5] Generando informe..."
exit | ${ORACLE_HOME}/bin/sqlplus "REM01/$2" @${DIR_REPORTS}/${REPORT_SQL} > ${DIR_LOGS}/006_$1_generar_csv.log
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