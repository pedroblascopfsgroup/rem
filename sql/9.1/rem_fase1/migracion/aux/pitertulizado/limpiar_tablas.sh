#! /bin/bash

var1=$(pwd)
echo "Directorio actual: "$var1

cd ../../../../../../

var1=$(pwd)
echo "Directorio recovery: "$var1

nohup ./sql/tool/package-scripts-from-tag-and-folder.sh 9.1.15-bk REM migracion/aux/pitertulizado

cd sql/tool/tmp/package/DML/

var1=$(pwd)
echo "Directorio pitertul: "$var1

./DML-scripts.sh $1 $1

