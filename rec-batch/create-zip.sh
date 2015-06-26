#!/bin/bash

if [ ! -d target ]; then
	echo "No existe el directorio target, ¿has construido el proyecto?"
	exit 1
fi

if [ "x$1" != "x" ]; then
	VERSION=$1	
else
	echo "************************"
	echo "ERROR"
	echo "VERSION is mandatory"
	echo "Usage: $0 <version>"
	echo "************************"
	exit 1
fi

rm -Rf target/batch

mkdir -p target/batch

cd target/batch
JAR="../rec-batch-$VERSION.jar"
if [ -f $JAR ]; then
	cp $JAR .
else
	echo "************************"
	echo "ERROR"
	echo "$JAR: not found"
	echo "************************"
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
rm -Rf generated-files
mkdir -p generated-files
zip -q -r generated-files/batch-$VERSION.zip batch
