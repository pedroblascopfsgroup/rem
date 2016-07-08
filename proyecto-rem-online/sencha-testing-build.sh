#!/bin/bash

echo "Este script construye la aplicación sencha y la deja lista para empaquetar en modo desarrollo."
echo ""

### Directorios INPUT y OUTPUT
CURRENT=$(pwd)

cd $(pwd)/$(dirname $0)/sencha-app
if [[ $? -eq 0 ]]; then
	INPUT=$(pwd)
else
	echo "sencha-app: no se encuentra el directorio de origen"
	exit
fi
cd $CURRENT

OUTPUT=$(pwd)/$(dirname $0)/src/web/js/plugin/rem
mkdir -p $OUTPUT

cd $CURRENT

echo "input  = $INPUT"
echo "output = $OUTPUT"
echo ""

# Limpiamos OUTPUT
echo "Borrando 'output'"
rm -Rf $OUTPUT/*

# Compilamos y copiamos
cd $INPUT
rm -Rf $INPUT/build
sencha app build testing
cp -R $INPUT/build/testing/HreRem/. $OUTPUT
echo "Copiado de $INPUT a $OUTPUT"

if [[ -f $(pwd)/src/web/js/plugin/rem/index.jsp ]]; then
	echo "EL BUILD HA FALLADO: No se ha generado el código esperado"
	exit 1
fi