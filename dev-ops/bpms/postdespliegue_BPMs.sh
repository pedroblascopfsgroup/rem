#!/bin/bash

codigo_bpm="$1"
esquema="$2"

RUTA=./dev-ops/bpms/

fecha=`date +%Y%m%d`
version_actual=$(cat ${RUTA}versiones-bpms.txt | grep :$codigo_bpm.xml | sort | tail -1 | cut -d':' -f3)
nueva_version=$(echo $(( $version_actual+1 )))
version=$(ls ~/git/recovery/sql/ | grep "[[:digit:]]" | sort | tail -1)

if [ "$0" != "./dev-ops/bpms/$(basename $0)" ]; then
    	echo ""
    	echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    	echo ""
    	echo "    ./dev-ops/bpms/$(basename $0)"
    	echo ""
    exit 1
fi

if [[ "$#" != "2" ]] ; then
	echo ""
	echo "Uso: $0 <codigo_bpm> <cartera>"
	echo ""
	echo "Ejemplo: $0 haya_tramiteCertificacionCargasRevision HAYA01"
	echo ""
	exit 1
fi

if [[ $esquema != "REM" ]] && [[ $esquema != "ALISEDA" ]] && [[ $esquema != "HAYA01" ]] && [[ $esquema != "HAYA02" ]] && [[ $esquema != "HAYA03" ]] && [[ $esquema != "HAYA04" ]] && [[ $esquema != "HAYA05" ]]; then
    	echo ""
    	echo "AUCH!! Las carteras deben ser:"
    	echo ""
    	echo "REM, ALISEDA, HAYA01, HAYA02, HAYA03, HAYA04 y HAYA05"
    	echo ""
    	exit 1
fi

if [ -z $version_actual ] ; then
    	echo ""
    	echo "AUCH!! El codigo bpm no existe!"
    	echo ""
    	exit 1
fi


parsear_sql() 
{

   fecha=`date +%Y%m%d`

   sed s/#CODIGO_BPM#/$codigo_bpm/ ${RUTA}DML_001_ENTITY01_CallTramiteUltimaVersion.sql > ${RUTA}DML
   sed s/#VERSION_ARTEFACTO#/$version/ ${RUTA}DML > ${RUTA}DML2
   sed s/#YYYYMMDD#/$fecha/ ${RUTA}DML2 > ${RUTA}DML_001_ENTITY01_CallTramiteUltimaVersion_$codigo_bpm.sql

   rm ${RUTA}DML
   rm ${RUTA}DML2
}

echo ""
echo "<-- PROCESO CALL_TRAMITE_ULTIMA_VERSION $codigo_bpm -->"
echo ""

echo "FECHA: $fecha"
echo "VERSION ACTUAL: $version_actual"
echo "VERSION NUEVA: $nueva_version"
echo "VERSION ARTEFACTO $version"

echo ""
echo "<-- Actualizamos el $codigo_bpm a la version $nueva_version -->"
echo ""

sed "s|:${codigo_bpm}.xml:${version_actual}|:${codigo_bpm}.xml:${nueva_version}|g" ${RUTA}versiones-bpms.txt > ${RUTA}versiones-bpms-tmp.txt

mv ${RUTA}versiones-bpms-tmp.txt ${RUTA}versiones-bpms.txt
#rm ${RUTA}versiones-bpms-tmp.txt

echo ""
echo "<-- Creamos el DML CALL_TRAMITE_ULTIMA_VERSION del codigo_bpm $codigo_bpm  -->"
echo ""

parsear_sql

echo ""
echo "<-- Comprobamos que exita el directorio postdespliegue -->" 
echo ""

[ "$esquema" == "REM" ] && cartera="rem"
[ "$esquema" == "ALISEDA" ] && cartera="aliseda"
[ "$esquema" == "HAYA01" ] && cartera="sareb"
[ "$esquema" == "HAYA02" ] && cartera="bcc"
[ "$esquema" == "HAYA03" ] && cartera="jaipur"
[ "$esquema" == "HAYA04" ] && cartera="giants"
[ "$esquema" == "HAYA05" ] && cartera="galeon"


if [[ $esquema == "REM" ]] || [[ $esquema == "ALISEDA" ]]; then

	RUTA_DESTINO=./sql/$version/$cartera/postdespliegues
else
	RUTA_DESTINO=./sql/$version/haya/$cartera/postdespliegues
fi

if [ ! -d $RUTA_DESTINO ] ;
then
	echo "No existe el directorio postdespliegue, se procede a crear el directorio"	
	mkdir -p $RUTA_DESTINO
fi

echo ""
echo "<-- Movemos el DML creado al directorio postdespliegues -->"
echo ""

mv ${RUTA}DML_001_ENTITY01_CallTramiteUltimaVersion_$codigo_bpm.sql $RUTA_DESTINO


echo ""
echo "<-- FIN PROCESO CALL_TRAMITE_ULTIMA_VERSION $codigo_bpm -->"
echo ""



