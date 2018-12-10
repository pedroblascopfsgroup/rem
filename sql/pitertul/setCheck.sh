#!/bin/bash +x

BASEDIR=$(dirname $0)

function escribe_error() {
	if [[ $verbose == "SI" ]]; then
		echo ""
		echo "**********************************************************"
		echo "Fichero afectado: $1"
		echo "Problema: $2"
		echo "**********************************************************"
		echo "Ocurrencias del error:"
		echo "----------------------------------------------------------"
		echo "$3"
		echo "**********************************************************"
		echo "Solución: Detecte y corrija esta expresión: $4"
		echo "**********************************************************"
		echo ""
	else
		echo "Error en fichero $1: $2"
	fi
}


function check_pitertul_format() {
	fichero=$1
    modo=$2

	error=0

	salida=`grep -E -i -f $BASEDIR/expresion_tablas.txt $fichero`
	if [[ "x" != "x$salida" ]]; then
		escribe_error "$f" "Tablas sin prefijo correcto" "$salida" "`cat $BASEDIR/expresion_tablas.txt`"
		error=1
	fi

	salida=`grep -E -i -f $BASEDIR/expresion_tablas2.txt $fichero`	
	if [[ "x" != "x$salida" ]]; then
		escribe_error "$f" "Tablas de join por comas sin prefijo correcto" "$salida" "`cat $BASEDIR/expresion_tablas2.txt`"
		error=1
	fi

	salida=`grep -E -i -f $BASEDIR/expresion_secuencias.txt $fichero`
	if [[ "x" != "x$salida" ]]; then
		escribe_error "$f" "Secuencias sin prefijo correcto" "$salida" "`cat $BASEDIR/expresion_secuencias.txt`"
		error=1
	fi

	if [[ "$error" == "1" ]] && [[ "$modo" == "fichero" ]] ; then
		exit 1
	fi

	if [[ "$error" == "1" ]] && [[ "$modo" == "dir" ]] ; then
		touch $BASEDIR/marca_error
	fi
}
