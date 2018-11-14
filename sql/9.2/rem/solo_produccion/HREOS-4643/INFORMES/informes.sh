#!/bin/bash
if [ "$#" -ne 3 ]; then
   echo "[INFO] Parametros: <entidad> [SAREB, CAJAMAR, BANKIA]"
   echo "[INFO] Parametros: <informe> [CONTRASTE, KPIS, PARES]"
   echo "[INFO] Parametros: <cadena_conexion> <pass@host:puerto/ORACLE_SID>"
   exit 1
fi

if [[ "$1" != "SAREB" ]] && [[ "$1" != "CAJAMAR" ]] && [[ "$1" != "BANKIA" ]];  then
    echo "[INFO] Entidad no válida."
    echo "[INFO] Valores aceptados [SAREB, CAJAMAR, BANKIA]"
    exit 1
fi

if [[ "$2" != "CONTRASTE" ]] && [[ "$2" != "KPIS" ]] && [[ "$2" != "PARES" ]];  then
    echo "[INFO] Tipo de informe no válido."
    echo "[INFO] Valores aceptados [CONTRASTE, KPIS, PARES]"
    exit 1
fi

DIR_SALIDA=INFORMES/$2/OUTPUT
DIR_LOGS=INFORMES/$2/LOGS

LOG_COMPLETO="001_$1_informe.log"
FECHA=`date +%Y-%m-%d_%H:%M:%S`

echo "[INFO] PROCESO DE GENERACIÓN DE INFORMES..." 
echo -e "[INFO] Entidad: $1"
echo -e "[INFO] Tipo de informe: $2"
echo -e "[INFO] Cadena de conexion: $3" 
echo -e "[INFO] Fecha: ${FECHA}"
echo -e " "

echo "[INFO] Generando informe..."
./INFORMES/$2/lanza_informe.sh $1 $3 > ${DIR_LOGS}/${LOG_COMPLETO}
if [ $? != 0 ] ; then 
   echo -e "\n======>>> Error en la generacion del informe"
   exit 1
fi

echo -e "[INFO] Informe de tipo $2 generado en el directorio ${DIR_SALIDA}" > ${DIR_LOGS}/${LOG_COMPLETO}

exit 0