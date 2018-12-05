#!/bin/bash +x
set -e # Para errores

function createDirectory() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
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

function header() {
	TEXTO=$1
	echo ""
	echo "**************************************"
	echo -e $TEXTO
	echo "**************************************"
	echo ""
}

function procesos-descarga-etls() {
  credentials=$1 # user:pwd
  properties_file=$2
  directorio_salida=$3
  
  header "Llamando a... ${FUNCNAME[0]} ($credentials) ($properties_file) ($directorio_salida)"
  createDirectory $directorio_salida

  resultado_file=.propiedades
  header "Procesando fichero de properties $properties_file en $directorio_salida"
  num_errores=`sed s/#.*//g $properties_file | sed '/^\s*$/d' | grep -v "\w*:\w*:[0-9]*\.[0-9]*" | wc -l`
  if [ $num_errores -gt 0 ]; then
    header "Error!!! Existen líneas mal formadas en el fichero $properties_file"
  	sed s/#.*//g $properties_file | sed '/^\s*$/d' | grep -v "\w*:\w*:[0-9]*\.[0-9]*"
  	echo "*******************************************************"
  	exit 1;
  fi

  echo "Fichero correcto: $resultado_file"
  sed s/#.*//g $properties_file | sed '/^\s*$/d' > $resultado_file
  while IFS=":" read -r repo etl version; do
    version=`echo "${version}" | sed -e "s/ //g"` 
    etl=`echo "${etl}" | sed -e "s/ //g"` 
    repo=`echo "${repo}" | sed -e "s/ //g"` 
    URL="http://nexus.pfsgroup.es/nexus/repository/etls/$repo/build/$etl/$version/$etl-$version.zip"
  	echo "Downloading ETL [$URL]"
    curl -X GET --fail -u $credentials -o $directorio_salida/$etl-$version.zip $URL
    RESPUESTA=$?
    if [ $RESPUESTA -ne 0 ]; then exit $RESPUESTA; fi
  done < $resultado_file
  rm $resultado_file;
}


function procesos-limpia-etls() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
	directorio=$1

	if [ ! -d $directorio ]; then
		header "ERROR: Para realizar una limpieza de los ZIP, el directorio $directorio debe tener todos los ETLs descargados!!!! "
		exit 1;
	fi

	header "Limpieza de los ETLs (direcotorios SRC, ...) en [$directorio]"
	cd $directorio
	for etl in `ls *.zip`
	do 
		unzip -o $etl lib/* -d paquete || ( e=$? && if [ $e -ne 11 ]; then exit $e; fi )
		zip $etl -d **/src/* **/items/* lib/* jobInfo.properties **/*.bat || ( e=$? && if [ $e -ne 12 ]; then exit $e; fi )
	done
	cd paquete 
	zip -r ../lib.zip lib
	cd $CURRENT_DIR
	rm -Rf $directorio/paquete
}

function empaqueta() {
	echo "Llamando a... ${FUNCNAME[0]}"

	header "Empaquetando"
	procesos-descarga-etls "${UP_NEXUS}" batch-shell/config/rem/versiones.properties $WORKING_DIR/etls

	createDirectory $WORKING_DIR/shells
	procesos-limpia-etls $WORKING_DIR/etls

	echo "Copiado de shells..."
	cp -r batch-shell/dist/shells/rem/* $WORKING_DIR/shells
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

dir_salida=`findInputParam out-dir $*`
entorno=`findInputParam entorno $*`
UP_NEXUS=`findInputParam UPnexus $*`

if [ [ "$dir_salida" == "" ] || [ "$entorno" == "" ]; then
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]:valor"
	echo "  UPnexus : usuario:password para conectarse a nexus"
	echo "  out-dir : directorio de salida del empaquetado"
	echo "  entorno : producto | pro | pre | inte | val"
	exit 1
fi

BASEDIR=$(dirname "$0")
CURRENT_DIR=$(pwd)
COMPONENTE=procesos
PACKAGE_DIR=$CURRENT_DIR/.package
WORKING_DIR=$PACKAGE_DIR/$COMPONENTE
OUPUT_FILE=$CURRENT_DIR/$dir_salida/$COMPONENTE.zip

createDirectory $WORKING_DIR
createDirectory $dir_salida n
rm -rf $OUPUT_FILE

empaqueta
preparaConfigEntorno

echo "Generando empaquetado... $OUPUT_FILE"
cp $BASEDIR/deploy-$COMPONENTE.sh $PACKAGE_DIR
cd $PACKAGE_DIR
zip -r $OUPUT_FILE $COMPONENTE deploy-$COMPONENTE.sh

exit 0;