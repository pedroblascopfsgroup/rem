#!/bin/bash

. ./sql/pitertul/commons/configuration.sh

SEPARADOR="####################################################################################################################"
if [[ "$1" == "-h" ]] ; then
	echo $SEPARADOR
	echo "Uso:   ./sql/pitertul/$(basename $0) <tag_inicial> [-out-pv:y|n] [-out-incidencias:y|n] [-out-migracion:y|n]"
	echo "               parámetro -out-pv - posibles valores: y (incluye procs y vistas), n (no incluye procs y vistas, valor por defecto)"
	echo "               parámetro -out-incidencias - posibles valores: y (incluye carpetas incidencias_produccion), n (no incluye incidencias_produccion, valor por defecto)"
	echo "               parámetro -out-migracion - posibles valores: y (incluye carpetas migracion), n (no incluye migracion, valor por defecto)"
	echo "Ayuda: ./sql/pitertul/$(basename $0) -h"
	echo $SEPARADOR
	exit 0
fi

TAG_FINAL=`git log --pretty=format:"%h" -n1`
TAG_INICIAL=$TAG_INICIAL
TAG_INICIAL=$1

RED='\033[0;31m'
NC='\033[0m' # No Color
TITULO="Busqueda de ficheros sql comiteados desde el tag ${RED}$TAG_INICIAL ${NC}para los que no se ha modificado el campo FECHA_CREACION"

clear

function comprobacionDirectorio() {
	if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
	    echo $SEPARADOR
	    echo "No me ejecutes desde aquí, por favor... sal a la raiz del repositorio RECOVERY y ejecútame como:"
	    echo ""
	    echo "    ./sql/pitertul/$(basename $0)"
	    echo ""
	    echo $SEPARADOR
	    exit 1
	fi
} 
comprobacionDirectorio

if [[ "x$TAG_INICIAL" == "x" ]] ; then
	echo $SEPARADOR
	echo -e $TITULO
	echo ""
	echo "Uso:   ./sql/pitertul/$(basename $0) <tag_inicial> [-out-pv:y|n] [-out-incidencias:y|n] [-out-migracion:y|n]"
	echo ""
	echo "El parámetro <from-tag> es obligatorio."
	echo $SEPARADOR
	exit 1
fi

if [[ `git tag -l | grep $TAG_INICIAL | wc -l` -ne 1 ]] ; then
	echo $SEPARADOR
	echo -e $TITULO
	echo ""
	echo -e "El tag ${RED}$TAG_INICIAL ${NC}no existe o existe más de un tag que cumple esta especificación."
	echo ""
	echo $SEPARADOR
	exit 1
fi

echo $SEPARADOR
echo -e $TITULO


OUTPUT_PROC_Y_VISTAS=`findInputParam out-pv $* | tr [:upper:] [:lower:]` # y (lo incluye) | n (no lo incluye, valor por defecto) 
if [[ "$OUTPUT_PROC_Y_VISTAS" == "" ]] ; then OUTPUT_PROC_Y_VISTAS=n ; fi

OUTPUT_INCIDENCIAS=`findInputParam out-incidencias $* | tr [:upper:] [:lower:]` # y (lo incluye) | n (no lo incluye, valor por defecto) 
if [[ "$OUTPUT_INCIDENCIAS" == "" ]] ; then OUTPUT_INCIDENCIAS=n ; fi

OUTPUT_MIGRACION=`findInputParam out-migracion $* | tr [:upper:] [:lower:]` # y (lo incluye) | n (no lo incluye, valor por defecto) 
if [[ "$OUTPUT_MIGRACION" == "" ]] ; then OUTPUT_MIGRACION=n ; fi

if [[ "$OUTPUT_PROC_Y_VISTAS" == "n" ]] ; then
	echo " (excluyendo procs y vistas)"
else
	echo " (incluyendo procs y vistas)"
fi
if [[ "$OUTPUT_INCIDENCIAS" == "n" ]] ; then
	echo " (excluyendo scripts contenidos en las carpetas incidencias_produccion)"
else
	echo " (incluyendo scripts contenidos en las carpetas incidencias_produccion)"
fi
if [[ "$OUTPUT_MIGRACION" == "n" ]] ; then
	echo " (excluyendo scripts contenidos en las carpetas migracion)"
else
	echo " (incluyendo scripts contenidos en las carpetas migracion)"
fi
echo $SEPARADOR

ficheros=`git diff $TAG_INICIAL $TAG_FINAL  --name-status --diff-filter=M --no-merges | grep "^M.*sql.*sql$" | cut -f2`
ok=0
for fichero in $ficheros ; do
	ignorar_fichero="NO"
	if [[ "$OUTPUT_PROC_Y_VISTAS" == "n" ]] ; then
		if [[ ${fichero} =~ ^sql\/.*DDL_[0-9]+_[^_]+_(SP|MV|VI)_[^\.]+\.sql$ ]] ; then
			#echo "--- Ignoramos fichero: $fichero"
			ignorar_fichero="SI"
		fi
	fi
	if [[ "$OUTPUT_INCIDENCIAS" == "n" ]] ; then
		if [[ ${fichero} =~ ^sql\/.*incidencias_produccion.*\.sql ]] ; then
			#echo "--- Ignoramos fichero: $fichero"
			ignorar_fichero="SI"
		fi
	fi
	if [[ "$OUTPUT_MIGRACION" == "n" ]] ; then
		if [[ ${fichero} =~ ^sql\/.*migracion.*\.sql ]] ; then
			#echo "--- Ignoramos fichero: $fichero"
			ignorar_fichero="SI"
		fi
	fi
	if [[ "$ignorar_fichero" == "NO" ]] ; then
		lastCommit=`git log --pretty=format:"%h" $fichero | head -1`
		borrados=`git show $lastCommit $fichero | grep "\---## FECHA_CREACION" | wc -l`
		inserciones=`git show $lastCommit $fichero | grep "+--## FECHA_CREACION" | wc -l`
		if [[ $(( inserciones+borrados )) -eq 0 ]] ; then 
			autor=`git log --format="%an" -n1 $fichero`
		    echo -e "Fichero: $fichero - commit: $lastCommit - ${RED}autor: $autor ${NC}--> FECHA_CREACION no modificada"
		    ok=1
		fi
	fi
done

exit $ok
