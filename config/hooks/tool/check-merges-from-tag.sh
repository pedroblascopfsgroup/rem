#!/bin/bash

clear
dir_retorno=`pwd` 

mostrar_error() {
	echo -e "\n$1\n"
	cd $dir_retorno
	exit 1
}

merge_valido() {

	r_hasta=$1
	r_desde=$2
	ruta_origen=$3
	ruta_destino=$4

	resultado=1
	if [[ "$ruta_origen" == "@" ]] && [[ "$r_hasta" == "$ruta_destino" ]] ; then
		resultado=0
	fi
	if [[ "$ruta_origen" == "@r_desde" ]] && [[ "$r_hasta" == "@" ]] ; then
		resultado=0
	fi
	if [[ "$ruta_origen" == "@r_desde" ]] && [[ "$r_hasta" == "$ruta_destino" ]] ; then
		resultado=0
	fi
	if [[ "$r_hasta" == "$r_desde" ]] ; then
		resultado=0
	fi
	echo "$resultado"

}

if [ "$#" != "2" ] ; then
	mostrar_error "Uso: $0 <ruta_repositorio_git> <tag_desde>"
fi

ruta=$1
if [ ! -d $ruta ] ; then
	mostrar_error "No existe el directorio '$ruta'"
fi

cd $ruta

if [ ! -d .git ] ; then
	mostrar_error "El directorio '$ruta' no contiene ningún repositorio de git"
fi

tag=$2
existe_tag=`git tag -l $tag | wc -l`
if [ "$existe_tag" == "0" ] ; then
	mostrar_error "El tag '$tag' no existe"
fi

rama_actual=`git rev-parse --abbrev-ref HEAD`
tag_en_rama_actual=`git branch --contains tags/$tag | grep $rama_actual | wc -l`
if [ "$tag_en_rama_actual" == "0" ] ; then
	mostrar_error "El tag especificado '$tag' no existe en la rama actual $rama_actual"
fi

ficherorutas=${dir_retorno}/rutas-permitidas
if [ ! -f $ficherorutas ] ; then
	mostrar_error "No existe el fichero '$ficherorutas'"
fi

echo -e "\n********************************************************************************************"
echo -e "  MERGES IRREGULARES DETECTADOS EN $rama_actual DESDE EL TAG $tag"
echo -e "********************************************************************************************"
for commit in `git rev-list --merges $tag..HEAD` ; do  
	es_merge_manual=`git cat-file -p $commit | grep "Merge branch" | wc -l`
	if [ "$es_merge_manual" == "1" ] ; then
		committer=`git cat-file -p $commit | grep committer | cut -d"<" -f2 | cut -d">" -f1`
		rama_desde=`git cat-file -p $commit | grep "Merge branch" | cut -d"'" -f2`
		rama_hasta=`git cat-file -p $commit | grep "Merge branch" | sed 's/.* //'`

		resultado=0
		for ruta in `cat $ficherorutas` ; do  
			origen=`echo "$ruta" | cut -d '|' -f1`
			destino=`echo "$ruta" | cut -d '|' -f2`
			resultado=`merge_valido $rama_hasta $rama_desde $origen $destino`
			if [[ "$resultado" == "1" ]] ; then
				break
			fi
		done
		if [[ "$resultado" == "1" ]] ; then
			echo -e "\n=== Merge irregular (ruta desde rama $rama_desde hasta $rama_hasta no permitida): $commit ($committer)"
		fi
		committer_en_lista=`cat ${dir_retorno}/lista-acl | grep $committer | wc -l`
		if [ "$committer_en_lista" == "0" ] ; then
			echo -e "\n=== Merge irregular (committer no autorizado): $commit ($committer) -> de $rama_desde a $rama_hasta"
		fi
	fi
done

echo -e "\n*******************************************************************************************\n"

cd $dir_retorno
exit 0
