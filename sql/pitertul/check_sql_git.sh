#!/bin/bash +x

function uso_correcto() {
	echo "Uso correcto: $0 <tag-desde> <tag-hasta> [-v]"
 	exit 1	
}


if [[ $# -ne 5  && $# -ne 4  && $# -ne 3  && $# -ne 2 ]] ; then
   uso_correcto
fi


verbose="NO"
if [[ "$#" == "3" ]]; then
	if [[ "$3" == "-v" ]]; then
		verbose="SI"
	else
		uso_correcto
	fi
fi

tag_desde=$1
tag_hasta=$2

BASEDIR=$(dirname $0)

git diff $tag_desde $tag_hasta --name-only | grep "D.*sql" > $BASEDIR/tmp/lista_ficheros_git.txt

. $BASEDIR/setCheck.sh 

fichero_ignorar=$BASEDIR/lista_ficheros_ignorar.txt

modified_files2="cat $BASEDIR/tmp/lista_ficheros_git.txt"
function SQL_rules() {
	for f in `eval $modified_files2`; do
		ignoramos="0"
		if [[ "$fichero_ignorar" != "" ]] ; then
			ignoramos=`fgrep -c "$f" $fichero_ignorar`
		fi
		if [[ "$ignoramos" == "0" ]] ; then	
			if [[ -e "$f" ]] ; then
		 		check_pitertul_format $f dir 
		 	fi
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