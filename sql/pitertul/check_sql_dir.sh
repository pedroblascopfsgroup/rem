#!/bin/bash +x

if [[ $# -ne 2  && $# -ne 1 ]] ; then
 echo "Uso correcto: $0 <directorio> [-v]"
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

modified_files2="find $1 -name 'D*.sql'"
function SQL_rules() {
	for f in `eval $modified_files2`; do
		check_pitertul_format $f dir 
	done

	if [ -f $BASEDIR/marca_error ] ; then
		rm $BASEDIR/marca_error
		exit 1
	fi
}

########################################################
##### MAIN
########################################################

SQL_rules

echo "Fin del proceso correcto."

exit 0