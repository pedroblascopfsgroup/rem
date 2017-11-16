#!/bin/bash +x
set -e # Para errores

function createDirectory() {
	echo "Llamando a... ${FUNCNAME[0]} ($1) ($2)"
	if [ "$2" != "n" ] && [ -d $1 ]; then
		rm -rf $1
	fi
	mkdir -p $1
}

function findInputParam() {
    SEARCH_STRING="-$1:"
    REGEX_SEARCH_STRING="$SEARCH_STRING*"
    PARAMS=$*
    for var in ${PARAMS}
    do
        if [[ $var = ${REGEX_SEARCH_STRING} ]]; then
            echo $var | sed "s/$SEARCH_STRING//g"
            return
        fi
    done
}

function descarga-artefacto() {
	credentials=$1 # user:pwd
	artefacto=$2 #groupId:artifact:version
	directorio_salida=$3

	echo "Llamando a... ${FUNCNAME[0]} ($credentials) ($artefacto) ($directorio_salida)"
	createDirectory $directorio_salida n

	groupId="$(echo $artefacto | cut -d':' -f1 | tr '.' '/' | sed -e 's/ //g')"
	artifactId="$(echo $artefacto | cut -d':' -f2 | sed -e 's/ //g')"
	tipo="$(echo $artefacto | cut -d':' -f3 | sed -e 's/ //g')"
	version="$(echo $artefacto | cut -d':' -f4 | sed -e 's/ //g')"
	URL="http://nexus.pfsgroup.es/nexus/service/local/repo_groups/public/content/$groupId/$artifactId/$version/$artifactId-$version.$tipo"
	echo "Downloading ETL [$URL]"
	curl -X GET --fail -u $credentials -o $directorio_salida/$artifactId-$version.$tipo $URL
	RESPUESTA=$?
	if [ $RESPUESTA -ne 0 ]; then exit $RESPUESTA; fi
}

function generaZipBATCH() {
	echo "Llamando a... ${FUNCNAME[0]}"
	echo "batch.version=${version}
	batch.buildDate=$(date)" > ./rec-batch/target/alternateLocation/version.properties

	cd rec-batch
	./create-zip.sh ${version}
	cd $CURRENT_DIR
}

function empaquetaBATCH() {
	echo "Llamando a... ${FUNCNAME[0]}"

	createDirectory $WORKING_DIR/jar

	cp rec-batch/scripts/batch-startup/checkBatch.sh $WORKING_DIR
	cp rec-batch/scripts/batch-startup/startBatch.sh $WORKING_DIR
	cp rec-batch/scripts/batch-startup/stopBatch.sh $WORKING_DIR
	cp rec-batch/target/generated-files/batch-${version}.zip $WORKING_DIR
	cp batch-shell/target/batch-shell.jar $WORKING_DIR/jar

}

function preparaConfigEntorno() {
	echo "Llamando a... ${FUNCNAME[0]}"
	ficheroACopiar=$BASEDIR/config/$entorno

	if [ -f $ficheroACopiar ]; then
		cp $ficheroACopiar $WORKING_DIR/$COMPONENTE.cnf
	else
		echo "ERROR: No existe el fichero de configuración de ENTORNO $ficheroACopiar"
		exit 1
	fi
}

version=`findInputParam version $*`
dir_salida=`findInputParam out-dir $*`
entorno=`findInputParam entorno $*`

if [ "$version" == "" ] || [ "$out-dir" == "" ] || [ "$entorno" == "" ]; then
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]:valor"
	echo "  version : versión para empaquetar"
	echo "  out-dir : directorio de salida del empaquetado"
	echo "  entorno : producto | pro | pre | inte | val"
	exit 1
fi

BASEDIR=$(dirname "$0")
CURRENT_DIR=$(pwd)
COMPONENTE=spring-batch
PACKAGE_DIR=$CURRENT_DIR/.package
WORKING_DIR=$PACKAGE_DIR/$COMPONENTE
OUPUT_FILE=$CURRENT_DIR/$dir_salida/$COMPONENTE.zip

createDirectory $WORKING_DIR
createDirectory $dir_salida n
rm -rf $OUPUT_FILE

generaZipBATCH
preparaConfigEntorno

cd $CURRENT_DIR
empaquetaBATCH
cd $CURRENT_DIR

echo "Generando empaquetado... $OUPUT_FILE"
cp $BASEDIR/deploy-$COMPONENTE.sh $PACKAGE_DIR
cd $PACKAGE_DIR
zip -r $OUPUT_FILE $COMPONENTE deploy-$COMPONENTE.sh

exit 0;