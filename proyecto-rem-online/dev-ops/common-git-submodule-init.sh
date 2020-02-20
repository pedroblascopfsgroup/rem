#!/bin/bash +x
set -e # Para errores
git submodule init
user=$1

if [ "$user" == "" ]; then
	user="jenkins"
fi

if [ -d fwk ]; then
	git rm fwk
fi

sed -e "s/\/\/git/\/\/${user}\@git/g" -i .git/config
git submodule update --remote --merge