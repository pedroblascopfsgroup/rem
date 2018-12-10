#!/bin/bash +x

function uso_correcto() {
	echo "Uso correcto: $0 <lista-ficheros.txt> [-v] [-i <lista-ficheros-ignorar.txt>]"
 	exit 1	
}

if [[ $# -ne 4  && $# -ne 3  && $# -ne 2  && $# -ne 1 ]] ; then
   uso_correcto
fi

verbose="NO"
if [[ "$#" == "2" ]]; then
	if [[ "$2" == "-v" ]]; then
		verbose="SI"
	else
		uso_correcto
	fi
fi

if [[ "$#" == "3" ]]; then
	if [[ "$2" == "-i" ]]; then
		fichero_ignorar="$3"
	else
		uso_correcto
	fi
fi

if [[ "$#" == "4" ]]; then
	if [[ "$3" == "-i" ]]; then
		fichero_ignorar="$4"
	else
		uso_correcto
	fi
fi

if [[ "$fichero_ignorar" != "" ]] ; then
	if [[ ! -f $fichero_ignorar ]] ; then
		echo "No existe el fichero $fichero_ignorar"
		exit 1
	fi
fi

BASEDIR=$(dirname $0)

. $BASEDIR/setCheck.sh 

modified_files2="cat $1"
function SQL_rules() {
	for f in `eval $modified_files2`; do
		ignoramos="0"
		if [[ "$fichero_ignorar" != "" ]] ; then
			ignoramos=`fgrep -c "$f" $fichero_ignorar`
		fi
		if [[ "$ignoramos" == "0" ]] ; then
	 		check_pitertul_format $f dir 
	 	else
	 		echo "Ingorarmos fichero $f (incluido en lista de ficheros a ignorar $fichero_ignorar)"
	 	fi
	done

	if [[ -f $BASEDIR/marca_error ]] ; then
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