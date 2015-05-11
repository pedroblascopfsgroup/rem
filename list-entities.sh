#!/bin/bash

function error () {
	echo "ERROR: " $*
	exit 1
}
DSTDIR=$(pwd)

if [ -z "$*" ]; then
	error "Es neceario especificar el directorio base del poyecto rec-common"
fi

SRCPROJECT=$1

if [ ! -d $SRCPROJECT ]; then
	error "$SRCPROJECT: No existe el directorio"
fi

SRCDIR=${SRCPROJECT}/modules/common/main/java

echo "" > entities.list

if [ ! -d $SRCDIR ]; then
	error "$SRCDIR: No existe el directorio"
fi

total=0;

cd $SRCDIR
for f in $(find . -type f -name *.java -print); do
  o="$(cat $f |  grep @Entity)"
  if [ ! -z "$o" ]; then
    total=$(( $total + 1 ))
    echo $f
    echo $f >> $DSTDIR/entities.list
  fi
done
echo "TOTAL=$total"

cd $DSTDIR
echo "" > entities.xml
for e in $(cat entities.list | sed "s/\.java//g" | sed "s/\.//g" | sed "s/\//\./g"  | sed "s/\.es/es/g" | sort); do
  echo "<value>$e</value>" >> entities.xml
done
