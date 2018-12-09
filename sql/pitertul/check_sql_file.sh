#!/bin/bash +x

if [[ $# -ne 2  && $# -ne 1 ]] ; then
 echo "Uso correcto: $0 <fichero.sql> [-v]"
 exit 1
fi

verbose="NO"
if [[ "$#" == "2" ]]; then
	if [[ "$2" == "-v" ]]; then
		verbose="SI"
	fi
fi

BASEDIR=$(dirname $0)

. $BASEDIR/setCheck.sh 

nombre_fichero=$1

########################################################
##### MAIN
########################################################
check_pitertul_format $nombre_fichero fichero

echo "Fin del proceso correcto."

exit 0