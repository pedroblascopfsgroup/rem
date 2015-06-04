#!/bin/bash

if [ ! -d target ]; then
	echo "No existe el directorio target, ¿has construido el proyecto?"
	exit 1
fi

if [ "x$1" != "x" ]; then
	VERSION=$1	
else
	VERSION=DESCONOCIDA
fi

rm -Rf target/batch

mkdir -p target/batch

cd target/batch

cp -Rf ../alternateLocation/* .

cp $(find .. -name rec-batch*.jar | grep -i sources) .

rm -f sql/sqlRecobro*

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
pwd
rm -Rf generated-files
mkdir -p generated-files
zip -r generated-files/batch-$VERSION.zip batch
