#!/bin/bash
$(pwd)/$(dirname $0)/../common/showbanner.sh
echo ""

PROJECT_BASE=$(pwd)/$(dirname $0)
cd $PROJECT_BASE

if [[ -d SQL-SCRIPTS ]]; then
	echo "-------- ATENCIÓN -------------"
	echo "Se van a borrar los scrippts SQL."
	echo "Tras esta operación deberás volver a configurar el proyecto"
	echo -n "¿Quieres continuar? [s|N]: "; read op
	if [[ "x$op" == "xs" || "x$op" == "xS" ]]; then
		echo "$(basename $0): Borrando SQL-SCRIPTS"
		rm -R SQL-SCRIPTS
		if [[ $? -ne 0 ]]; then
			exit 1
		fi
	else
		echo "$(basename $0): Se mantienen los scripts SQL"
	fi
	
fi