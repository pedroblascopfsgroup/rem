#!/bin/bash +x

DIR_ORIGEN=$(pwd)

error() {
	clear
	mensaje="$1"
	echo -e "Error:\n\n${mensaje}\n"
	cd $DIR_ORIGEN
	exit 1
}

if [[ "$#" != "4" ]] ; then
	error "Número de parámetros erróneo.\n\nUso: $0 <directorio-git> <tag-inicial> <tag-final> <lista-proyectos-separados-por-comas>"
fi

DIRECTORIO=$1
TAG1=$2
TAG2=$3
PROYECTOS=$4

if [ ! -d $DIRECTORIO ] ; then
	error "Directorio $DIRECTORIO no existe"
fi

if [ ! -d ${DIRECTORIO}/.git ] ; then
	error "Directorio $DIRECTORIO no es un directorio de git"
fi

cd $DIRECTORIO

TAG1_EXISTE=`git tag -l | grep "^${TAG1}\$" | wc -l`
if [[ "$TAG1_EXISTE" != "1" ]] ; then
	error "El tag inicial $TAG1 no existe"
fi

TAG2_EXISTE=`git tag -l | grep "^${TAG2}\$" | wc -l`
if [[ "$TAG2_EXISTE" != "1" ]] ; then
	error "El tag final $TAG2 no existe"
fi

echo "**************************************************************"
echo "PROYECTOS gestionados entre los tags $TAG1 y $TAG2"
echo "**************************************************************"

rm -rf ${DIR_ORIGEN}/salida.txt
rm -rf ${DIR_ORIGEN}/commits.txt

IFS=','
for proyecto in $PROYECTOS ; do 
	echo "Procesando commits del proyecto: $proyecto"
	echo "---------------------------------------------------------------"
	git log --no-merges --oneline ${TAG1}..${TAG2} -i --grep="$proyecto" | tee -a ${DIR_ORIGEN}/salida.txt
	echo "---------------------------------------------------------------"
done

IFS=','
for proyecto in $PROYECTOS ; do 
	echo -e "\n--- Commits detectados del proyecto: $proyecto ---------------"
	IFS=$'\n'
	for linea in `cat ${DIR_ORIGEN}/salida.txt` ; do 
		linea=`echo "$linea" | tr '[[:lower:]]' '[[:upper:]]'`
		if [[ "$linea" =~ ${proyecto}-[[:digit:]]+ ]]; then
			item=${BASH_REMATCH}
			echo $item | tee -a ${DIR_ORIGEN}/commits.txt
		fi
	done
done

sort -u ${DIR_ORIGEN}/commits.txt | sed '/^$/d' | uniq > ${DIR_ORIGEN}/commits2.txt
mv ${DIR_ORIGEN}/commits2.txt ${DIR_ORIGEN}/commits.txt
echo -e "\n---------------------------------------------------------------"
echo "Todos los commits entre los dos tags ($TAG1 y $TAG2) se han generado en el fichero ${DIR_ORIGEN}/commits.txt"
echo "Además, toda la información sobre commits y mensajes se puede consultar en el fichero ${DIR_ORIGEN}/salida.txt"
echo "---------------------------------------------------------------"

IFS=$OLDIFS
