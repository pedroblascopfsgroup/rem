#!/bin/bash +x

DIRECTORIO=$1
if [[ "$DIRECTORIO" == "" ]] ; then
	echo "Uso: $0 <directorio-git>"
	exit 1
fi

if [[ ! -d "$DIRECTORIO" ]] ; then
	echo "'$DIRECTORIO' no es un directorio."
	exit 1
fi

if [[ ! -d "${DIRECTORIO}/.git" ]] ; then
	echo "'$DIRECTORIO' no es un directorio que albergue un repositorio git."
	exit 1
fi

if [[ ! -d "${DIRECTORIO}/sql" ]] ; then
	echo "No existe el directorio '$DIRECTORIO/sql'."
	exit 1
fi

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

function SQL_names() {
	echo -e "${GREEN}REVISANDO FICHEROS sql${NC}\n**********************************************************"
	ficheros_sql=`find ${DIRECTORIO}/sql/ -regex ".*\.sql" | grep -e "$DIRECTORIO\/sql/" | grep  -E \/D.*\.sql$ | grep -v no_protocolo/ | grep -v tmp/  | grep -v pitertul/ | grep -v ^reports/ | grep -v migracion | grep -v scripts | grep -v templates | grep -v rutinas  | grep -v produccion | grep -v informacional_old | grep -v usuario_propietario | grep -v 9.1`

	patron="^D[D|M]L_[0-9]{3,5}_(ENTITY0[0-9]|BANK01|HAYA0[0-9]|REM01|CM01|HAYAMASTER|REMMASTER|MASTER|BANKMASTER|CMMASTER|MINIREC|DWH|DS)_.*\.sql"
	ok=0
	for fichero in $ficheros_sql ; do
		fsinpath=${fichero##*/}
		if [[ ! $fsinpath =~ $patron ]] ; then 
			echo -e "Nombre de script incorrecto:${RED} $fichero ${NC}"
			ok=1
		fi
	done
	if [[ "$ok" == "1" ]] ; then
		echo -e "*********************************************************\nSe han detectado errores en los nombres de algunos scripts:"
		echo -e "El nombre del fichero debe cumplir esta expresión regular:\n$patron"
	fi
}

########################################################
##### MAIN
########################################################

SQL_names

exit 0;
