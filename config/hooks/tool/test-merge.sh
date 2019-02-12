#!/bin/bash

clear
dir_merges=$(dirname "$0")

mostrar_error() {
	echo -e "\n$1\n"
	exit 1
}

merge_valido() {

	r_actual=`echo $1 | sed 's/@/.+/'`
	r_merge=`echo $2 | sed 's/@/.+/'`
	ruta_origen=`echo $3 | sed 's/@/.+/'`
	ruta_destino=`echo $4 | sed 's/@/.+/'`

	if [[ $ruta_origen =~ $r_merge ]] && [[ $r_actual =~ $ruta_destino ]] ; then
		echo -e "\nMerge permitido desde $r_merge a $r_actual.\n"
		exit 0
	fi

}

ficherorutas=${dir_merges}/rutas-permitidas
if [ ! -f $ficherorutas ] ; then
	mostrar_error "No existe el fichero '$ficherorutas'"
fi

if [ "$#" != "2" ] ; then
	mostrar_error "Uso: $0 <ruta_repositorio_git> <rama_origen_merge>"
fi

ruta=$1
if [ ! -d $ruta ] ; then
	mostrar_error "No existe el directorio '$ruta'"
fi

cd $ruta

if [ ! -d .git ] ; then
	mostrar_error "El directorio '$ruta' no contiene ningún repositorio de git"
fi

echo "************************************************"
echo "** COMPROBACIÓN DE MERGE VÁLIDO ****************"
echo "************************************************"
rama_actual=`git branch | grep '*' | cut -d' ' -f2`
echo "Rama actual: $rama_actual" 
rama_merge=$2
echo "Rama origen: $rama_merge" 
committer=`git config user.email`
echo "Commiter: $committer"
echo "************************************************"

committer_en_lista=`cat ${dir_merges}/lista-acl | grep $committer | wc -l`
if [ "$committer_en_lista" == "0" ] ; then
	mostrar_error "Merge irregular (committer no autorizado): $committer. Ponte en contacto con tu coordinador."
fi

if [ "$rama_actual" == "$rama_merge" ] ; then
	mostrar_error "La rama actual no puede ser la misma que la rama de merge"
fi

for ruta in `cat $ficherorutas` ; do  
	origen=`echo "$ruta" | cut -d '|' -f1`
	destino=`echo "$ruta" | cut -d '|' -f2`
	merge_valido $rama_actual $rama_merge $origen $destino
done

mostrar_error "Merge irregular. No permitido desde la rama $rama_merge a la rama $rama_actual. Ponte en contacto con tu coordinador."
