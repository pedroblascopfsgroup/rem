#!/bin/bash

##
# Escribe un mensaje de auda o de ERROR, si se le pasa alg como argumento
# param $1 Mensaje de error
function print_help_or_error () {
	echo "******************************************************"
	if [ "x$1" != "x" ]; then
		echo "ERROR"
		echo $1
	fi
	echo "Usage: $0 <version> [directorio despliegue (opcional)]"
	echo "******************************************************"
}

if [ ! -d target ]; then
	echo "No existe el directorio target, ¿has construido el proyecto?"
	exit 1
fi

if [ "$1" == "help" ] || [ "$1" == "HELP" ] || [ "$1" == "-h" ] || [ "$1" == "-H" ] || [ "$1" == "--help" ]; then
		print_help_or_error
		exit 0
elif [ "x$1" != "x" ]; then
	VERSION=$1	
else
	print_help_or_error "VERSION is mandatory"
	exit 1
fi

if [ "x$2" != "x" ]; then
	echo "Has elegido desplegar el batch en $2."
	if [ -d "$2" ]; then
		echo "El directorio existe, se sustituirá todo el contenido (eliminar contenido antiguo)"
	else
		echo "El directorio no existe, se va a crear"
	fi
	echo -n "¿Es correcto? (s/N) "; read in

	if [ "$in" != "S" ] && [ "$in" != "s" ]; then
		echo "Abortando. Teclea 'S' para continuar"
		exit 1
	fi

fi

rm -Rf target/batch

mkdir -p target/batch

cd target/batch
JAR="../rec-batch-$VERSION.jar"
if [ -f $JAR ]; then
	cp $JAR rec-batch.jar
else
	echo "ERROR target/$(basename $JAR): not found"
	exit 1
fi

cp -Rf ../alternateLocation/* .
chmod +x run.sh


rm -f sql/sqlRecobro*

if [ ! -d properties ]; then
	mkdir properties
fi
cp -R ../../src/main/resources/properties/* properties/

rm -Rf optionalConfiguration/jobs/recobro/
mkdir -p optionalConfiguration/jobs/recobro/
cp -R ../../src/main/resources/jobs/recobro/* optionalConfiguration/jobs/recobro/

rm -Rf optionalConfiguration/jobs/antecedentes/
mkdir -p optionalConfiguration/jobs/antecedentes/
cp -R ../..//src/main/resources/jobs/antecedentes/* optionalConfiguration/jobs/antecedentes/

rm -Rf optionalConfiguration/config/
mkdir -p optionalConfiguration/config/
cp -R ../../src/main/resources/config/* optionalConfiguration/config/

cd ..
if [ "x$2" == "x" ]; then
	echo -n "Creando el ZIP"
	rm -Rf generated-files
	mkdir -p generated-files
	zip -q -r generated-files/batch-$VERSION.zip batch
	echo " .. OK"
else
	echo -n "Desplegando en $2"
	rm -Rf $2
	mkdir -p $2
	cp -Rf batch/* $2
	echo " .. OK"
fi
